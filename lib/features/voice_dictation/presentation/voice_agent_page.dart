import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/ui/theme/colors.dart';
import '../../../core/ui/theme/typography.dart';
import '../../../core/ui/theme/gradients.dart';
import '../logic/voice_agent_controller.dart';

class VoiceAgentPage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const VoiceAgentPage({super.key, this.onBackPressed});

  @override
  State<VoiceAgentPage> createState() => _VoiceAgentPageState();
}

class _VoiceAgentPageState extends State<VoiceAgentPage>
    with TickerProviderStateMixin {
  late VoiceAgentController _controller;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _micAnimationController;
  late Animation<double> _micScaleAnimation;
  late Animation<double> _micGlowAnimation;
  late AnimationController _mascotAnimationController;
  late Animation<double> _mascotBounceAnimation;
  late Animation<double> _mascotPulseAnimation;

  // TODO: Mover a variables de entorno o almacenamiento seguro
  final String _apiKey = 'sk_d7404fc5d2fae007e261700456169fae996ea7800f00b719';
  final String _agentId = 'agent_9001kam6k6aqesna12cggeg5py44';

  @override
  void initState() {
    super.initState();
    _controller = VoiceAgentController(apiKey: _apiKey, agentId: _agentId);
    _controller.addListener(_onControllerUpdate);

    // Animación del micrófono
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );
    _micGlowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );

    // Animación de la mascota (bounce sutil y pulse)
    _mascotAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _mascotBounceAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _mascotAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _mascotPulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _mascotAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Auto-conectar al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndConnect();
    });
  }

  Future<void> _checkPermissionsAndConnect() async {
    await Permission.microphone.request();
    _controller.connect();
  }

  String _getMascotAsset() {
    if (_controller.isAgentSpeaking) {
      return 'assets/osito2sinfondo.png';
    }
    return 'assets/osito1sinfondo.png';
  }

  void _onControllerUpdate() {
    setState(() {});

    // Reaccionar a cambios de estado del micrófono
    if (_controller.isListening) {
      _micAnimationController.duration = const Duration(milliseconds: 800);
      if (!_micAnimationController.isAnimating) {
        _micAnimationController.repeat(reverse: true);
      }
    } else {
      _micAnimationController.duration = const Duration(milliseconds: 2000);
      if (!_micAnimationController.isAnimating) {
        _micAnimationController.repeat(reverse: true);
      }
    }

    // Auto-scroll al final si hay nuevos mensajes
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    _micAnimationController.dispose();
    _mascotAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMessages =
        _controller.userTranscript.isNotEmpty ||
        _controller.agentResponse.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softAmbient),
        child: SafeArea(
          child: Column(
            children: [
              // Chat Area or Hero Area
              Expanded(child: _buildChatArea(hasMessages)),

              // Bottom Controls Panel
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.ink, size: 20),
        ),
        onPressed: () {
          if (widget.onBackPressed != null) {
            widget.onBackPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
        tooltip: 'Volver',
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Soporte por voz',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          _buildConnectionStatus(),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.refresh, color: AppColors.ink, size: 20),
          ),
          onPressed: () {
            _controller.disconnect();
            _controller.connect();
          },
          tooltip: 'Reconectar',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    Color statusColor;
    String statusText;

    if (_controller.isConnected) {
      statusColor = AppColors.statusSuccess;
      statusText = 'Conectado';
    } else if (_controller.status.contains('Error')) {
      statusColor = AppColors.statusError;
      statusText = 'Error de conexión';
    } else if (_controller.status.contains('Conectando')) {
      statusColor = AppColors.statusWarning;
      statusText = 'Conectando...';
    } else {
      statusColor = AppColors.statusOffline;
      statusText = 'Desconectado';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: AppTypography.caption.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(bool hasMessages) {
    if (!hasMessages) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mascota del asistente con animación sutil y glow
            AnimatedBuilder(
              animation: _mascotAnimationController,
              builder: (context, child) {
                final mascotAsset = _getMascotAsset();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect background
                    Transform.scale(
                      scale: _mascotPulseAnimation.value * 1.2,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accentPrimary.withOpacity(0.2),
                              AppColors.accentPrimary.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.7],
                          ),
                        ),
                      ),
                    ),
                    // Mascot Image
                    Transform.translate(
                      offset: Offset(0, -_mascotBounceAnimation.value),
                      child: Transform.scale(
                        scale: _mascotPulseAnimation.value,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeInBack,
                          child: Image.asset(
                            mascotAsset,
                            key: ValueKey(mascotAsset),
                            height: 240,
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              '¿En qué puedo ayudarte hoy?',
              style: AppTypography.title.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Toca el micrófono para comenzar a hablar',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkSoft,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // Spacer to push content down if few messages
        const SizedBox(height: 20),
        // Mensaje del usuario (si existe)
        if (_controller.userTranscript.isNotEmpty)
          _ChatBubble(
            text: _controller.userTranscript,
            isUser: true,
            timestamp: DateTime.now(),
          ),
        // Mensaje del agente (si existe)
        if (_controller.agentResponse.isNotEmpty)
          _ChatBubble(
            text: _controller.agentResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.5))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Microtexto de ayuda con animación
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _getHelpText(),
              key: ValueKey(_getHelpText()),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkSoft,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Botón de micrófono grande y centrado
          _buildMicrophoneButton(),
        ],
      ),
    );
  }

  String _getHelpText() {
    if (!_controller.isConnected) {
      return 'Conectando con soporte...';
    }
    if (_controller.isListening) {
      return 'Escuchando...';
    }
    if (_controller.status.contains('Procesando')) {
      return 'Procesando tu mensaje...';
    }
    return 'Toca para hablar';
  }

  Widget _buildMicrophoneButton() {
    final isActive = _controller.isListening;
    final isDisabled =
        !_controller.isConnected ||
        _controller.status.contains('Error') ||
        _controller.status.contains('Procesando');

    return GestureDetector(
      onTap: isDisabled ? null : () => _controller.toggleListening(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_micScaleAnimation, _micGlowAnimation]),
        builder: (context, child) {
          final buttonColor = isDisabled
              ? AppColors.inkSoft
              : (isActive ? AppColors.accentPrimary : AppColors.accentPrimary);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ripple 1
              if (isActive)
                Container(
                  width: 140 * _micScaleAnimation.value,
                  height: 140 * _micScaleAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: buttonColor.withOpacity(0.1),
                  ),
                ),
              // Outer Ripple 2
              if (isActive)
                Container(
                  width: 120 * _micScaleAnimation.value,
                  height: 120 * _micScaleAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: buttonColor.withOpacity(0.2),
                  ),
                ),
              // Main Button
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? AppGradients.flameHero
                      : const LinearGradient(
                          colors: [Color(0xFF4A4A4A), Color(0xFF2D2D2D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? AppColors.flareRed : Colors.black)
                          .withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Icon(
                  isActive ? Icons.graphic_eq : Icons.mic_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime? timestamp;

  const _ChatBubble({required this.text, required this.isUser, this.timestamp});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isUser ? AppColors.accentPrimary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24),
              topRight: const Radius.circular(24),
              bottomLeft: Radius.circular(isUser ? 24 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 24),
            ),
            boxShadow: [
              BoxShadow(
                color: isUser
                    ? AppColors.accentPrimary.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: AppTypography.body.copyWith(
                  color: isUser ? Colors.white : AppColors.ink,
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
              if (timestamp != null) ...[
                const SizedBox(height: 6),
                Text(
                  _formatTimestamp(timestamp!),
                  style: AppTypography.caption.copyWith(
                    color: isUser
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.inkSoft,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
