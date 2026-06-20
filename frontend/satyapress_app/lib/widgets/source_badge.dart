import 'package:flutter/material.dart';

/// A custom badge depicting the news source name with styled branding.
class SourceBadge extends StatelessWidget {
  /// Name of the news source (e.g., 'The Hindu').
  final String sourceName;

  /// Optional URL to the source's logo image.
  final String? logoUrl;

  /// Optional action when the badge is tapped.
  final VoidCallback? onTap;

  const SourceBadge({
    super.key,
    required this.sourceName,
    this.logoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget badgeContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (logoUrl != null && logoUrl!.isNotEmpty)
            Image.network(
              logoUrl!,
              width: 16.0,
              height: 16.0,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(theme),
            )
          else
            _buildFallbackIcon(theme),
          const SizedBox(width: 6.0),
          Text(
            sourceName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.0),
        child: badgeContent,
      );
    }

    return badgeContent;
  }

  Widget _buildFallbackIcon(ThemeData theme) {
    return Container(
      width: 16.0,
      height: 16.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        sourceName.isNotEmpty ? sourceName[0].toUpperCase() : 'N',
        style: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
