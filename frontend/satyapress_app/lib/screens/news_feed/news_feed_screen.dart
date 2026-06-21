import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/news_card.dart';
import '../../data/mock_news_data.dart';
import '../article_detail/article_detail_screen.dart';

/// NewsFeedScreen shows a scrollable feed of news articles.
class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final articles = await ApiService.fetchArticles();

    setState(() {
      _isLoading = false;
      if (articles.isEmpty) {
        _errorMessage = 'Failed to load articles. Please try again.';
      } else {
        _articles = articles;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SatyaPress Feed',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchArticles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return Center(
        child: Text(
          'No articles available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchArticles,
      child: ListView.builder(
        itemCount: _articles.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        itemBuilder: (context, index) {
          final article = _articles[index];
          final title = article['title']?.toString() ?? 'Untitled Article';
          final sourceName = article['source']?.toString() ?? 'Unknown Source';
          final content = article['description']?.toString() ?? article['summary']?.toString() ?? article['content']?.toString() ?? 'Content not available from this source';
          final imageUrl = article['imageUrl']?.toString() ?? article['image_url']?.toString() ?? article['urlToImage']?.toString();
          final timestampRaw = article['publishedAt']?.toString() ?? article['time']?.toString() ?? article['timestamp']?.toString() ?? article['published_at']?.toString();
          final timestamp = _parseTimestamp(timestampRaw);
          
          List<CompareCoverageItem> parseCompareCoverage() {
            final raw = article['compare_coverage'];
            if (raw is List) {
              return raw.map((e) {
                if (e is Map) {
                  return CompareCoverageItem(
                    sourceName: e['sourceName']?.toString() ?? e['source']?.toString() ?? 'Unknown',
                    title: e['title']?.toString() ?? e['headline']?.toString() ?? '',
                    bias: e['bias']?.toString() ?? 'Center',
                    biasScore: (e['biasScore'] as num?)?.toDouble() ?? 0.0,
                    credibilityScore: (e['credibilityScore'] as num?)?.toDouble() ?? 0.8,
                  );
                }
                return const CompareCoverageItem(sourceName: 'Unknown', title: '', bias: 'Center', biasScore: 0.0, credibilityScore: 0.8);
              }).toList();
            }
            return [];
          }
          
          List<String> parseLoadedWords() {
            final raw = article['loaded_words'];
            if (raw is List) {
              return raw.map((e) => e.toString()).toList();
            }
            return [];
          }

          final parsedBias = article['bias_label']?.toString() ?? article['bias']?.toString() ?? article['bias_rating']?.toString();
          
          double? parsedBiasScore;
          final rawBiasScore = article['biasScore'] ?? article['bias_score'];
          if (rawBiasScore is num) {
            double val = rawBiasScore.toDouble();
            if (val > 1.0) {
              val = val / 100.0;
            }
            parsedBiasScore = val;
          }

          double? parsedCredibilityScore;
          final rawCredibilityScore = article['credibility_score'] ?? article['credibilityScore'] ?? article['trust_score'] ?? article['credibility'];
          if (rawCredibilityScore is num) {
            double val = rawCredibilityScore.toDouble();
            if (val > 1.0) {
              val = val / 100.0;
            }
            parsedCredibilityScore = val;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: NewsCard(
              title: title,
              snippet: content,
              sourceName: sourceName,
              timestamp: timestamp,
              imageUrl: imageUrl,
              bias: parsedBias,
              biasScore: parsedBiasScore,
              credibilityScore: parsedCredibilityScore,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                      article: NewsArticle(
                        id: article['id']?.toString() ?? '',
                        title: title,
                        snippet: content,
                        content: content,
                        sourceName: sourceName,
                        timestamp: timestamp,
                        imageUrl: imageUrl,
                        bias: parsedBias,
                        biasScore: parsedBiasScore,
                        credibilityScore: parsedCredibilityScore,
                        category: article['category']?.toString() ?? '',
                        loadedWords: parseLoadedWords(),
                        framing: article['media_framing']?.toString() ?? article['framing']?.toString() ?? '',
                        sentiment: article['sentiment']?.toString() ?? '',
                        sentimentScore: (article['sentiment_score'] as num?)?.toDouble() ?? 0.0,
                        compareCoverage: parseCompareCoverage(),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  DateTime _parseTimestamp(String? timestamp) {
    if (timestamp == null) return DateTime.now();
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return DateTime.now();
    }
  }
}
