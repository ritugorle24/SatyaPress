import 'package:flutter/material.dart';
import '../../data/mock_leaderboard_data.dart';

/// ProfileScreen presents a detailed accountability overview of a selected public figure.
class ProfileScreen extends StatelessWidget {
  final LeaderboardEntry entry;

  const ProfileScreen({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rateColor = entry.falseClaimPercentage >= 60
        ? const Color(0xFFEF4444)
        : entry.falseClaimPercentage >= 35
            ? const Color(0xFFF59E0B)
            : const Color(0xFF10B981);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Profile Audit'),
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
              // 1. Profile Bio Header block
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // 2. Metrics Analytics Grid
              Text(
                'VERIFICATION METRICS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10.0),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 500;

                  final statCards = [
                    _buildStatCard(
                      context,
                      title: 'False Claim Rate',
                      value: '${entry.falseClaimPercentage.toStringAsFixed(0)}%',
                      color: rateColor,
                      icon: Icons.dangerous_outlined,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Audited Claims',
                      value: '${entry.totalClaimsAudited}',
                      color: theme.colorScheme.primary,
                      icon: Icons.fact_check_outlined,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Integrity Grade',
                      value: entry.grade,
                      color: entry.grade.startsWith('A') || entry.grade.startsWith('B')
                          ? const Color(0xFF10B981)
                          : entry.grade.startsWith('C')
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFEF4444),
                      icon: Icons.workspace_premium_outlined,
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      children: statCards.map((card) => Expanded(child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: card,
                      ))).toList(),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: statCards[0]),
                            const SizedBox(width: 12.0),
                            Expanded(child: statCards[1]),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        statCards[2],
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 24.0),

              // 3. Overall Reliability Meter
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
                            'Truthfulness Index',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${(100 - entry.falseClaimPercentage).toStringAsFixed(0)}% Reliable',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: LinearProgressIndicator(
                          value: (100 - entry.falseClaimPercentage) / 100.0,
                          color: const Color(0xFF10B981),
                          backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                          minHeight: 8.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'This rating indicates the percentage of statements verified as true/mostly true by independent RTI and database cross-audits.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // 4. List of Audited Statements
              Text(
                'RECENT AUDITED STATEMENTS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10.0),
              if (entry.recentQuotes.isEmpty)
                Text(
                  'No recent quotes documented.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entry.recentQuotes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                  itemBuilder: (context, index) {
                    final quote = entry.recentQuotes[index];
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                            size: 24.0,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '"$quote"',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    height: 1.4,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.gavel_rounded,
                                      size: 12.0,
                                      color: theme.colorScheme.outline,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      'Audited under Ref #ST-2026-0$index',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.0, color: color),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
