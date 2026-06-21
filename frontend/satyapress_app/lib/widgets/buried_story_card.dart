import 'package:flutter/material.dart';
import '../data/mock_buried_stories.dart';
import 'gap_meter.dart';
import 'gap_score_card.dart';
import 'why_this_matters_card.dart';

/// A card representing a buried story with media coverage gap analysis.
class BuriedStoryCard extends StatelessWidget {
  final BuriedStory story;

  const BuriedStoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate =
        '${story.date.year}-${story.date.month.toString().padLeft(2, '0')}-${story.date.day.toString().padLeft(2, '0')}';

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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    story.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Headline & Gap Score Badge Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    story.headline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                GapScoreCard(gapScore: story.gapScore),
              ],
            ),
            const SizedBox(height: 16.0),

            // Gap Meter Visualization
            GapMeter(
              publicInterest: story.publicInterest,
              mainstreamCoverage: story.mainstreamCoverage,
            ),
            const SizedBox(height: 16.0),

            // Why This Matters Card
            WhyThisMattersCard(explanation: story.whyThisMatters),
          ],
        ),
      ),
    );
  }
}
