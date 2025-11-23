import 'package:flutter/material.dart';

import '../../../../core/ui/theme/typography.dart';

enum ChartType { line, bar }

class MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final ChartType chartType;

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                ),
              ),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomPaint(
              painter: _ChartPainter(
                color: Colors.white.withOpacity(0.5),
                type: chartType,
              ),
            ),
          ),
        ],
      ),
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
      ..strokeWidth = 3
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
