import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import '../domain/community_group.dart';
import '../domain/community_message.dart';
import '../data/community_repository.dart';
import '../../../core/services/auth_service.dart';

class CommunityChatPage extends StatefulWidget {
  final CommunityGroup group;

  const CommunityChatPage({super.key, required this.group});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final CommunityRepository _repository = CommunityRepository();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _repository.joinGroup(widget.group.id);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await _repository.sendMessage(widget.group.id, message);
      _messageController.clear();
      // Scroll to bottom after sending
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al enviar mensaje: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name,
              style: AppTypography.subtitle.copyWith(color: AppColors.ink),
            ),
            Text(
              '${widget.group.membersOnline} conectados ahora',
              style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _ChatIntroCard(group: widget.group),
          Expanded(
            child: StreamBuilder<List<CommunityMessage>>(
              stream: _repository.subscribeToMessages(widget.group.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar mensajes: ${snapshot.error}'),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay mensajes aún. ¡Sé el primero en escribir!',
                      style: AppTypography.body.copyWith(
                        color: AppColors.inkSoft,
                      ),
                    ),
                  );
                }

                // Scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.lg,
                  ),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMine = message.userId == currentUserId;
                    return _ChatBubble(message: message, isMine: isMine);
                  },
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemCount: messages.length,
                );
              },
            ),
          ),
          _MessageComposer(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatIntroCard extends StatelessWidget {
  final CommunityGroup group;

  const _ChatIntroCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardInternalPadding),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: group.accent.withOpacity(0.15),
            ),
            child: Icon(group.icon, color: group.accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.description,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  group.tone,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkSoft,
                  ),
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
  final CommunityMessage message;
  final bool isMine;

  const _ChatBubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final background = isMine ? AppColors.accentPrimary : AppColors.surface;
    final textColor = isMine ? AppColors.surface : AppColors.ink;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMine ? 16 : 4),
            topRight: Radius.circular(isMine ? 4 : 16),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(20, 0, 0, 0),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.authorName ?? 'Usuario',
                  style: AppTypography.caption.copyWith(
                    color: isMine
                        ? AppColors.surface.withOpacity(0.7)
                        : AppColors.inkSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(message.createdAt),
                  style: AppTypography.caption.copyWith(
                    color: isMine
                        ? AppColors.surface.withOpacity(0.6)
                        : AppColors.inkSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message.content,
              style: AppTypography.bodySmall.copyWith(
                color: textColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageComposer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(15, 0, 0, 0),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.inkSoft,
                ),
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardInternalPadding,
                  ),
                  borderSide: BorderSide(color: AppColors.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardInternalPadding,
                  ),
                  borderSide: BorderSide(color: AppColors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardInternalPadding,
                  ),
                  borderSide: BorderSide(color: AppColors.accentPrimary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          FilledButton(
            onPressed: onSend,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              shape: const StadiumBorder(),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
