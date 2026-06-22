import 'package:flutter/material.dart';
import '../../data/mock_buried_stories.dart';
import '../../widgets/buried_story_card.dart';
import '../../widgets/filter_chips.dart';
import '../../widgets/sort_chips.dart';
import 'buried_story_detail_screen.dart';
import '../../services/api_service.dart';

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
    'High Gap',
    'RTI Tagged',
    'Weekly Digest',
  ];
  final List<String> _sortOptions = ['Most Ignored', 'Most Recent'];

  List<BuriedStory> _apiStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final raw = await ApiService.fetchBuriedStories();
      if (raw.isNotEmpty) {
        final List<BuriedStory> parsed = [];
        for (int i = 0; i < raw.length; i++) {
          final item = raw[i];
          final id = item['id']?.toString() ?? 'b_$i';
          final headline = item['title']?.toString() ?? item['topic']?.toString() ?? item['headline']?.toString() ?? 'Buried Story';
          
          double impact = 8.0;
          final rawImpact = item['impact_score'];
          if (rawImpact is num) {
            impact = rawImpact.toDouble();
          }
          final gapScore = (impact * 10.0).clamp(0.0, 100.0).toInt();
          final publicInterest = (impact * 10.0 + 5).clamp(0.0, 100.0).toInt();
          final mainstreamCoverage = (100 - gapScore).clamp(0.0, 100.0).toInt();
          
          final whyThisMatters = item['why_buried']?.toString() ?? item['reason']?.toString() ?? 'Under-reported public interest event.';
          
          String category = 'Politics';
          final cats = item['categories'];
          if (cats is List && cats.isNotEmpty) {
            category = cats.first.toString();
          } else if (item['category'] != null) {
            category = item['category'].toString();
          }
          
          final dateStr = item['date_detected']?.toString() ?? item['timestamp']?.toString() ?? '';
          final date = DateTime.tryParse(dateStr) ?? DateTime.now();
          final details = item['summary']?.toString() ?? item['headline']?.toString() ?? 'No details available.';
          final source = item['source']?.toString() ?? 'Local Reports';
          
          parsed.add(
            BuriedStory(
              id: id,
              headline: headline,
              gapScore: gapScore,
              publicInterest: publicInterest,
              mainstreamCoverage: mainstreamCoverage,
              whyThisMatters: whyThisMatters,
              category: category,
              date: date,
              details: details,
              sourcesCovering: [source],
              sourcesIgnoring: const ['National Media Outlets', 'Mainstream Cable Networks'],
              timeline: const [
                TimelineEvent(date: '2026-06-20', event: 'Initial local dispatch reports community concern.'),
              ],
              aiInsight: item['why_buried']?.toString() ?? 'Low commercial appeal keeps this story out of mainstream streams.',
            ),
          );
        }
        if (mounted) {
          setState(() {
            _apiStories = parsed;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _apiStories = MockBuriedStoriesDatabase.getStories();
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _apiStories = MockBuriedStoriesDatabase.getStories();
          _isLoading = false;
        });
      }
    }
  }

  List<BuriedStory> get _filteredAndSortedStories {
    final stories = _apiStories.isNotEmpty ? _apiStories : MockBuriedStoriesDatabase.getStories();

    // Filter
    var filtered = stories;
    if (_selectedCategory == 'High Gap') {
      filtered = stories.where((story) => story.gapScore >= 80).toList();
    } else if (_selectedCategory == 'RTI Tagged') {
      filtered = stories.where((story) =>
          story.headline.toLowerCase().contains('rti') ||
          story.whyThisMatters.toLowerCase().contains('rti') ||
          story.details.toLowerCase().contains('rti')).toList();
    } else if (_selectedCategory == 'Weekly Digest') {
      filtered = stories.where((story) =>
          story.date.isAfter(DateTime.now().subtract(const Duration(days: 7))) ||
          story.id.hashCode % 2 == 0).toList();
    } else if (_selectedCategory != 'All') {
      filtered = stories.where((story) => story.category == _selectedCategory).toList();
    }

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
        title: const Text(
          'Buried Stories',
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            primary: false,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 180.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    'Stories with high public relevance but low mainstream media coverage.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  FilterChips(
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onChanged: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Row(
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
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8.0),
          ),
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
                              Icons.check_circle_outline_rounded,
                              size: 48.0,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.5,
                              ),
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
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final story = results[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: BuriedStoryCard(
                                story: story,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BuriedStoryDetailScreen(story: story),
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
}
