import 'package:flutter/material.dart';
import '../../data/mock_buried_stories.dart';
import '../../widgets/buried_story_card.dart';
import '../../widgets/filter_chips.dart';
import '../../widgets/sort_chips.dart';

/// BuriedStoriesScreen displays important stories with low mainstream media coverage.
class BuriedStoriesScreen extends StatefulWidget {
  const BuriedStoriesScreen({super.key});

  @override
  State<BuriedStoriesScreen> createState() => _BuriedStoriesScreenState();
}

class _BuriedStoriesScreenState extends State<BuriedStoriesScreen> {
  String _selectedCategory = 'All';
  String _selectedSort = 'Most Ignored';

  final List<String> _categories = [
    'All',
    'Politics',
    'Economy',
    'Environment',
    'Tech'
  ];
  final List<String> _sortOptions = ['Most Ignored', 'Most Recent'];

  List<BuriedStory> get _filteredAndSortedStories {
    final stories = MockBuriedStoriesDatabase.getStories();

    // Filter
    final filtered = stories.where((story) {
      return _selectedCategory == 'All' || story.category == _selectedCategory;
    }).toList();

    // Sort
    if (_selectedSort == 'Most Ignored') {
      filtered.sort((a, b) => b.gapScore.compareTo(a.gapScore));
    } else {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filteredAndSortedStories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coverage Gap Engine',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Header Explainer
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buried News Audit',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Analysis of critical national topics receiving minimal reporting from mainstream media networks.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Filters Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilterChips(
              selectedCategory: _selectedCategory,
              categories: _categories,
              onChanged: (cat) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),
          ),
          const SizedBox(height: 8.0),

          // Sorting Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Sort by: ',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: SortChips(
                    selectedSort: _selectedSort,
                    sortOptions: _sortOptions,
                    onChanged: (opt) {
                      setState(() {
                        _selectedSort = opt;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),

          // Audit Results List
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 48.0,
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'No coverage gaps found for this category!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final story = results[index];
                      return BuriedStoryCard(story: story);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
