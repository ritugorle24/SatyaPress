import 'package:flutter/material.dart';
import '../data/mock_leaderboard_data.dart';
import '../screens/layer3/profile_screen.dart';
import 'trend_indicator.dart';

/// A row element in the accountability leaderboard display.
class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;

  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Color code rank numbers for top 3 visual interest
    Color rankColor = theme.colorScheme.onSurfaceVariant;
    FontWeight rankWeight = FontWeight.normal;
    if (rank == 1) {
      rankColor = const Color(0xFFEF4444); // Top liar/worst accountability gets red rank
      rankWeight = FontWeight.bold;
    } else if (rank == 2) {
      rankColor = const Color(0xFFF59E0B);
      rankWeight = FontWeight.bold;
    } else if (rank == 3) {
      rankColor = const Color(0xFF3B82F6);
      rankWeight = FontWeight.bold;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(entry: entry),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Rank Number
              SizedBox(
                width: 32.0,
                child: Text(
                  '#$rank',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: rankColor,
                    fontWeight: rankWeight,
                  ),
                ),
              ),

              // Avatar
              ClipOval(
                child: Image.network(
                  entry.avatarUrl,
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40.0,
                    height: 40.0,
                    color: theme.colorScheme.primaryContainer,
                    alignment: Alignment.center,
                    child: Text(
                      entry.name.isNotEmpty ? entry.name.substring(0, 1) : "?",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Name & Role details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      entry.role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),

              // False Claim Percentage Box
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${entry.falseClaimPercentage.toStringAsFixed(0)}% FALSE',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: entry.falseClaimPercentage >= 60
                          ? const Color(0xFFEF4444)
                          : entry.falseClaimPercentage >= 35
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${entry.statements.length} Audits',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),

              // Trend Indicator Arrow
              TrendIndicator(trend: entry.trend),
            ],
          ),
        ),
      ),
    );
  }
}
