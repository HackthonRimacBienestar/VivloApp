import 'dart:async';
import 'dart:typed_data';
import 'package:sound_stream/sound_stream.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  final RecorderStream _recorder = RecorderStream();
  StreamSubscription<Uint8List>? _audioSubscription;

  final StreamController<Uint8List> _audioStreamController =
      StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get audioStream => _audioStreamController.stream;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  Future<void> initialize() async {
    await _recorder.initialize();
  }

  Future<bool> startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    _audioSubscription = _recorder.audioStream.listen((data) {
      _audioStreamController.add(data);
    });

    await _recorder.start();
    _isRecording = true;
    return true;
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    _isRecording = false;
  }

  void dispose() {
    stopRecording();
    _audioStreamController.close();
  }
}
