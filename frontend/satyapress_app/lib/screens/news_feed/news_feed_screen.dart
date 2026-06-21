import 'package:flutter/material.dart';
import '../../data/mock_news_data.dart';
import '../../widgets/news_card.dart';
import '../article_detail/article_detail_screen.dart';

/// NewsFeedScreen shows a scrollable feed of news articles.
class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final articles = MockNewsDatabase.articles;

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
      body: ListView.builder(
        itemCount: articles.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        itemBuilder: (context, index) {
          final article = articles[index];
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
    );
  }
}
