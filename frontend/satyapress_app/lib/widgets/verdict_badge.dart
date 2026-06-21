import 'package:flutter/material.dart';
import '../data/mock_claim_data.dart';

/// A badge widget displaying the fact-check verdict with customized color-coding and icons.
class VerdictBadge extends StatelessWidget {
  final ClaimVerdict verdict;

  const VerdictBadge({
    super.key,
    required this.verdict,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = verdict.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verdict.icon,
            size: 14.0,
            color: badgeColor,
          ),
          const SizedBox(width: 6.0),
          Text(
            verdict.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
