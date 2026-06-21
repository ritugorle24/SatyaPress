import 'package:flutter/material.dart';
import '../../data/mock_news_data.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/news_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../article_detail/article_detail_screen.dart';

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

  List<NewsArticle> get _filteredArticles {
    return MockNewsDatabase.articles.where((article) {
      final matchesSearch = article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.snippet.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.content.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' || article.category == _selectedCategory;
      
      final matchesSource = _selectedSource == 'All' || article.sourceName == _selectedSource;

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
      backgroundColor: theme.colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchBarWidget(
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
          // Results Scroll Area
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  )
                : ListView.builder(
                    itemCount: results.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemBuilder: (context, index) {
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
                  ),
          ),
        ],
      ),
    );
  }
}
