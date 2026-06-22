import 'dart:math';
import 'package:flutter/material.dart';

/// DonutChart displays proportions of True, False, and Misleading claims in a custom-drawn chart.
class DonutChart extends StatelessWidget {
  final int trueCount;
  final int falseCount;
  final int misleadingCount;

  const DonutChart({
    super.key,
    required this.trueCount,
    required this.falseCount,
    required this.misleadingCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = trueCount + falseCount + misleadingCount;
    if (total == 0) {
      return Center(
        child: Text(
          'No audited statement data available.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final double truePct = trueCount / total;
    final double falsePct = falseCount / total;
    final double misleadingPct = misleadingCount / total;

    return Row(
      children: [
        SizedBox(
          width: 110.0,
          height: 110.0,
          child: CustomPaint(
            painter: DonutChartPainter(
              truePct: truePct,
              falsePct: falsePct,
              misleadingPct: misleadingPct,
              trueColor: const Color(0xFF10B981), // Neutral soft green
              falseColor: const Color(0xFFEF4444), // Neutral soft red
              misleadingColor: const Color(0xFFF59E0B), // Neutral soft amber
            ),
          ),
        ),
        const SizedBox(width: 24.0),
        // Legends
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegend(context, 'True', trueCount, truePct, const Color(0xFF10B981)),
              const SizedBox(height: 8.0),
              _buildLegend(context, 'False', falseCount, falsePct, const Color(0xFFEF4444)),
              const SizedBox(height: 8.0),
              _buildLegend(context, 'Misleading', misleadingCount, misleadingPct, const Color(0xFFF59E0B)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(
    BuildContext context,
    String label,
    int count,
    double pct,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '$label: $count',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Text(
          '${(pct * 100).toStringAsFixed(0)}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double truePct;
  final double falsePct;
  final double misleadingPct;
  final Color trueColor;
  final Color falseColor;
  final Color misleadingColor;

  const DonutChartPainter({
    required this.truePct,
    required this.falsePct,
    required this.misleadingPct,
    required this.trueColor,
    required this.falseColor,
    required this.misleadingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 14.0;
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width - strokeWidth) / 2,
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;

    // Draw False
    if (falsePct > 0) {
      paint.color = falseColor;
      final sweepAngle = falsePct * 2 * pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    // Draw Misleading
    if (misleadingPct > 0) {
      paint.color = misleadingColor;
      final sweepAngle = misleadingPct * 2 * pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    // Draw True
    if (truePct > 0) {
      paint.color = trueColor;
      final sweepAngle = truePct * 2 * pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
