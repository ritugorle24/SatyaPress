import 'package:flutter/material.dart';
import '../data/mock_rti_data.dart';

/// A card displaying the timeline of the RTI application and appeal process.
class RTITimelineCard extends StatelessWidget {
  final List<RTITimelineEvent> timeline;

  const RTITimelineCard({
    super.key,
    required this.timeline,
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
              Icons.receipt_long_rounded,
              size: 20.0,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8.0),
            Text(
              'RTI Disclosure Timeline',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        if (timeline.isEmpty)
          Text(
            'No timeline entries available.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeline.length,
            itemBuilder: (context, index) {
              final event = timeline[index];
              final isLast = index == timeline.length - 1;

              // Customize color-coding depending on key phrases in the detail
              Color nodeColor = theme.colorScheme.primary;
              IconData nodeIcon = Icons.circle;

              final lowerDetail = event.detail.toLowerCase();
              if (lowerDetail.contains('reject') || lowerDetail.contains('denies')) {
                nodeColor = theme.colorScheme.error;
                nodeIcon = Icons.error_outline_rounded;
              } else if (lowerDetail.contains('release') || lowerDetail.contains('disclose') || lowerDetail.contains('delivered')) {
                nodeColor = const Color(0xFF10B981); // Success green
                nodeIcon = Icons.check_circle_rounded;
              } else if (lowerDetail.contains('appeal') || lowerDetail.contains('hearing')) {
                nodeColor = const Color(0xFFF59E0B); // Amber warnings/milestones
                nodeIcon = Icons.gavel_rounded;
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date Column
                    SizedBox(
                      width: 85.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          event.date,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: nodeColor,
                          ),
                        ),
                      ),
                    ),

                    // Dot and Connection line
                    SizedBox(
                      width: 32.0,
                      child: Column(
                        children: [
                          Icon(
                            nodeIcon,
                            size: 16.0,
                            color: nodeColor,
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2.0,
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            )
                          else
                            const Spacer(),
                        ],
                      ),
                    ),

                    // Detail Column
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, bottom: 20.0),
                        child: Text(
                          event.detail,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
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
