import 'package:flutter/material.dart';

/// A reusable widget highlighting sensationalism, loaded reasons, and a neutral rewrite.
class HeadlineManipulationCard extends StatelessWidget {
  /// The original, potentially sensational headline.
  final String originalHeadline;

  /// Sensationalism score (0.0 to 1.0).
  final double sensationalismScore;

  /// The list of detected manipulation reasons (e.g. "Clickbait", "Exaggeration").
  final List<String> manipulationReasons;

  /// The suggested neutral/factual rewrite of the headline.
  final String neutralRewrite;

  const HeadlineManipulationCard({
    super.key,
    required this.originalHeadline,
    required this.sensationalismScore,
    required this.manipulationReasons,
    required this.neutralRewrite,
  });

  Color _getScoreColor() {
    if (sensationalismScore >= 0.70) {
      return const Color(0xFFEF4444); // Red (High sensationalism)
    } else if (sensationalismScore >= 0.30) {
      return const Color(0xFFF59E0B); // Amber (Medium sensationalism)
    } else {
      return const Color(0xFF10B981); // Green (Low sensationalism)
    }
  }

  String _getWarningText() {
    if (sensationalismScore >= 0.70) {
      return 'HIGH SENSATIONALISM';
    } else if (sensationalismScore >= 0.30) {
      return 'MODERATE SENSATIONALISM';
    } else {
      return 'LOW SENSATIONALISM';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = _getScoreColor();
    final warningText = _getWarningText();
    final percentage = (sensationalismScore * 100).toStringAsFixed(0);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Headline Manipulation Detector',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            
            // Score and Warning Badge Row
            Row(
              children: [
                // Animated Circular Score Indicator
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: sensationalismScore),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: value,
                            strokeWidth: 5.0,
                            backgroundColor: scoreColor.withValues(alpha: 0.15),
                            color: scoreColor,
                          ),
                          Text(
                            (value * 100).toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Warning Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: scoreColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: scoreColor.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 14.0,
                              color: scoreColor,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              warningText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Sensationalism Score: $percentage/100',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Original Headline
            Text(
              'Original Headline',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              originalHeadline,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16.0),

            // Reason Chips
            Text(
              'Manipulation Techniques',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: manipulationReasons.map((reason) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.label_important_outline_rounded,
                        size: 12.0,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        reason,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),

            // Neutral Rewrite Card
            Text(
              'Neutral Alternative',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16.0,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Neutral Rewrite',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    neutralRewrite,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
