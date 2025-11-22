import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/ui/theme/colors.dart';
import '../../../core/ui/theme/typography.dart';
import '../logic/voice_agent_controller.dart';

class VoiceAgentPage extends StatefulWidget {
  const VoiceAgentPage({super.key});

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
      duration: const Duration(milliseconds: 220),
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );
    _micGlowAnimation = Tween<double>(begin: 0.4, end: 0.7).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );

    // Animación de la mascota (bounce sutil y pulse)
    _mascotAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _mascotBounceAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _mascotAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _mascotPulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _mascotAnimationController,
        curve: Curves.easeInOut,
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

  void _onControllerUpdate() {
    setState(() {});

    // Reaccionar a cambios de estado del micrófono
    if (_controller.isListening) {
      // Animación más rápida cuando está escuchando
      _mascotAnimationController.duration = const Duration(milliseconds: 800);
      // Activar animación del micrófono
      if (_micAnimationController.status != AnimationStatus.forward &&
          _micAnimationController.status != AnimationStatus.completed) {
        _micAnimationController.forward();
      }
    } else {
      // Animación normal cuando está idle
      _mascotAnimationController.duration = const Duration(milliseconds: 2000);
      // Desactivar animación del micrófono
      if (_micAnimationController.status != AnimationStatus.reverse &&
          _micAnimationController.status != AnimationStatus.dismissed) {
        _micAnimationController.reverse();
      }
    }

    // Auto-scroll al final si hay nuevos mensajes
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
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
      backgroundColor: AppColors.surfaceMuted,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Inline Banner para disclaimer médico (solo si no hay mensajes)
            if (!hasMessages) _buildDisclaimerBanner(),

            // Chat Area
            Expanded(child: _buildChatArea(hasMessages)),

            // Bottom Controls Panel
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.ink),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Volver',
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soporte por voz',
            style: AppTypography.subtitle.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: 2),
          _buildConnectionStatus(),
        ],
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.ink),
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
    IconData statusIcon;
    String statusText;

    if (_controller.isConnected) {
      statusColor = AppColors.statusSuccess;
      statusIcon = Icons.circle;
      statusText = 'Conectado';
    } else if (_controller.status.contains('Error')) {
      statusColor = AppColors.statusError;
      statusIcon = Icons.error_outline;
      statusText = 'Error de conexión';
    } else if (_controller.status.contains('Conectando')) {
      statusColor = AppColors.statusWarning;
      statusIcon = Icons.sync;
      statusText = 'Conectando...';
    } else {
      statusColor = AppColors.statusOffline;
      statusIcon = Icons.circle_outlined;
      statusText = 'Desconectado';
    }

    return Row(
      children: [
        Icon(statusIcon, size: 8, color: statusColor),
        const SizedBox(width: 6),
        Text(
          statusText,
          style: AppTypography.caption.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceHint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [const SizedBox(width: 6)],
      ),
    );
  }

  Widget _buildChatArea(bool hasMessages) {
    if (!hasMessages) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accentPrimary.withOpacity(0.20),
              AppColors.emberOrange.withOpacity(0.15),
              AppColors.surfaceMuted,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mascota del asistente con animación sutil
                AnimatedBuilder(
                  animation: _mascotAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_mascotBounceAnimation.value),
                      child: Transform.scale(
                        scale: _mascotPulseAnimation.value,
                        child: Image.asset(
                          'assets/ROBOTSITO1.png',
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Toca el micrófono para comenzar',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.inkSoft,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
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
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Microtexto de ayuda
          Text(
            _getHelpText(),
            style: AppTypography.bodySmall.copyWith(color: AppColors.inkSoft),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Botón de micrófono grande y centrado
          _buildMicrophoneButton(),

          // Disclaimer discreto en la parte inferior
          const SizedBox(height: 16),
          Text(
            'No es un diagnóstico médico',
            style: AppTypography.caption.copyWith(
              color: AppColors.inkSoft.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _getHelpText() {
    if (!_controller.isConnected) {
      return 'Conectando con soporte...';
    }
    if (_controller.isListening) {
      return 'Escuchando... Toca para detener';
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
              : (isActive ? AppColors.statusError : AppColors.accentPrimary);

          final glowOpacity = isActive ? _micGlowAnimation.value : 0.4;
          final scale = isActive ? _micScaleAnimation.value : 1.0;
          final shadowBlur = isActive ? 32.0 : 20.0;
          final shadowSpread = isActive ? 8.0 : 4.0;
          final shadowOffset = isActive ? 4.0 : 2.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: buttonColor,
                shape: BoxShape.circle,
                boxShadow: [
                  // Sombra principal (elevation level_2 → level_3 cuando está activo)
                  BoxShadow(
                    color: buttonColor.withOpacity(glowOpacity),
                    blurRadius: shadowBlur,
                    spreadRadius: shadowSpread,
                    offset: Offset(0, shadowOffset),
                  ),
                  // Glow adicional cuando está activo
                  if (isActive)
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 12,
                    ),
                ],
              ),
              child: Icon(
                isActive ? Icons.stop : Icons.mic,
                color: AppColors.surface,
                size: 40,
              ),
            ),
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
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? AppColors.accentPrimary : AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
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
                  color: isUser ? AppColors.surface : AppColors.ink,
                  height: 1.4,
                ),
              ),
              if (timestamp != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(timestamp!),
                  style: AppTypography.caption.copyWith(
                    color: isUser
                        ? AppColors.surface.withOpacity(0.7)
                        : AppColors.inkSoft,
                    fontSize: 10,
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
