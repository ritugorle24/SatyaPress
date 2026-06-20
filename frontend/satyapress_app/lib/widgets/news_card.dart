import 'package:flutter/material.dart';
import 'bias_pill.dart';
import 'credibility_ring.dart';
import 'source_badge.dart';
import 'timestamp_label.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                imageUrl!,
                height: 180.0,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
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
                  if (bias != null || credibilityScore != null) ...[
                    const SizedBox(height: 16.0),
                    const Divider(height: 1.0, thickness: 1.0),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (bias != null)
                          BiasPill(bias: bias!, score: biasScore)
                        else
                          const SizedBox.shrink(),
                        if (credibilityScore != null)
                          Row(
                            children: [
                              Text(
                                'Credibility: ',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              CredibilityRing(
                                score: credibilityScore!,
                                radius: 16.0,
                                strokeWidth: 3.0,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
