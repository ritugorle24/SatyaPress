import 'package:flutter/material.dart';

/// A card displaying the numeric gap score with color-coding based on severity.
class GapScoreCard extends StatelessWidget {
  final int gapScore;

  const GapScoreCard({
    super.key,
    required this.gapScore,
  });

  Color _getColor() {
    if (gapScore >= 80) {
      return const Color(0xFFEF4444); // Red (Highly Buried/Ignored)
    } else if (gapScore >= 50) {
      return const Color(0xFFF59E0B); // Amber (Moderately Ignored)
    } else {
      return const Color(0xFF10B981); // Green (Low gap)
    }
  }

  String _getLabel() {
    if (gapScore >= 80) {
      return 'CRITICAL GAP';
    } else if (gapScore >= 50) {
      return 'MODERATE GAP';
    } else {
      return 'LOW GAP';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertColor = _getColor();
    final alertLabel = _getLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: alertColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6.0),
          Text(
            '$alertLabel: $gapScore',
            style: theme.textTheme.labelSmall?.copyWith(
              color: alertColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
