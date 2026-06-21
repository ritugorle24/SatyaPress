import 'package:flutter/material.dart';

/// A card highlighting the verified RTI Fact, why it matters, and official source details.
class RTIFactCard extends StatelessWidget {
  final String fact;
  final String whyItMatters;
  final String officialSource;

  const RTIFactCard({
    super.key,
    required this.fact,
    required this.whyItMatters,
    required this.officialSource,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RTI Fact container (investigative highlight box)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.25),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.gavel_rounded,
                    color: theme.colorScheme.primary,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Disclosed RTI Fact',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                fact,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // Why It Matters
        Text(
          'Why It Matters',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          whyItMatters,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16.0),
        const Divider(height: 1.0, thickness: 1.0),
        const SizedBox(height: 12.0),

        // Official Source Reference
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.folder_shared_rounded,
              size: 16.0,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OFFICIAL RECORD AUTHORITY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    officialSource,
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
      ],
    );
  }
}
