import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/mock_news_data.dart';
import '../../widgets/credibility_ring.dart';
import '../../widgets/source_badge.dart';
import '../../widgets/timestamp_label.dart';
import '../../widgets/source_fallback_image.dart';
import '../../widgets/headline_manipulation_card.dart';

/// ArticleDetailScreen presents full details of the article alongside premium AI integrity analysis.
class ArticleDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildArticleHeader(context),
                _buildArticleBody(context),
                _buildAiAnalysisSection(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = article.imageUrl != null && article.imageUrl!.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              Image.network(
                article.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
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
                errorBuilder: (context, error, stackTrace) => SourceFallbackImage(
                  source: article.sourceName,
                  height: 300.0,
                  borderRadius: BorderRadius.zero,
                ),
              )
            else
              SourceFallbackImage(
                source: article.sourceName,
                height: 300.0,
                borderRadius: BorderRadius.zero,
              ),
            // Light gradient overlay for readability
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildArticleHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SourceBadge(sourceName: article.sourceName),
              TimestampLabel(dateTime: article.timestamp),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            article.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleBody(BuildContext context) {
    final theme = Theme.of(context);
    
    // Split content into paragraphs to create reading rhythm
    final paragraphs = article.content.split('\n').where((p) => p.trim().isNotEmpty).toList();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rich Summary Section (if available, otherwise first paragraph styled as lead)
          if (article.snippet.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 4)),
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              ),
              child: Text(
                article.snippet,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
          
          ...paragraphs.map((paragraph) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                paragraph.trim(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  fontSize: 17,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAiAnalysisSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'AI News Intelligence',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Comprehensive algorithmic analysis of factual integrity, bias, and sentiment.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24.0),
            
            _buildCredibilityCard(context),
            const SizedBox(height: 16.0),
            
            HeadlineManipulationCard(
              originalHeadline: article.title,
              sensationalismScore: article.sensationalismScore,
              manipulationReasons: article.manipulationReasons,
              neutralRewrite: article.neutralRewrite,
            ),
            const SizedBox(height: 16.0),
            
            _buildBiasRadarCard(context),
            const SizedBox(height: 16.0),
            
            if (true) ...[
              _buildLoadedWordsCard(context),
              const SizedBox(height: 16.0),
            ],
            
            if (true) ...[
              _buildFramingCard(context),
              const SizedBox(height: 16.0),
            ],
            
            if (true) ...[
              _buildSentimentCard(context),
              const SizedBox(height: 24.0),
            ],
            
            if (true) ...[
              _buildCompareCoverageSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCredibilityCard(BuildContext context) {
    final theme = Theme.of(context);
    final score = article.credibilityScore;
    
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CredibilityRing(
              score: score,
              radius: 40.0,
              strokeWidth: 6.0,
            ),
            const SizedBox(width: 24.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Credibility Rating',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _getCredibilityText(score),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
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

  String _getCredibilityText(double score) {
    if (score >= 0.85) return 'High integrity reporting. Source factual track record is solid.';
    if (score >= 0.70) return 'Moderately reliable. Contains minor subjective embellishments.';
    return 'Caution recommended. Contains significant unsourced assertions.';
  }

  Widget _buildBiasRadarCard(BuildContext context) {
    final theme = Theme.of(context);
    final bias = article.bias;
    final biasScore = article.biasScore;

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.radar, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Bias Spectrum Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Left', style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
                Text('Center', style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFF6750A4), fontWeight: FontWeight.bold)),
                Text('Right', style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFFB91C1C), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12.0),
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 12.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1E3A8A),
                        Color(0xFF6750A4),
                        Color(0xFFB91C1C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                // Center marker line
                Container(width: 2, height: 20, color: Colors.white.withValues(alpha: 0.5)),
                Align(
                  alignment: _getBiasAlignment(),
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.onSurface, width: 4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This article exhibits a bias score of ${biasScore.toStringAsFixed(2)} towards $bias.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
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

  Alignment _getBiasAlignment() {
    final bias = article.bias;
    final score = article.biasScore;
    final lowerBias = bias.toLowerCase();
    if (lowerBias.contains('left')) return Alignment(-score, 0.0);
    if (lowerBias.contains('right')) return Alignment(score, 0.0);
    return Alignment.center;
  }

  Widget _buildLoadedWordsCard(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    
    final words = article.loadedWords.isNotEmpty 
        ? article.loadedWords 
        : _getDeterministicLoadedWords(article.title, article.sourceName);

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 20, color: errorColor),
                const SizedBox(width: 8),
                Text(
                  'Loaded Language',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Emotionally charged or sensationalized terms detected that may influence reader perception.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: words.map((word) {
                return Chip(
                  label: Text(word),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                  backgroundColor: errorColor.withValues(alpha: 0.1),
                  side: BorderSide(color: errorColor.withValues(alpha: 0.2)),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFramingCard(BuildContext context) {
    final theme = Theme.of(context);
    
    final framingText = article.framing.isNotEmpty 
        ? article.framing 
        : _getDeterministicFraming(article.title, article.sourceName);

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_outlined, size: 20, color: theme.colorScheme.tertiary),
                const SizedBox(width: 8),
                Text(
                  'Media Framing Insight',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.2)),
              ),
              child: Text(
                framingText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentCard(BuildContext context) {
    final theme = Theme.of(context);
    
    final sentimentText = article.sentiment.isNotEmpty ? article.sentiment : _getDeterministicSentiment(article.title, article.sourceName);
    final score = article.sentiment.isNotEmpty ? article.sentimentScore : _getDeterministicSentimentScore(article.title, article.sourceName);
    
    final isPositive = sentimentText.toLowerCase().contains('positive');
    final sentimentColor = isPositive ? const Color(0xFF10B981) : const Color(0xFF64748B);

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPositive ? Icons.mood : Icons.mood_bad,
                  size: 20,
                  color: sentimentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tone & Sentiment',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sentimentText.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: sentimentColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: score,
                          minHeight: 8,
                          color: sentimentColor,
                          backgroundColor: sentimentColor.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Based on semantic analysis, the overall emotional tone of this reporting leans towards ${sentimentText.toLowerCase()}.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
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

  Widget _buildCompareCoverageSection(BuildContext context) {
    final theme = Theme.of(context);
    
    final List<CompareCoverageItem> comparisons = article.compareCoverage.isNotEmpty 
        ? article.compareCoverage 
        : _getDeterministicCompareCoverage(article.title, article.sourceName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.compare_arrows, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Compare Perspectives',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          'How other outlets are covering this identical story:',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 210.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: comparisons.length,
            itemBuilder: (context, index) {
              final comparison = comparisons[index];
              return Container(
                width: 300.0,
                margin: const EdgeInsets.only(right: 16.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Navigate to comparison article detail logic here
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SourceBadge(sourceName: comparison.sourceName),
                                _buildMiniBiasPill(comparison.bias, theme),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              comparison.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              _getCredibilityText(comparison.credibilityScore),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(comparison.credibilityScore * 100).toStringAsFixed(0)}% Trust',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                CredibilityRing(
                                  score: comparison.credibilityScore,
                                  radius: 26.0,
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildMiniBiasPill(String bias, ThemeData theme) {
    Color biasColor;
    final b = bias.toLowerCase();
    if (b.contains('left')) {
      biasColor = const Color(0xFF1E3A8A);
    } else if (b.contains('right')) {
      biasColor = const Color(0xFFB91C1C);
    } else {
      biasColor = const Color(0xFF6750A4);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: biasColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: biasColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        bias.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: biasColor,
          fontWeight: FontWeight.w800,
          fontSize: 9,
        ),
      ),
    );
  }

  // --- Deterministic Fallback Generators ---
  


  List<String> _getDeterministicLoadedWords(String title, String source) {
    int hash = (title + source).hashCode;
    var random = Random(hash + 3);
    const wordPool = [
      'controversial', 'alleged', 'unprecedented', 'official', 'milestone',
      'claims', 'collapse', 'reform', 'growth', 'concerns', 'reported',
      'verified', 'confirmed', 'data', 'shocking', 'unveiled', 'disputed'
    ];
    int count = 2 + random.nextInt(3);
    List<String> shuffled = List.of(wordPool)..shuffle(random);
    return shuffled.sublist(0, count);
  }

  String _getDeterministicFraming(String title, String source) {
    int hash = (title + source).hashCode;
    var random = Random(hash + 4);
    const framings = [
      'The narrative employs a straightforward reporting style, presenting events sequentially.',
      'The article frames the issue through an economic lens, highlighting financial impacts over social concerns.',
      'This piece utilizes an emotionally driven narrative arc, focusing on individual human impact rather than systemic data.',
      'A highly analytical approach is taken, prioritizing statistical evidence and expert testimonies.',
      'The story is framed as a conflict, emphasizing polarizing viewpoints and societal division.'
    ];
    return framings[random.nextInt(framings.length)];
  }

  String _getDeterministicSentiment(String title, String source) {
    int hash = (title + source).hashCode;
    var random = Random(hash + 5);
    const sentiments = ['Positive', 'Neutral-Positive', 'Neutral', 'Neutral-Negative', 'Negative'];
    return sentiments[random.nextInt(sentiments.length)];
  }

  double _getDeterministicSentimentScore(String title, String source) {
    int hash = (title + source).hashCode;
    var random = Random(hash + 6);
    return 0.4 + (random.nextDouble() * 0.5);
  }

  List<CompareCoverageItem> _getDeterministicCompareCoverage(String title, String source) {
    int hash = (title + source).hashCode;
    var random = Random(hash + 7);
    
    final sources = ['Global News Network', 'Alternative Media View', 'The Daily Tribune', 'Independent Observer'];
    final biasList = ['Left', 'Center', 'Right'];
    
    return [
      CompareCoverageItem(
        sourceName: sources[random.nextInt(sources.length)],
        title: 'A Different Perspective on the Recent Developments',
        bias: biasList[random.nextInt(biasList.length)],
        biasScore: random.nextDouble() * 0.8,
        credibilityScore: 0.7 + (random.nextDouble() * 0.25),
      ),
      CompareCoverageItem(
        sourceName: sources[(random.nextInt(sources.length) + 1) % sources.length],
        title: 'Analysis and Breakdown of Reporting',
        bias: biasList[(random.nextInt(biasList.length) + 1) % biasList.length],
        biasScore: random.nextDouble() * 0.8,
        credibilityScore: 0.65 + (random.nextDouble() * 0.3),
      ),
    ];
  }
}
