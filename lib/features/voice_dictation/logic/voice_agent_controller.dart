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
    _status = "Conectando...";
    _safeNotifyListeners();

    await _elevenService.connect(
      onReady: () {
        if (_isDisposed) return;
        _isConnected = true;
        _status = "Conectado";
        _safeNotifyListeners();
      },
      onUserTranscript: (text) {
        if (_isDisposed) return;
        _userTranscript = text;
        _safeNotifyListeners();
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
      },
    );
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
