import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/io.dart';

class ElevenLabsService {
  IOWebSocketChannel? _channel;
  final String apiKey;

  final _transcriptionController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get transcriptionStream =>
      _transcriptionController.stream;

  ElevenLabsService({required this.apiKey});

  Future<void> startSession() async {
    final uri = Uri.parse(
      'wss://api.elevenlabs.io/v1/speech-to-text/realtime'
      '?model_id=scribe_v2_realtime'
      '&audio_format=pcm_16000'
      '&sample_rate=16000'
      '&language_code=es'
      '&commit_strategy=vad',
    );

    try {
      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {'xi-api-key': apiKey},
      );

      _channel!.stream.listen(
        (data) {
          final json = jsonDecode(data);
          _transcriptionController.add(json);
        },
        onError: (error) {
          _transcriptionController.addError(error);
        },
        onDone: () {
          // Handle connection closed
        },
      );
    } catch (e) {
      _transcriptionController.addError(e);
    }
  }

  void sendAudioChunk(Uint8List bytes) {
    if (_channel == null) return;

    final msg = {
      "message_type": "input_audio_chunk",
      "audio_base_64": base64Encode(bytes),
      "sample_rate": 16000,
      "commit": false,
    };

    _channel!.sink.add(jsonEncode(msg));
  }

  Future<void> endSession() async {
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _transcriptionController.close();
    endSession();
  }
}
