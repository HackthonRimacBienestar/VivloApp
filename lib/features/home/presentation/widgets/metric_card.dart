import 'package:flutter/material.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../../core/ui/theme/colors.dart';

enum ChartType { line, bar }

class MetricCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final ChartType chartType;
  final int index; // For staggered animation

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.chartType,
    this.index = 0,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Stagger the animation based on index
    final delay = widget.index * 100;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(widget.icon, color: widget.color, size: 18),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: AppColors.inkMuted.withOpacity(0.3),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _ChartPainter(
                        color: widget.color,
                        type: widget.chartType,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final Color color;
  final ChartType type;

  _ChartPainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = type == ChartType.line
          ? PaintingStyle.stroke
          : PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    if (type == ChartType.line) {
      final path = Path();
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.9,
        size.width * 0.5,
        size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.1,
        size.width,
        size.height * 0.6,
      );
      canvas.drawPath(path, paint);
    } else {
      // Bar chart
      final barWidth = size.width / 9;
      final heights = [0.4, 0.6, 0.3, 0.8, 0.5, 0.9, 0.4];
      for (int i = 0; i < heights.length; i++) {
        final h = size.height * heights[i];
        final x = i * (barWidth + 4);
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, barWidth, h),
          const Radius.circular(2),
        );
        canvas.drawRRect(rrect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
