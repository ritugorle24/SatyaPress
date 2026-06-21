import 'package:flutter/material.dart';

/// A timestamp component representing when an article was published.
class TimestampLabel extends StatelessWidget {
  /// The publication date and time.
  final DateTime? dateTime;

  /// Custom pre-formatted timestamp string.
  final String? timestampString;

  /// Icon to display alongside the timestamp.
  final IconData icon;

  const TimestampLabel({
    super.key,
    this.dateTime,
    this.timestampString,
    this.icon = Icons.access_time_rounded,
  });

  String _formatTimestamp() {
    if (timestampString != null) {
      return timestampString!;
    }
    if (dateTime != null) {
      final now = DateTime.now();
      final difference = now.difference(dateTime!);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    }
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = _formatTimestamp();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14.0,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
