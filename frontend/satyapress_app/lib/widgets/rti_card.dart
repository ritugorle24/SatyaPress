import 'package:flutter/material.dart';
import '../data/mock_rti_data.dart';
import 'rti_fact_card.dart';
import 'rti_timeline_card.dart';

/// RTICard aggregates the RTI fact audit and disclosure lifecycle timeline in a premium document styling.
class RTICard extends StatelessWidget {
  final RTIFinding finding;

  const RTICard({
    super.key,
    required this.finding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Investigative Document Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RTI RECORD REFERENCE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.outline,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      SelectableText(
                        finding.referenceNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'VERIFIED DISCLOSURE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF047857),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(height: 1.0, thickness: 1.0),
            const SizedBox(height: 16.0),

            // Related Buried Story Metadata
            Text(
              'RELATED BURIED STORY',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              finding.relatedStoryTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24.0),

            // RTI Fact Card (Embed)
            RTIFactCard(
              fact: finding.fact,
              whyItMatters: finding.whyItMatters,
              officialSource: finding.officialSource,
            ),
            const SizedBox(height: 24.0),
            const Divider(height: 1.0, thickness: 1.0),
            const SizedBox(height: 24.0),

            // RTI Timeline Card (Embed)
            RTITimelineCard(timeline: finding.timeline),
          ],
        ),
      ),
    );
  }
}
