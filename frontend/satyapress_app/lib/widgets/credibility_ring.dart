import 'package:flutter/material.dart';

/// A radial ring showing article or source credibility rating.
class CredibilityRing extends StatelessWidget {
  /// Credibility score (0.0 to 1.0).
  final double? score;

  /// Outer radius of the ring.
  final double radius;

  /// Width of the circular progress indicator line.
  final double strokeWidth;

  const CredibilityRing({
    super.key,
    required this.score,
    this.radius = 22.0,
    this.strokeWidth = 4.0,
  });

  Color _getScoreColor() {
    if (score == null) return Colors.grey;
    if (score! >= 0.75) {
      return const Color(0xFF10B981); // Green (High credibility)
    } else if (score! >= 0.50) {
      return const Color(0xFFF59E0B); // Amber (Medium credibility)
    } else {
      return const Color(0xFFEF4444); // Red (Low credibility)
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor();
    final percentage = score != null ? (score! * 100).toStringAsFixed(0) : '--';

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score,
            strokeWidth: strokeWidth,
            backgroundColor: scoreColor.withValues(alpha: 0.15),
            color: scoreColor,
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: radius * 0.6,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}
