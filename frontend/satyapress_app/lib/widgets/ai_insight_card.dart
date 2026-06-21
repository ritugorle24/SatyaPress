import 'package:flutter/material.dart';

/// A card containing detailed AI-generated insights on why this story has been ignored.
class AIInsightCard extends StatelessWidget {
  final String insight;

  const AIInsightCard({
    super.key,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic extraction of key factors based on contents for visual interest tags
    final List<String> focusTags = [];
    final lowerInsight = insight.toLowerCase();
    if (lowerInsight.contains('visual') || lowerInsight.contains('imagery')) {
      focusTags.add('Low Visuals');
    }
    if (lowerInsight.contains('political') || lowerInsight.contains('lobby') || lowerInsight.contains('electoral')) {
      focusTags.add('Political Friction');
    }
    if (lowerInsight.contains('technical') || lowerInsight.contains('jargon') || lowerInsight.contains('complex')) {
      focusTags.add('High Complexity');
    }
    if (lowerInsight.contains('slow-onset') || lowerInsight.contains('drought') || lowerInsight.contains('gradual')) {
      focusTags.add('Slow-Onset Crisis');
    }
    if (lowerInsight.contains('niche') || lowerInsight.contains('scientific') || lowerInsight.contains('local')) {
      focusTags.add('Localized Impact');
    }
    if (focusTags.isEmpty) {
      focusTags.addAll(['Structural Bias', 'Topic Complexity']);
    }

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 20.0,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'AI Gap Audit Insight',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Description
            Text(
              insight,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16.0),

            // Highlight Tags Label
            Text(
              'Identified Friction Factors',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8.0),

            // Visual tags row
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: focusTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        tag,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
