import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/mock_news_data.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/news_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../article_detail/article_detail_screen.dart';
import '../../services/api_service.dart';

/// SearchScreen allows filtering articles by category, source, and keyword queries.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedSource = 'All';

  final List<String> _categories = ['All', 'Tech', 'Global', 'Infrastructure'];
  final List<String> _sources = ['All', 'The Times of India', 'The Hindu', 'Republic World'];

  List<NewsArticle> _apiArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiArticles = [];
    _loadApiArticles();
  }

  Future<void> _loadApiArticles() async {
    setState(() {
      _isLoading = true;
    });

    final rawArticles = await ApiService.fetchArticles();

    final List<NewsArticle> parsedArticles = [];
    for (final article in rawArticles) {
      try {
        final title = article['title']?.toString() ?? 'Untitled Article';
        final sourceName = article['source']?.toString() ?? 'Unknown Source';
        final content = article['description']?.toString() ?? article['summary']?.toString() ?? article['content']?.toString() ?? 'Content not available from this source';
        final imageUrl = article['imageUrl']?.toString() ?? article['image_url']?.toString() ?? article['urlToImage']?.toString();
        final timestampRaw = article['publishedAt']?.toString() ?? article['time']?.toString() ?? article['timestamp']?.toString() ?? article['published_at']?.toString();
        final timestamp = _parseTimestamp(timestampRaw);

        final parsedBias = article['bias_label']?.toString() ?? article['bias']?.toString() ?? article['bias_rating']?.toString();
        
        double? parsedBiasScore;
        final rawBiasScore = article['biasScore'] ?? article['bias_score'];
        if (rawBiasScore is num) {
          double val = rawBiasScore.toDouble();
          if (val > 1.0) val = val / 100.0;
          parsedBiasScore = val;
        }

        double? parsedCredibilityScore;
        final rawCredibilityScore = article['credibility_score'] ?? article['credibilityScore'] ?? article['trust_score'] ?? article['credibility'];
        if (rawCredibilityScore is num) {
          double val = rawCredibilityScore.toDouble();
          if (val > 1.0) val = val / 100.0;
          parsedCredibilityScore = val;
        }

        double? parsedSensationalism;
        final rawSensationalism = article['sensationalism_score'] ?? article['sensationalismScore'];
        if (rawSensationalism is num) {
          parsedSensationalism = rawSensationalism.toDouble();
        }

        final parsedNeutralRewrite = article['neutral_rewrite']?.toString() ?? article['neutralRewrite']?.toString();

        List<String>? parsedReasons;
        final rawReasons = article['manipulation_reasons'] ?? article['manipulationReasons'];
        if (rawReasons is List) {
          parsedReasons = rawReasons.map((e) => e.toString()).toList();
        }
        
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

        final finalBias = parsedBias ?? _getDeterministicBias(title, sourceName);
        final finalBiasScore = parsedBiasScore ?? _getDeterministicBiasScore(title, sourceName);
        final finalCredibilityScore = parsedCredibilityScore ?? _getDeterministicCredibility(title, sourceName);
        final finalSensationalismScore = parsedSensationalism ?? _getDeterministicSensationalismScore(title, sourceName);
        final finalNeutralRewrite = parsedNeutralRewrite ?? _getDeterministicNeutralRewrite(title, sourceName);
        final finalReasons = parsedReasons ?? _getDeterministicManipulationReasons(title, sourceName);

        parsedArticles.add(
          NewsArticle(
            id: article['id']?.toString() ?? '',
            title: title,
            snippet: content,
            content: content,
            sourceName: sourceName,
            timestamp: timestamp,
            imageUrl: imageUrl,
            bias: finalBias,
            biasScore: finalBiasScore,
            credibilityScore: finalCredibilityScore,
            category: article['category']?.toString() ?? '',
            loadedWords: parseLoadedWords(),
            framing: article['media_framing']?.toString() ?? article['framing']?.toString() ?? '',
            sentiment: article['sentiment']?.toString() ?? '',
            sentimentScore: (article['sentiment_score'] as num?)?.toDouble() ?? 0.0,
            compareCoverage: parseCompareCoverage(),
            sensationalismScore: finalSensationalismScore,
            neutralRewrite: finalNeutralRewrite,
            manipulationReasons: finalReasons,
          ),
        );
      } catch (e) {
        // Skip malformed items
      }
    }

    if (mounted) {
      setState(() {
        _apiArticles = parsedArticles;
        _isLoading = false;
      });
    }
  }

  DateTime _parseTimestamp(String? timestamp) {
    if (timestamp == null) return DateTime.now();
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return DateTime.now();
    }
  }

  List<NewsArticle> get _allMergedArticles {
    final Set<String> seenKeys = {};
    final List<NewsArticle> merged = [];

    // Add promoted/hardcoded articles first
    for (final article in MockNewsDatabase.articles) {
      final key = '${article.title.toLowerCase().trim()}_${article.sourceName.toLowerCase().trim()}';
      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        merged.add(article);
      }
    }

    // Add fetched API articles next
    for (final article in _apiArticles) {
      final key = '${article.title.toLowerCase().trim()}_${article.sourceName.toLowerCase().trim()}';
      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        merged.add(article);
      }
    }

    return merged;
  }

  List<NewsArticle> get _filteredArticles {
    final searchLower = _searchQuery.toLowerCase().trim();

    return _allMergedArticles.where((article) {
      final matchesSearch = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(searchLower) ||
          article.snippet.toLowerCase().contains(searchLower) ||
          article.content.toLowerCase().contains(searchLower) ||
          article.sourceName.toLowerCase().contains(searchLower) ||
          article.category.toLowerCase().contains(searchLower);
      
      final matchesCategory = _selectedCategory == 'All' ||
          article.category.toLowerCase() == _selectedCategory.toLowerCase();
      
      final matchesSource = _selectedSource == 'All' ||
          article.sourceName.toLowerCase().contains(_selectedSource.toLowerCase().replaceAll('the', '').trim());

      return matchesSearch && matchesCategory && matchesSource;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filteredArticles;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search & Audit',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Scrollable floating Search Bar
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            primary: false,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            titleSpacing: 12.0,
            toolbarHeight: 72.0,
            automaticallyImplyLeading: false,
            title: SearchBarWidget(
              hintText: 'Search news, topics, bias...',
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          ),

          // Filters and headers section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Chips Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Categories',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: _categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryChip(
                          label: cat,
                          isSelected: _selectedCategory == cat,
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12.0),

                // Source Chips Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Sources',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: _sources.map((source) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryChip(
                          label: source == 'All' ? 'All Sources' : source,
                          isSelected: _selectedSource == source,
                          onTap: () {
                            setState(() {
                              _selectedSource = source;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Search Results Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Results (${results.length})',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (_searchQuery.isNotEmpty || _selectedCategory != 'All' || _selectedSource != 'All')
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _selectedCategory = 'All';
                              _selectedSource = 'All';
                            });
                          },
                          child: const Text('Reset filters'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),

          // Results Scroll Area
          _isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : results.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40.0),
                            Icon(
                              Icons.find_in_page_rounded,
                              size: 48.0,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'No articles match your selection.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final article = results[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: NewsCard(
                                title: article.title,
                                snippet: article.snippet,
                                sourceName: article.sourceName,
                                timestamp: article.timestamp,
                                imageUrl: article.imageUrl,
                                bias: article.bias,
                                biasScore: article.biasScore,
                                credibilityScore: article.credibilityScore,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleDetailScreen(article: article),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          childCount: results.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  // --- Deterministic Fallback Generators ---
  
  double _getDeterministicCredibility(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash);
    return 0.65 + (random.nextDouble() * 0.30); // 0.65 to 0.95
  }

  String _getDeterministicBias(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash + 1);
    const biases = ['Left', 'Left-Center', 'Center', 'Right-Center', 'Right'];
    return biases[random.nextInt(biases.length)];
  }

  double _getDeterministicBiasScore(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash + 2);
    return random.nextDouble() * 0.9;
  }

  double _getDeterministicSensationalismScore(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash + 8);
    return 0.15 + (random.nextDouble() * 0.65); // 0.15 to 0.80
  }

  String _getDeterministicNeutralRewrite(String title, String source) {
    return 'Report: $title';
  }

  List<String> _getDeterministicManipulationReasons(String title, String source) {
    final hash = (title + source).hashCode;
    final random = Random(hash + 9);
    const reasonsPool = ['Loaded Language', 'Clickbait', 'Emotional Trigger', 'Exaggeration'];
    final count = random.nextInt(3); // 0 to 2 reasons
    final shuffled = List.of(reasonsPool)..shuffle(random);
    return shuffled.sublist(0, count);
  }
}
