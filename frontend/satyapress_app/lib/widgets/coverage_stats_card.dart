import 'package:flutter/material.dart';

/// A card displaying Coverage Statistics: Public Interest % vs Mainstream Coverage %,
/// and the resulting coverage gap in a dashboard format.
class CoverageStatsCard extends StatelessWidget {
  final int publicInterest;
  final int mainstreamCoverage;

  const CoverageStatsCard({
    super.key,
    required this.publicInterest,
    required this.mainstreamCoverage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverageGap = publicInterest - mainstreamCoverage;

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Icon(
                  Icons.analytics_rounded,
                  size: 20.0,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Coverage Statistics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Statistics Row (Responsive Layout)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 400;

                final publicInterestWidget = _buildStatCol(
                  context,
                  title: 'Public Interest',
                  value: publicInterest,
                  color: theme.colorScheme.primary,
                  subtitle: 'Search volume & social discussion',
                );

                final mainstreamWidget = _buildStatCol(
                  context,
                  title: 'Mainstream Press',
                  value: mainstreamCoverage,
                  color: theme.colorScheme.outline,
                  subtitle: 'Major network article count',
                );

                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: publicInterestWidget),
                      Container(
                        height: 60.0,
                        width: 1.0,
                        color: theme.colorScheme.outlineVariant,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      Expanded(child: mainstreamWidget),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      publicInterestWidget,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(
                          color: theme.colorScheme.outlineVariant,
                          height: 1.0,
                        ),
                      ),
                      mainstreamWidget,
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 16.0),
            const Divider(height: 1.0, thickness: 1.0),
            const SizedBox(height: 16.0),

            // Gap summary calculation
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: theme.colorScheme.error,
                    size: 20.0,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coverage Deficit: -$coverageGap%',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'The mainstream media presence is significantly lower than public search index signals.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(
    BuildContext context, {
    required String title,
    required int value,
    required Color color,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 52.0,
          height: 52.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value / 100.0,
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
                strokeWidth: 5.0,
              ),
              Text(
                '$value%',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
