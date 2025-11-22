import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';
import '../../../core/services/audio_recorder_service.dart';
import '../../../core/services/eleven_agent_service.dart';

class VoiceAgentController extends ChangeNotifier {
  final ElevenAgentService _elevenService;
  final AudioRecorderService _audioRecorder;
  final PlayerStream _player = PlayerStream();

  StreamSubscription? _micSubscription;

  // State
  bool _isConnected = false;
  bool _isListening = false;
  String _userTranscript = "";
  String _agentResponse = "";
  String _status = "Desconectado";

  bool _isDisposed = false;

  bool _userInitiatedDisconnect = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 2);
  Timer? _reconnectTimer;

  // Getters
  bool get isConnected => _isConnected;
  bool get isListening => _isListening;
  String get userTranscript => _userTranscript;
  String get agentResponse => _agentResponse;
  String get status => _status;

  VoiceAgentController({required String apiKey, required String agentId})
    : _elevenService = ElevenAgentService(apiKey: apiKey, agentId: agentId),
      _audioRecorder = AudioRecorderService() {
    _init();
  }

  Future<void> _init() async {
    await _audioRecorder.initialize();
    await _player.initialize();
    await _player.start(); // Ensure player is started
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> connect() async {
    _userInitiatedDisconnect = false;
    _reconnectTimer?.cancel();

    _status = "Conectando...";
    _safeNotifyListeners();

    await _elevenService.connect(
      onReady: () {
        if (_isDisposed) return;
        _isConnected = true;
        _reconnectAttempts = 0; // Reset attempts on success
        _status = "Conectado";
        _safeNotifyListeners();
      },
      onUserTranscript: (text) {
        if (_isDisposed) return;
        _userTranscript = text;
        _safeNotifyListeners();
        // Server VAD detected end of speech, stop listening locally
        if (_isListening) {
          stopListening();
        }
      },
      onAgentResponse: (text) {
        if (_isDisposed) return;
        _agentResponse = text;
        _status = "Conectado"; // Reset status to ready
        _safeNotifyListeners();
      },
      onAudioChunk: (bytes) {
        if (_isDisposed) return;
        print('VoiceAgentController: Writing ${bytes.length} bytes to player');
        _player.writeChunk(bytes);
      },
      onError: (error) {
        if (_isDisposed) return;
        _status = "Error: $error";
        _isConnected = false;
        _safeNotifyListeners();
        _attemptReconnect();
      },
      onDisconnect: (code, reason) {
        if (_isDisposed) return;
        _isConnected = false;

        // Check for fatal errors
        if (reason != null &&
            (reason.toLowerCase().contains('quota') ||
                reason.toLowerCase().contains('unauthorized'))) {
          _status = "Error: $reason";
          _safeNotifyListeners();
          // Do NOT reconnect
          return;
        }

        _status = "Desconectado";
        _safeNotifyListeners();
        _attemptReconnect();
      },
    );
  }

  void _attemptReconnect() {
    if (_userInitiatedDisconnect || _isDisposed) return;

    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      _status = "Reconectando ($_reconnectAttempts/$_maxReconnectAttempts)...";
      _safeNotifyListeners();

      _reconnectTimer = Timer(_reconnectDelay * _reconnectAttempts, () {
        if (!_isDisposed && !_userInitiatedDisconnect) {
          connect();
        }
      });
    } else {
      _status = "No se pudo reconectar. Intente manualmente.";
      _safeNotifyListeners();
    }
  }

  Future<void> toggleListening() async {
    if (_isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> startListening() async {
    if (!_isConnected) return;

    _isListening = true;
    _status = "Escuchando...";
    _safeNotifyListeners();

    await _audioRecorder.startRecording();
    _micSubscription = _audioRecorder.audioStream.listen((bytes) {
      if (!_isDisposed) {
        _elevenService.sendAudioChunk(bytes);
      }
    });
  }

  Future<void> stopListening() async {
    _isListening = false;
    _status = "Procesando...";
    _safeNotifyListeners();

    await _micSubscription?.cancel();
    _micSubscription = null;
    await _audioRecorder.stopRecording();
  }

  Future<void> disconnect() async {
    _userInitiatedDisconnect = true;
    _reconnectTimer?.cancel();
    await stopListening();
    _elevenService.dispose();
    _isConnected = false;
    _status = "Desconectado";
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    disconnect();
    _audioRecorder.dispose();
    _player.dispose();
    super.dispose();
  }
}
