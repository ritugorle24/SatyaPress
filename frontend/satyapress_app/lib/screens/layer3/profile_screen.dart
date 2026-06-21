import 'package:flutter/material.dart';
import '../../data/mock_leaderboard_data.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/promise_tracker.dart';
import '../../widgets/statement_timeline.dart';

/// ProfileScreen presents a detailed accountability overview of a selected public figure.
class ProfileScreen extends StatefulWidget {
  final LeaderboardEntry entry;

  const ProfileScreen({
    super.key,
    required this.entry,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _activeTabIndex = 0; // 0 = Statements, 1 = Promises

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;
    final totalStatements = entry.trueCount + entry.falseCount + entry.misleadingCount;
    final trackedSinceDate =
        '${entry.trackedSince.year}-${entry.trackedSince.month.toString().padLeft(2, '0')}-${entry.trackedSince.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accountability Record'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      entry.avatarUrl,
                      width: 64.0,
                      height: 64.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64.0,
                        height: 64.0,
                        color: theme.colorScheme.primaryContainer,
                        alignment: Alignment.center,
                        child: Text(
                          entry.name.isNotEmpty ? entry.name.substring(0, 1) : "?",
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              entry.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Icon(
                              entry.category.icon,
                              size: 18.0,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          entry.role,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Tracked Since: $trackedSinceDate',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // 2. ACCOUNTABILITY OVERVIEW
              Text(
                'ACCOUNTABILITY OVERVIEW',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10.0),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 550;

                  final overviewCards = [
                    _buildOverviewCountCard(
                      context,
                      title: 'Total Audited',
                      value: '$totalStatements',
                      color: theme.colorScheme.primary,
                    ),
                    _buildOverviewCountCard(
                      context,
                      title: 'True Claims',
                      value: '${entry.trueCount}',
                      color: const Color(0xFF10B981), // Green
                    ),
                    _buildOverviewCountCard(
                      context,
                      title: 'False Claims',
                      value: '${entry.falseCount}',
                      color: const Color(0xFFEF4444), // Red
                    ),
                    _buildOverviewCountCard(
                      context,
                      title: 'Misleading',
                      value: '${entry.misleadingCount}',
                      color: const Color(0xFFF59E0B), // Amber
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      children: overviewCards
                          .map((card) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: card,
                                ),
                              ))
                          .toList(),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: overviewCards[0]),
                            const SizedBox(width: 8.0),
                            Expanded(child: overviewCards[1]),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(child: overviewCards[2]),
                            const SizedBox(width: 8.0),
                            Expanded(child: overviewCards[3]),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 24.0),

              // 3. VISUALIZATION (DonutChart)
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
                      Text(
                        'Audit Breakdown Proportions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      DonutChart(
                        trueCount: entry.trueCount,
                        falseCount: entry.falseCount,
                        misleadingCount: entry.misleadingCount,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // 4. STATEMENTS & PROMISES TAB SWITCHER
              Row(
                children: [
                  _buildTabButton(
                    index: 0,
                    label: 'Statements',
                    icon: Icons.chat_bubble_outline_rounded,
                  ),
                  const SizedBox(width: 12.0),
                  _buildTabButton(
                    index: 1,
                    label: 'Promise Tracker',
                    icon: Icons.fact_check_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              _activeTabIndex == 0
                  ? StatementTimeline(
                      statements: entry.statements,
                      entry: entry,
                    )
                  : PromiseTracker(promises: entry.promises),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCountCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isSelected = _activeTabIndex == index;

    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _activeTabIndex = index;
        });
      },
      icon: Icon(icon, size: 16.0),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
        backgroundColor: isSelected
            ? theme.colorScheme.primaryContainer
            : Colors.transparent,
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: 1.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
