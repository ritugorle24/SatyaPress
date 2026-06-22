import 'package:flutter/material.dart';

/// A card displaying a verified source citation or official database link.
class EvidenceSourceCard extends StatelessWidget {
  final List<String> sources;

  const EvidenceSourceCard({
    super.key,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 16.0,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(width: 6.0),
            Text(
              'VERIFIED DOCUMENT CITED',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sources.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8.0),
          itemBuilder: (context, index) {
            final source = sources[index];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 16.0,
                    color: const Color(0xFF10B981), // Neutral success green
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      source,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
