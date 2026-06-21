import 'package:flutter/material.dart';

/// A widget displaying a side-by-side or stacked quote comparison of a public claim vs verified reality.
class RealityComparisonCard extends StatelessWidget {
  final String originalStatement;
  final String actualOutcome;

  const RealityComparisonCard({
    super.key,
    required this.originalStatement,
    required this.actualOutcome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        final statementBox = _buildSpeechBubble(
          context,
          title: 'PUBLIC CLAIM',
          content: originalStatement,
          icon: Icons.record_voice_over_rounded,
          bgColor: theme.colorScheme.onSurface.withValues(alpha: 0.03),
          borderColor: theme.colorScheme.outlineVariant,
          textColor: theme.colorScheme.onSurface,
        );

        final outcomeBox = _buildSpeechBubble(
          context,
          title: 'VERIFIED REALITY',
          content: actualOutcome,
          icon: Icons.fact_check_rounded,
          bgColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
          borderColor: theme.colorScheme.primary.withValues(alpha: 0.25),
          textColor: theme.colorScheme.onPrimaryContainer,
          titleColor: theme.colorScheme.primary,
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: statementBox),
              const SizedBox(width: 16.0),
              Expanded(child: outcomeBox),
            ],
          );
        } else {
          return Column(
            children: [
              statementBox,
              const SizedBox(height: 16.0),
              outcomeBox,
            ],
          );
        }
      },
    );
  }

  Widget _buildSpeechBubble(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote Title
          Row(
            children: [
              Icon(
                icon,
                size: 16.0,
                color: titleColor ?? theme.colorScheme.outline,
              ),
              const SizedBox(width: 6.0),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? theme.colorScheme.outline,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Quote Text
          Text(
            '"$content"',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
