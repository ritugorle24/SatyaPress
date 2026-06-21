import 'package:flutter/material.dart';

/// GapMeter displays a stacked visual meter comparing Public Interest vs Mainstream Coverage.
class GapMeter extends StatelessWidget {
  final int publicInterest;
  final int mainstreamCoverage;

  const GapMeter({
    super.key,
    required this.publicInterest,
    required this.mainstreamCoverage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Public Interest Bar
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                'Public Interest',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: publicInterest / 100.0,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                  minHeight: 8.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 32.0,
              child: Text(
                '$publicInterest%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        // Mainstream Coverage Bar
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                'Mainstream Press',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: mainstreamCoverage / 100.0,
                  color: theme.colorScheme.outline,
                  backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.15),
                  minHeight: 8.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 32.0,
              child: Text(
                '$mainstreamCoverage%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
