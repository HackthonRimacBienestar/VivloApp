import 'package:flutter/material.dart';
import 'package:follow_well/core/services/audio_recorder_service.dart';
import 'package:follow_well/core/services/elevenlabs_service.dart';
import 'package:follow_well/features/voice_dictation/logic/voice_dictation_controller.dart';

class VoiceDictationPage extends StatefulWidget {
  const VoiceDictationPage({super.key});

  @override
  State<VoiceDictationPage> createState() => _VoiceDictationPageState();
}

class _VoiceDictationPageState extends State<VoiceDictationPage> {
  late VoiceDictationController _controller;
  final TextEditingController _textEditingController = TextEditingController();

  final String _apiKey = 'sk_d7404fc5d2fae007e261700456169fae996ea7800f00b719';

  @override
  void initState() {
    super.initState();
    _controller = VoiceDictationController(
      audioService: AudioRecorderService(),
      elevenLabsService: ElevenLabsService(apiKey: _apiKey),
    );
    _controller.init();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    setState(() {
      if (_controller.status == DictationStatus.finished) {
        if (_textEditingController.text != _controller.finalText.trim()) {
          _textEditingController.text = _controller.finalText.trim();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dictado por Voz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_controller.status == DictationStatus.finished)
                        TextField(
                          controller: _textEditingController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'El texto aparecerá aquí...',
                          ),
                        )
                      else ...[
                        Text(
                          _controller.finalText,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _controller.partialText,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_controller.status == DictationStatus.listening)
              const Text(
                'Escuchando...',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_controller.status == DictationStatus.idle ||
                    _controller.status == DictationStatus.finished)
                  ElevatedButton.icon(
                    onPressed: () => _controller.startDictation(),
                    icon: const Icon(Icons.mic),
                    label: Text(
                      _controller.status == DictationStatus.finished
                          ? 'Volver a dictar'
                          : 'Hablar',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                if (_controller.status == DictationStatus.listening)
                  ElevatedButton.icon(
                    onPressed: () => _controller.stopDictation(),
                    icon: const Icon(Icons.stop),
                    label: const Text('Detener'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
            if (_controller.status == DictationStatus.finished) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Texto confirmado')),
                  );
                },
                child: const Text('Confirmar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
