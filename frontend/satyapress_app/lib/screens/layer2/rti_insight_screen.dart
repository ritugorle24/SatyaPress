import 'package:flutter/material.dart';
import '../../data/mock_buried_stories.dart';
import '../../data/mock_rti_data.dart';
import '../../widgets/rti_card.dart';

/// RTIInsightScreen displays the official RTI evidence audit files connected to a buried story.
class RTIInsightScreen extends StatelessWidget {
  final BuriedStory story;

  const RTIInsightScreen({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rtiFinding = MockRTIDatabase.getByStoryId(story.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation Evidence'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final horizontalPadding = isWide ? 32.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Investigative Shield Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified_user_rounded,
                            color: theme.colorScheme.primary,
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OFFICIAL DOCUMENT AUDIT',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Public transparency verification via Right to Information filings.',
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
                  const SizedBox(height: 20.0),

                  // Display the RTI record or a fallback message
                  if (rtiFinding == null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_off_rounded,
                              size: 64.0,
                              color: theme.colorScheme.outline.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'RTI Evidence Not Found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Official transparency records for this story are pending validation or release.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Main layout (Responsive widths support)
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800.0),
                        child: RTICard(finding: rtiFinding),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
