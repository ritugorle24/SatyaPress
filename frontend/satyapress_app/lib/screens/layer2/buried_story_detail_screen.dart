import 'package:flutter/material.dart';
import '../../data/mock_buried_stories.dart';
import '../../widgets/coverage_stats_card.dart';
import '../../widgets/gap_meter.dart';
import '../../widgets/gap_score_card.dart';
import '../../widgets/source_coverage_card.dart';
import '../../widgets/timeline_card.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/why_this_matters_card.dart';

/// BuriedStoryDetailScreen presents details and metadata for a neglected/buried news story.
class BuriedStoryDetailScreen extends StatelessWidget {
  final BuriedStory story;

  const BuriedStoryDetailScreen({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate =
        '${story.date.year}-${story.date.month.toString().padLeft(2, '0')}-${story.date.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coverage Gap Analysis'),
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
            // Support wide tablet layout or normal mobile layout
            final isWide = constraints.maxWidth > 700;
            final double horizontalPadding = isWide ? 32.0 : 16.0;

            final mainContentList = [
              // 1. Headline, Category & Date Header
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.2),
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
                    Text(
                      story.headline,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Gap Score & Gap Meter visualization inside a premium Card
              Card(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Coverage Deficit Level',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          GapScoreCard(gapScore: story.gapScore),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      GapMeter(
                        publicInterest: story.publicInterest,
                        mainstreamCoverage: story.mainstreamCoverage,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // 3. Why This Matters
              WhyThisMattersCard(explanation: story.whyThisMatters),
              const SizedBox(height: 16.0),

              // 4. Coverage Statistics Card
              CoverageStatsCard(
                publicInterest: story.publicInterest,
                mainstreamCoverage: story.mainstreamCoverage,
              ),
              const SizedBox(height: 16.0),

              // 5. Sources Covering / Ignoring Story
              SourceCoverageCard(
                sourcesCovering: story.sourcesCovering,
                sourcesIgnoring: story.sourcesIgnoring,
              ),
              const SizedBox(height: 16.0),

              // 6. Timeline of events
              TimelineCard(timeline: story.timeline),
              const SizedBox(height: 16.0),

              // 7. AI Insight Summary Card
              AIInsightCard(insight: story.aiInsight),
              const SizedBox(height: 24.0),
            ];

            if (isWide) {
              // Two column dashboard for wide screens
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainContentList[0], // Title Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mainContentList[1], // Gap Score Card
                              const SizedBox(height: 16.0),
                              mainContentList[2], // Why This Matters
                              const SizedBox(height: 16.0),
                              mainContentList[6], // AI Insight Summary Card
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Right column
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mainContentList[3], // Coverage Stats Card
                              const SizedBox(height: 16.0),
                              mainContentList[4], // Source Coverage Card
                              const SizedBox(height: 16.0),
                              mainContentList[5], // Timeline Card
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              // Mobile scrollable single column
              return ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 8.0),
                children: mainContentList,
              );
            }
          },
        ),
      ),
    );
  }
}
