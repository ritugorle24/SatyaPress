import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_claim_data.dart';
import 'verdict_badge.dart';
import 'reality_comparison_card.dart';
import 'evidence_source_card.dart';

/// A card representing a public statement fact-checked against official records.
class ClaimCard extends StatelessWidget {
  final ClaimClashItem claim;

  const ClaimCard({
    super.key,
    required this.claim,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate =
        '${claim.date.year}-${claim.date.month.toString().padLeft(2, '0')}-${claim.date.day.toString().padLeft(2, '0')}';

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
            // Header Row: Avatar, Info, Verdict
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    claim.avatarUrl,
                    width: 48.0,
                    height: 48.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 48.0,
                      height: 48.0,
                      color: theme.colorScheme.primaryContainer,
                      alignment: Alignment.center,
                      child: Text(
                        claim.name.isNotEmpty ? claim.name.substring(0, 1) : "?",
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claim.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        claim.role,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Claim Date: $formattedDate',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                VerdictBadge(verdict: claim.verdict),
              ],
            ),
            const SizedBox(height: 16.0),

            // Speech bubbles / Quote comparisons
            RealityComparisonCard(
              originalStatement: claim.originalStatement,
              actualOutcome: claim.actualOutcome,
            ),
            const SizedBox(height: 16.0),

            // Explanation Block
            Text(
              'FACILITY REVIEW ANALYSIS',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              claim.explanation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),

            // Evidence Citation list
            EvidenceSourceCard(sources: claim.evidenceSources),
            const SizedBox(height: 16.0),

            // Actions row: Share Evidence button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    final String verdictStr;
                    switch (claim.verdict) {
                      case ClaimVerdict.trueVerdict:
                        verdictStr = 'True';
                        break;
                      case ClaimVerdict.falseVerdict:
                        verdictStr = 'False';
                        break;
                      case ClaimVerdict.misleadingVerdict:
                        verdictStr = 'Misleading';
                        break;
                    }
                    final shareText = 'Person: ${claim.name}\n'
                        'Verdict: $verdictStr\n'
                        'Statement: ${claim.originalStatement}\n'
                        'Reality: ${claim.actualOutcome}';
                    Clipboard.setData(ClipboardData(text: shareText));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Evidence copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share_outlined, size: 16.0),
                  label: const Text('Share Evidence'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
