import 'package:flutter/material.dart';

/// A statistics or telemetry card showcasing specific analytical scores.
class MetricTile extends StatelessWidget {
  /// The title of the metric (e.g., "AI Truth Index").
  final String label;

  /// The value to display (e.g., "94%").
  final String value;

  /// Optional icon to represent the metric.
  final IconData? icon;

  /// Optional custom color to highlight the value/icon.
  final Color? color;

  /// Optional subtitle details.
  final String? subtitle;

  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = color ?? theme.colorScheme.primary;

    return Card(
      elevation: 0.0,
      shape: theme.cardTheme.shape,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 20.0,
                    color: highlightColor,
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: highlightColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4.0),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
