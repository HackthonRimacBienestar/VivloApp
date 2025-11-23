import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';
import '../../../core/services/audio_recorder_service.dart';
import '../../../core/services/eleven_agent_service.dart';
import '../data/voice_data_repository.dart';

class VoiceAgentController extends ChangeNotifier {
  final ElevenAgentService _elevenService;
  final AudioRecorderService _audioRecorder;
  final PlayerStream _player = PlayerStream();
  final VoiceDataRepository _repository = VoiceDataRepository();

  StreamSubscription? _micSubscription;

  // State
  bool _isConnected = false;
  bool _isListening = false;
  bool _isAgentSpeaking = false;
  String _userTranscript = "";
  String _agentResponse = "";
  String _status = "Desconectado";
  String? _currentConversationId;

  bool _isDisposed = false;

  bool _userInitiatedDisconnect = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 2);
  Timer? _reconnectTimer;
  Timer? _agentSpeakingTimer;
  static const Duration _agentSpeakingGrace = Duration(milliseconds: 350);

  // Getters
  bool get isConnected => _isConnected;
  bool get isListening => _isListening;
  bool get isAgentSpeaking => _isAgentSpeaking;
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
        startListening(); // Auto-start listening when connected
      },
      onSessionStarted: (conversationId) {
        _currentConversationId = conversationId;
        _repository.createConversation(conversationId);
      },
      onUserTranscript: (text) {
        if (_isDisposed) return;
        _userTranscript = text;
        if (_currentConversationId != null) {
          _repository.addMessage(
            conversationId: _currentConversationId!,
            role: 'user',
            content: text,
          );
        }
        _safeNotifyListeners();
        // Continuous conversation: Do NOT stop listening here.
        // The server VAD or user manual stop will handle it.
      },
      onAgentResponse: (text) {
        if (_isDisposed) return;
        _agentResponse = text;
        if (_currentConversationId != null) {
          _repository.addMessage(
            conversationId: _currentConversationId!,
            role: 'agent',
            content: text,
          );
        }
        _status = "Conectado"; // Reset status to ready
        _safeNotifyListeners();
      },
      onAudioChunk: (bytes) {
        if (_isDisposed) return;
        print('VoiceAgentController: Writing ${bytes.length} bytes to player');
        _player.writeChunk(bytes);
        _handleAgentSpeakingActivity();
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

  void _handleAgentSpeakingActivity() {
    bool shouldNotify = false;

    if (!_isAgentSpeaking) {
      _isAgentSpeaking = true;
      shouldNotify = true;
    }

    _agentSpeakingTimer?.cancel();
    _agentSpeakingTimer = Timer(_agentSpeakingGrace, () {
      _isAgentSpeaking = false;
      _safeNotifyListeners();
    });

    if (shouldNotify) {
      _safeNotifyListeners();
    }
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
    _isAgentSpeaking = false;
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
    _isAgentSpeaking = false;
    _status = "Procesando...";
    _safeNotifyListeners();

    await _micSubscription?.cancel();
    _micSubscription = null;
    await _audioRecorder.stopRecording();
  }

  Future<void> disconnect() async {
    _userInitiatedDisconnect = true;
    _reconnectTimer?.cancel();
    _agentSpeakingTimer?.cancel();
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
    _agentSpeakingTimer?.cancel();
    super.dispose();
  }
}
