import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A pill-shaped widget representing political or narrative bias.
class BiasPill extends StatelessWidget {
  /// The bias level (e.g., 'Left', 'Center', 'Right', 'Left-Center', 'Right-Center').
  final String bias;

  /// Optional numeric score (e.g. percentage or index).
  final double? score;

  const BiasPill({
    super.key,
    required this.bias,
    this.score,
  });

  Color _getBiasColor() {
    final lowerBias = bias.toLowerCase();
    if (lowerBias.contains('left')) {
      return const Color(0xFF1E3A8A); // Authoritative blue
    } else if (lowerBias.contains('right')) {
      return const Color(0xFFB91C1C); // Deep red
    } else {
      return AppColors.secondary; // Saffron / Neutral secondary
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final biasColor = _getBiasColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: biasColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: biasColor.withValues(alpha: 0.4),
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
              color: biasColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6.0),
          Text(
            score != null ? '$bias (${(score! * 100).toStringAsFixed(0)}%)' : bias,
            style: theme.textTheme.labelMedium?.copyWith(
              color: biasColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
