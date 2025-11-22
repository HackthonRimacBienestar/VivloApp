import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ElevenAgentService {
  final String apiKey;
  final String agentId;

  IOWebSocketChannel? _channel;

  // Callbacks
  void Function()? onReady;
  void Function(String text)? onUserTranscript;
  void Function(String text)? onAgentResponse;
  void Function(Uint8List audioBytes)? onAudioChunk;
  void Function(String error)? onError;

  ElevenAgentService({required this.apiKey, required this.agentId});

  Future<void> connect({
    void Function()? onReady,
    void Function(String)? onUserTranscript,
    void Function(String)? onAgentResponse,
    void Function(Uint8List)? onAudioChunk,
    void Function(String)? onError,
  }) async {
    this.onReady = onReady;
    this.onUserTranscript = onUserTranscript;
    this.onAgentResponse = onAgentResponse;
    this.onAudioChunk = onAudioChunk;
    this.onError = onError;

    try {
      final uri = Uri.parse(
        'wss://api.elevenlabs.io/v1/convai/conversation?agent_id=$agentId',
      );

      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {'xi-api-key': apiKey},
      );

      // Escuchar el stream
      _channel!.stream.listen(
        (data) {
          _handleMessage(data);
        },
        onError: (error) {
          print('WebSocket Error: $error');
          this.onError?.call(error.toString());
        },
        onDone: () {
          print(
            'WebSocket Closed. Code: ${_channel?.closeCode}, Reason: ${_channel?.closeReason}',
          );
        },
      );

      // Enviar mensaje de inicialización (opcional, pero recomendado)
      // Esto configura el idioma y otros parámetros si es necesario
      /*
      final initMsg = {
        "type": "conversation_initiation_client_data",
        "conversation_config_override": {
          "agent": {
            "language": "es", 
          }
        }
      };
      _channel!.sink.add(jsonEncode(initMsg));
      */
    } catch (e) {
      print('Connection Error: $e');
      this.onError?.call(e.toString());
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      final type = json['type'];

      switch (type) {
        case 'conversation_initiation_metadata':
          print('Session Started: ${json['conversation_id']}');
          onReady?.call();
          break;

        case 'user_transcript':
          final event = json['user_transcription_event'];
          if (event != null) {
            final text = event['user_transcript'] as String;
            onUserTranscript?.call(text);
          }
          break;

        case 'agent_response':
          final event = json['agent_response_event'];
          if (event != null) {
            final text = event['agent_response'] as String;
            onAgentResponse?.call(text);
          }
          break;

        case 'audio':
          final event = json['audio_event'];
          if (event != null) {
            final b64 = event['audio_base_64'] as String;
            final bytes = base64Decode(b64);
            print(
              'ElevenAgentService: Received audio chunk of ${bytes.length} bytes',
            );
            onAudioChunk?.call(bytes);
          } else {
            print(
              'ElevenAgentService: Received audio message but event is null',
            );
          }
          break;

        case 'ping':
          // Responder al ping si es necesario, aunque la librería suele manejarlo
          break;

        default:
          // print('Unknown message type: $type');
          break;
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void sendAudioChunk(Uint8List pcmBytes) {
    if (_channel == null) return;

    try {
      final b64 = base64Encode(pcmBytes);
      final msg = {"user_audio_chunk": b64};
      _channel!.sink.add(jsonEncode(msg));
    } catch (e) {
      print('Error sending audio chunk: $e');
    }
  }

  void dispose() {
    _channel?.sink.close(status.normalClosure);
    _channel = null;
  }
}
