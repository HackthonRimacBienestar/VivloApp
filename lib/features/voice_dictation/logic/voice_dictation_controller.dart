import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:follow_well/core/services/audio_recorder_service.dart';
import 'package:follow_well/core/services/elevenlabs_service.dart';

enum DictationStatus { idle, listening, processing, finished }

class VoiceDictationController extends ChangeNotifier {
  final AudioRecorderService _audioService;
  final ElevenLabsService _elevenLabsService;

  DictationStatus _status = DictationStatus.idle;
  DictationStatus get status => _status;

  String _partialText = '';
  String get partialText => _partialText;

  String _finalText = '';
  String get finalText => _finalText;

  StreamSubscription? _audioSubscription;
  StreamSubscription? _transcriptionSubscription;

  VoiceDictationController({
    required AudioRecorderService audioService,
    required ElevenLabsService elevenLabsService,
  }) : _audioService = audioService,
       _elevenLabsService = elevenLabsService;

  Future<void> init() async {
    await _audioService.initialize();

    _transcriptionSubscription = _elevenLabsService.transcriptionStream.listen((
      data,
    ) {
      final type = data['message_type'];
      if (type == 'partial_transcript') {
        _partialText = data['text'] ?? '';
        notifyListeners();
      } else if (type == 'committed_transcript') {
        _finalText += (data['text'] ?? '') + ' ';
        _partialText = '';
        notifyListeners();
      }
    });
  }

  Future<void> startDictation() async {
    _finalText = '';
    _partialText = '';
    _status = DictationStatus.listening;
    notifyListeners();

    await _elevenLabsService.startSession();
    final granted = await _audioService.startRecording();

    if (!granted) {
      _status = DictationStatus.idle;
      notifyListeners();
      return;
    }

    _audioSubscription = _audioService.audioStream.listen((bytes) {
      _elevenLabsService.sendAudioChunk(bytes);
    });
  }

  Future<void> stopDictation() async {
    _status = DictationStatus.processing;
    notifyListeners();

    await _audioService.stopRecording();
    await _audioSubscription?.cancel();

    await Future.delayed(Duration(milliseconds: 500));
    await _elevenLabsService.endSession();

    _status = DictationStatus.finished;
    notifyListeners();
  }

  void reset() {
    _status = DictationStatus.idle;
    _finalText = '';
    _partialText = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _audioSubscription?.cancel();
    _transcriptionSubscription?.cancel();
    super.dispose();
  }
}
