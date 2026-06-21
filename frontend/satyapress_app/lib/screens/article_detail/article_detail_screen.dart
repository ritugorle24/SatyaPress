import 'package:flutter/material.dart';
import '../../data/mock_news_data.dart';
import '../../widgets/bias_pill.dart';
import '../../widgets/credibility_ring.dart';
import '../../widgets/source_badge.dart';
import '../../widgets/timestamp_label.dart';
import '../../widgets/headline_manipulation_card.dart';

/// ArticleDetailScreen presents full details of the article alongside integrity analysis.
class ArticleDetailScreen extends StatelessWidget {
  /// The article whose details and analysis are shown.
  final NewsArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Analysis'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              Image.network(
                article.imageUrl!,
                height: 220.0,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SourceBadge(sourceName: article.sourceName),
                      TimestampLabel(dateTime: article.timestamp),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  // Title
                  Text(
                    article.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Full Article Text
                  Text(
                    article.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 16.0),
                  // ANALYSIS SECTION HEADER
                  Text(
                    'AI News Integrity Analysis',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Credibility and Bias Summary Card
                  Card(
                    elevation: 0.0,
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.15,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CredibilityRing(
                            score: article.credibilityScore,
                            radius: 30.0,
                            strokeWidth: 5.0,
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Credibility Rating',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  _getCredibilityText(article.credibilityScore),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                BiasPill(
                                  bias: article.bias,
                                  score: article.biasScore,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  HeadlineManipulationCard(
                    originalHeadline: article.title,
                    sensationalismScore: 0.78,
                    manipulationReasons: const [
                      'Loaded Language',
                      'Emotional Trigger',
                      'Clickbait',
                    ],
                    neutralRewrite:
                        'Government announces new technology regulation framework',
                  ),
                  const SizedBox(height: 16.0),
                  // Bias Radar Spectrum Placeholder
                  _buildBiasRadarPlaceholder(context),
                  const SizedBox(height: 20.0),
                  // Loaded Words Section
                  _buildLoadedWordsSection(context),
                  const SizedBox(height: 20.0),
                  // Framing Section
                  _buildFramingSection(context),
                  const SizedBox(height: 20.0),
                  // Sentiment Section
                  _buildSentimentSection(context),
                  const SizedBox(height: 24.0),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 16.0),
                  // Compare Coverage Section
                  _buildCompareCoverageSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCredibilityText(double score) {
    if (score >= 0.85) {
      return 'High integrity reporting. Source factual track record is solid.';
    } else if (score >= 0.70) {
      return 'Moderately reliable. Contains minor subjective embellishments.';
    } else {
      return 'Caution recommended. Contains significant unsourced assertions.';
    }
  }

  Widget _buildBiasRadarPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bias Radar Spectrum',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Left-Wing', style: theme.textTheme.labelSmall),
                  Text('Center', style: theme.textTheme.labelSmall),
                  Text('Right-Wing', style: theme.textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 8.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 10.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E3A8A), // Left
                          Colors.purple,
                          Color(0xFF6750A4), // Center
                          Colors.orange,
                          Color(0xFFB91C1C), // Right
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  Align(
                    alignment: _getBiasAlignment(),
                    child: Container(
                      width: 18.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 3.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                'This article has a bias score of ${article.biasScore} towards ${article.bias}.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Alignment _getBiasAlignment() {
    final lowerBias = article.bias.toLowerCase();
    if (lowerBias.contains('left')) {
      return Alignment(-article.biasScore, 0.0);
    } else if (lowerBias.contains('right')) {
      return Alignment(article.biasScore, 0.0);
    } else {
      return Alignment.center;
    }
  }

  Widget _buildLoadedWordsSection(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Narrative Loaded Words',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Emotionally charged terms identified by AI classification:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: article.loadedWords.map((word) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: errorColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 12.0,
                    color: errorColor,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    word,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFramingSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media Framing',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            article.framing,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentimentSection(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = article.sentiment.toLowerCase().contains('positive');
    final sentimentColor = isPositive
        ? const Color(0xFF10B981)
        : Colors.blueGrey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tone & Sentiment',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Icon(
                isPositive
                    ? Icons.sentiment_satisfied_alt
                    : Icons.sentiment_neutral,
                size: 32.0,
                color: sentimentColor,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sentiment: ${article.sentiment}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    LinearProgressIndicator(
                      value: article.sentimentScore,
                      color: sentimentColor,
                      backgroundColor: sentimentColor.withValues(alpha: 0.15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompareCoverageSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compare Perspectives',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Cross-examine coverage of this story from alternative outlets:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: article.compareCoverage.length,
            itemBuilder: (context, index) {
              final comparison = article.compareCoverage[index];
              return Container(
                width: 280.0,
                margin: const EdgeInsets.only(right: 12.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                comparison.sourceName,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Text(
                              comparison.bias,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color:
                                    comparison.bias.toLowerCase().contains(
                                      'left',
                                    )
                                    ? const Color(0xFF1E3A8A)
                                    : comparison.bias.toLowerCase().contains(
                                        'right',
                                      )
                                    ? const Color(0xFFB91C1C)
                                    : theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: Text(
                            comparison.title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Credibility: ${(comparison.credibilityScore * 100).toStringAsFixed(0)}%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
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
      ],
    );
  }
}
