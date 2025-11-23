import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import '../domain/community_group.dart';

class CommunityChatPage extends StatelessWidget {
  final CommunityGroup group;

  const CommunityChatPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final messages = _mockMessages(group);

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
            Text(group.name, style: AppTypography.subtitle.copyWith(color: AppColors.ink)),
            Text(
              '${group.membersOnline} conectados ahora',
              style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _ChatIntroCard(group: group),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
              itemBuilder: (context, index) => _ChatBubble(message: messages[index]),
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemCount: messages.length,
            ),
          ),
          const _ComposerMock(),
        ],
      ),
    );
  }

  List<_MockMessage> _mockMessages(CommunityGroup group) {
    return [
      _MockMessage(
        author: 'Maria',
        content: 'Llegue a 112 mg/dL esta manana. Alguna idea para no bajar tanto?',
        timestamp: '20:01',
        isMine: false,
      ),
      _MockMessage(
        author: 'Tu',
        content: 'Estoy probando avena con canela y me mantiene estable.',
        timestamp: '20:02',
        isMine: true,
      ),
      _MockMessage(
        author: 'Facilitadora Vivlo',
        content: 'Recuerden hidratarse y registrar como se sienten para comentarlo manana.',
        timestamp: '20:03',
        isMine: false,
        isHost: true,
      ),
      _MockMessage(
        author: 'Diego',
        content: 'A mí me ayudó poner alarmas suaves para mis medicinas. Les comparto template.',
        timestamp: '20:05',
        isMine: false,
      ),
      _MockMessage(
        author: 'Tu',
        content: 'Gracias a todos por compartir, hoy me siento mas acompanado.',
        timestamp: '20:07',
        isMine: true,
      ),
    ];
  }
}

class _ChatIntroCard extends StatelessWidget {
  final CommunityGroup group;

  const _ChatIntroCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
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
                  style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
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
  final _MockMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isMine ? Alignment.centerRight : Alignment.centerLeft;
    final background = message.isMine ? AppColors.accentPrimary : AppColors.surface;
    final textColor = message.isMine ? AppColors.surface : AppColors.ink;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(message.isMine ? 16 : 4),
            topRight: Radius.circular(message.isMine ? 4 : 16),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
          boxShadow: const [
            BoxShadow(color: Color.fromARGB(20, 0, 0, 0), blurRadius: 12, offset: Offset(0, 4)),
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
                  message.author,
                  style: AppTypography.caption.copyWith(
                    color: message.isMine ? AppColors.surface.withOpacity(0.7) : AppColors.inkSoft,
                    fontWeight: message.isHost ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (message.isHost) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.verified, size: 14, color: AppColors.accentInfo),
                ],
                const SizedBox(width: 8),
                Text(
                  message.timestamp,
                  style: AppTypography.caption.copyWith(
                    color: message.isMine ? AppColors.surface.withOpacity(0.6) : AppColors.inkSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message.content,
              style: AppTypography.bodySmall.copyWith(color: textColor, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerMock extends StatelessWidget {
  const _ComposerMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
      decoration: const BoxDecoration(color: AppColors.surface, boxShadow: [
        BoxShadow(color: Color.fromARGB(15, 0, 0, 0), blurRadius: 12, offset: Offset(0, -4)),
      ]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.cardInternalPadding),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: AppColors.inkSoft),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Demo · pronto podrás enviar mensajes',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.inkSoft),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          FilledButton(
            onPressed: null,
            style: FilledButton.styleFrom(
              disabledBackgroundColor: AppColors.inkSoft.withOpacity(0.3),
              shape: const StadiumBorder(),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

class _MockMessage {
  final String author;
  final String content;
  final String timestamp;
  final bool isMine;
  final bool isHost;

  const _MockMessage({
    required this.author,
    required this.content,
    required this.timestamp,
    required this.isMine,
    this.isHost = false,
  });
}
