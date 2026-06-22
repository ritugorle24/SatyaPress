import 'package:flutter/material.dart';
import '../data/mock_claim_data.dart';
import '../data/mock_leaderboard_data.dart';
import '../screens/layer3/claim_clash_screen.dart';
import 'verdict_badge.dart';

/// StatementTimeline displays a vertical list of audited quotes with limited initial view, expand toggle, and navigation.
class StatementTimeline extends StatefulWidget {
  final List<StatementItem> statements;
  final LeaderboardEntry entry;

  const StatementTimeline({
    super.key,
    required this.statements,
    required this.entry,
  });

  @override
  State<StatementTimeline> createState() => _StatementTimelineState();
}

class _StatementTimelineState extends State<StatementTimeline> {
  bool _isExpanded = false;

  ClaimVerdict _mapVerdict(String verdictStr) {
    switch (verdictStr.toLowerCase()) {
      case 'true':
        return ClaimVerdict.trueVerdict;
      case 'false':
        return ClaimVerdict.falseVerdict;
      case 'misleading':
      default:
        return ClaimVerdict.misleadingVerdict;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.statements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'No statements recorded for this audit cycle.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    final displayedStatements = _isExpanded
        ? widget.statements
        : widget.statements.take(3).toList();

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedStatements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final statement = displayedStatements[index];
              final verdict = _mapVerdict(statement.verdict);

              return Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1.0,
                  ),
                ),
                color: theme.colorScheme.surface,
                child: InkWell(
                  onTap: () {
                    final selectedClaim = statement.toClaimClashItem(
                      widget.entry.name,
                      widget.entry.role,
                      widget.entry.avatarUrl,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClaimClashScreen(claim: selectedClaim),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Verdict Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              statement.date,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.outline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            VerdictBadge(verdict: verdict),
                          ],
                        ),
                        const SizedBox(height: 12.0),

                        // Statement Quote Preview
                        Text(
                          '"${statement.preview}"',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12.0),

                        // Tap indicator text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View Clash Details',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 14.0,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.statements.length > 3) ...[
          const SizedBox(height: 12.0),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon: Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
            label: Text(_isExpanded ? 'Show Less' : 'View All Statements'),
          ),
        ],
      ],
    );
  }
}
