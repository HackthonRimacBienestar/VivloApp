import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../logic/voice_agent_controller.dart';

class VoiceAgentPage extends StatefulWidget {
  const VoiceAgentPage({super.key});

  @override
  State<VoiceAgentPage> createState() => _VoiceAgentPageState();
}

class _VoiceAgentPageState extends State<VoiceAgentPage> {
  late VoiceAgentController _controller;
  final ScrollController _scrollController = ScrollController();

  // TODO: Mover a variables de entorno o almacenamiento seguro
  final String _apiKey = 'sk_0417208ccf92424c354188237a040542da4d495104accf09';
  final String _agentId = 'agent_5001kan5xjsqeqhtv1jyx5hce31j';

  @override
  void initState() {
    super.initState();
    _controller = VoiceAgentController(apiKey: _apiKey, agentId: _agentId);
    _controller.addListener(_onControllerUpdate);

    // Auto-conectar al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndConnect();
    });
  }

  Future<void> _checkPermissionsAndConnect() async {
    await Permission.microphone.request();
    _controller.connect();
  }

  void _onControllerUpdate() {
    setState(() {});
    // Auto-scroll al final si hay nuevos mensajes
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente de Salud'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.disconnect();
              _controller.connect();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.all(8),
            color: _controller.isConnected
                ? Colors.green[100]
                : Colors.red[100],
            width: double.infinity,
            child: Text(
              'Estado: ${_controller.status}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _controller.isConnected
                    ? Colors.green[800]
                    : Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Chat Area
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                if (_controller.userTranscript.isNotEmpty)
                  _ChatBubble(text: _controller.userTranscript, isUser: true),
                if (_controller.agentResponse.isNotEmpty)
                  _ChatBubble(text: _controller.agentResponse, isUser: false),
              ],
            ),
          ),

          // Controls
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GestureDetector(
                  onLongPressStart: (_) => _controller.startListening(),
                  onLongPressEnd: (_) => _controller.stopListening(),
                  // También soportar tap para toggle si se prefiere
                  // onTap: () => _controller.isListening ? _controller.stopListening() : _controller.startListening(),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: _controller.isListening ? Colors.red : Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_controller.isListening
                                      ? Colors.red
                                      : Colors.blue)
                                  .withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _controller.isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _controller.isListening
                      ? 'Escuchando...'
                      : 'Mantén presionado para hablar',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nota: No es un diagnóstico médico.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
