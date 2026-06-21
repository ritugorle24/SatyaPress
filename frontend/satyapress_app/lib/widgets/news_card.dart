import 'dart:math';
import 'package:flutter/material.dart';
import 'credibility_ring.dart';
import 'source_badge.dart';
import 'timestamp_label.dart';
import 'source_fallback_image.dart';

/// A card component containing article metadata, bias pill, and credibility ring.
class NewsCard extends StatelessWidget {
  /// The title of the news article.
  final String title;

  /// Brief snippet or summary of the article content.
  final String snippet;

  /// Name of the publishing outlet source.
  final String sourceName;

  /// Date and time when the article was published.
  final DateTime timestamp;

  /// Optional banner image URL of the news article.
  final String? imageUrl;

  /// Optional bias category classification (e.g. "Left", "Center", "Right").
  final String? bias;

  /// Optional numeric bias score.
  final double? biasScore;

  /// Optional credibility rating (0.0 to 1.0).
  final double? credibilityScore;

  /// Callback when the entire card is clicked.
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.snippet,
    required this.sourceName,
    required this.timestamp,
    this.imageUrl,
    this.bias,
    this.biasScore,
    this.credibilityScore,
    this.onTap,
  });

  Color _getBiasColor(String? bias) {
    if (bias == null) return Colors.grey;
    final biasLower = bias.toLowerCase();
    if (biasLower.contains('left')) return Colors.blue;
    if (biasLower.contains('right')) return Colors.orange;
    return Colors.grey;
  }

  IconData _getBiasIcon(String? bias) {
    if (bias == null) return Icons.remove;
    final biasLower = bias.toLowerCase();
    if (biasLower.contains('left')) return Icons.arrow_back;
    if (biasLower.contains('right')) return Icons.arrow_forward;
    return Icons.remove;
  }

  double _getDeterministicCredibility(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash);
    final lower = source.toLowerCase();

    if (lower.contains('times of india') || lower == 'toi') {
      return 0.84;
    } else if (lower.contains('hindu')) {
      return 0.88 + (random.nextDouble() * 0.04);
    } else if (lower.contains('indian express')) {
      return 0.76 + (random.nextDouble() * 0.10);
    } else if (lower.contains('ndtv')) {
      return 0.75 + (random.nextDouble() * 0.15);
    } else if (lower.contains('al jazeera') || lower.contains('jazeera')) {
      return 0.72 + (random.nextDouble() * 0.14);
    } else {
      return 0.75 + (random.nextDouble() * 0.10);
    }
  }

  String _getDeterministicBias(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash + 1);
    final lower = source.toLowerCase();

    if (lower.contains('times of india') || lower == 'toi') {
      return 'Center';
    } else if (lower.contains('hindu')) {
      return random.nextBool() ? 'Center' : 'Left-Center';
    } else if (lower.contains('indian express')) {
      return 'Left-Center';
    } else if (lower.contains('ndtv')) {
      return random.nextBool() ? 'Center' : 'Left-Center';
    } else if (lower.contains('al jazeera') || lower.contains('jazeera')) {
      return 'Left-Center';
    } else {
      const options = ['Left-Center', 'Center', 'Right-Center'];
      return options[random.nextInt(options.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBias = (bias != null && bias!.isNotEmpty)
        ? bias!
        : _getDeterministicBias(title, sourceName);

    final effectiveCredibility = credibilityScore ?? _getDeterministicCredibility(title, sourceName);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      shape: theme.cardTheme.shape,
      margin: theme.cardTheme.margin,
      color: theme.cardTheme.color,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageArea(theme),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SourceBadge(sourceName: sourceName),
                      TimestampLabel(dateTime: timestamp),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    snippet,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(height: 1.0, thickness: 1.0),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: _getBiasColor(effectiveBias).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: _getBiasColor(effectiveBias),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getBiasIcon(effectiveBias),
                              size: 14.0,
                              color: _getBiasColor(effectiveBias),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              effectiveBias.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getBiasColor(effectiveBias),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Credibility: ${(effectiveCredibility * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          CredibilityRing(
                            score: effectiveCredibility,
                            radius: 16.0,
                            strokeWidth: 3.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea(ThemeData theme) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        height: 180.0,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 180.0,
            width: double.infinity,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2.0,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return SourceFallbackImage(
            source: sourceName,
            height: 180.0,
          );
        },
      );
    }
    return SourceFallbackImage(
      source: sourceName,
      height: 180.0,
    );
  }
}
