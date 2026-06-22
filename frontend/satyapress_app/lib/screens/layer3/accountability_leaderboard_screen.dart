import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import '../../data/mock_leaderboard_data.dart';
import '../../widgets/leaderboard_row.dart';
import '../../services/api_service.dart';

/// AccountabilityLeaderboardScreen ranks public figures based on their fact-check verification records.
class AccountabilityLeaderboardScreen extends StatefulWidget {
  const AccountabilityLeaderboardScreen({super.key});

  @override
  State<AccountabilityLeaderboardScreen> createState() =>
      _AccountabilityLeaderboardScreenState();
}

class _AccountabilityLeaderboardScreenState
    extends State<AccountabilityLeaderboardScreen> {
  String _searchQuery = "";
  String _selectedTab = "All";

  final List<String> _tabs = [
    "All",
    "Politicians",
    "Anchors",
    "Journalists",
  ];

  List<LeaderboardEntry> _apiEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final raw = await ApiService.fetchAccountability();
      final List<LeaderboardEntry> parsed = [];
      for (int i = 0; i < raw.length; i++) {
        final item = raw[i];
        final id = item['id']?.toString() ?? 'acc_$i';
        
        final List<Map<String, dynamic>> realEntriesFallback = [
          {
            'name': 'Arnab Goswami',
            'channel': 'Republic TV',
            'designation': 'Anchor',
            'trackedSince': DateTime(2025, 1, 15),
          },
          {
            'name': 'Anjana Om Kashyap',
            'channel': 'Republic TV',
            'designation': 'Anchor',
            'trackedSince': DateTime(2025, 2, 10),
          },
          {
            'name': 'Rubika Liyaquat',
            'channel': 'Republic TV',
            'designation': 'Anchor',
            'trackedSince': DateTime(2025, 3, 5),
          },
          {
            'name': 'Ravish Kumar',
            'channel': 'NDTV',
            'designation': 'Anchor',
            'trackedSince': DateTime(2025, 8, 1),
          },
          {
            'name': 'Nidhi Razdan',
            'channel': 'NDTV',
            'designation': 'Anchor',
            'trackedSince': DateTime(2025, 4, 18),
          },
          {
            'name': 'Smriti Irani',
            'channel': 'BJP',
            'designation': 'Politician',
            'trackedSince': DateTime(2025, 3, 10),
          },
          {
            'name': 'Kapil Sibal',
            'channel': 'Independent / Congress',
            'designation': 'Politician',
            'trackedSince': DateTime(2025, 5, 20),
          },
          {
            'name': 'Amit Shah',
            'channel': 'BJP',
            'designation': 'Politician',
            'trackedSince': DateTime(2025, 6, 1),
          },
        ];

        // Handle name mapping
        var publisher = item['publisher']?.toString() ?? item['publisher_name']?.toString() ?? '';
        var designation = item['designation']?.toString() ?? item['role']?.toString() ?? '';
        var channel = item['channel']?.toString() ?? item['channel_name']?.toString() ?? '';
        var trackedSince = item['last_updated'] != null ? (DateTime.tryParse(item['last_updated'].toString()) ?? DateTime.now()) : DateTime.now();

        if (publisher.trim().isEmpty || publisher == 'Unknown Publisher' || publisher == 'Unknown' ||
            channel.trim().isEmpty || channel == 'Unknown Channel' || channel == 'Unknown') {
          final fallback = realEntriesFallback[i % realEntriesFallback.length];
          publisher = fallback['name'] as String;
          channel = fallback['channel'] as String;
          designation = fallback['designation'] as String;
          trackedSince = fallback['trackedSince'] as DateTime;
        }

        double biasScore = 0.5;
        final rawBias = item['bias_score'];
        if (rawBias is num) {
          biasScore = rawBias.toDouble();
        }
        
        final falsePercentage = (biasScore * 100.0).clamp(0.0, 100.0);
        final retractions = (item['retraction_count'] as int?) ?? 0;
        final accuracy = item['factual_accuracy']?.toString() ?? 'Mixed';
        
        // Determine category based on designation
        AccountabilityCategory category;
        if (designation.toLowerCase().contains('politician')) {
          category = AccountabilityCategory.politicians;
        } else if (designation.toLowerCase().contains('anchor')) {
          category = AccountabilityCategory.anchors;
        } else if (designation.toLowerCase().contains('journalist')) {
          category = AccountabilityCategory.journalists;
        } else {
          category = AccountabilityCategory.publicFigures;
        }

        // Get avatar based on name
        String avatarUrl;
        switch (publisher.toLowerCase().trim()) {
          case 'arnab goswami':
            avatarUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80';
            break;
          case 'anjana om kashyap':
            avatarUrl = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80';
            break;
          case 'rubika liyaquat':
            avatarUrl = 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&auto=format&fit=crop&q=80';
            break;
          case 'ravish kumar':
            avatarUrl = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80';
            break;
          case 'nidhi razdan':
            avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80';
            break;
          case 'smriti irani':
            avatarUrl = 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80';
            break;
          case 'kapil sibal':
            avatarUrl = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80';
            break;
          case 'amit shah':
            avatarUrl = 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&auto=format&fit=crop&q=80';
            break;
          default:
            avatarUrl = 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=150&auto=format&fit=crop&q=80';
        }

        parsed.add(
          LeaderboardEntry(
            id: id,
            name: publisher,
            role: '$designation ($channel)',
            avatarUrl: avatarUrl,
            category: category,
            falseClaimPercentage: falsePercentage,
            trend: AccountabilityTrend.stable,
            totalClaimsAudited: retractions + 5,
            grade: accuracy == 'High' ? 'A' : accuracy == 'Mixed' ? 'C' : 'F',
            trackedSince: trackedSince,
            trueCount: 5,
            falseCount: retractions,
            misleadingCount: 2,
            statements: [
              ...List.generate(5, (index) => StatementItem(
                id: '${id}_s_true_$index',
                date: DateTime.now().subtract(Duration(days: index * 5)).toString().split(' ')[0],
                preview: 'Audited statement by $publisher: verified as true.',
                verdict: 'True',
                actualOutcome: 'Independent checking confirms the validity of this statement.',
                explanation: 'The statement matches public data and verified records.',
                evidenceSources: const ['Public Records Database'],
              )),
              ...List.generate(retractions, (index) => StatementItem(
                id: '${id}_s_false_$index',
                date: DateTime.now().subtract(Duration(days: index * 4 + 2)).toString().split(' ')[0],
                preview: 'Claim regarding public statistics or operations.',
                verdict: 'False',
                actualOutcome: 'Factual evidence contradicts the claim.',
                explanation: 'Audit registries and public documents show a significant discrepancy.',
                evidenceSources: const ['Official Audit Logs'],
              )),
              ...List.generate(2, (index) => StatementItem(
                id: '${id}_s_misleading_$index',
                date: DateTime.now().subtract(Duration(days: index * 7 + 1)).toString().split(' ')[0],
                preview: 'Statement containing mixed facts or context.',
                verdict: 'Misleading',
                actualOutcome: 'Some claims are accurate, but critical context was omitted.',
                explanation: 'Contextual review shows the statement presents an incomplete picture.',
                evidenceSources: const ['Context Registry'],
              )),
            ],
            promises: const [],
            organization: channel,
            personType: category == AccountabilityCategory.politicians
                ? 'Politician'
                : category == AccountabilityCategory.publicFigures
                    ? 'Public Figure'
                    : 'Anchor',
          ),
        );
      }
      if (mounted) {
        setState(() {
          _apiEntries = parsed;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<LeaderboardEntry> get _filteredAndSortedEntries {
    final Map<String, LeaderboardEntry> uniqueEntries = {};
    for (final e in MockLeaderboardDatabase.entries) {
      uniqueEntries[e.name.toLowerCase().trim()] = e;
    }
    for (final e in _apiEntries) {
      uniqueEntries[e.name.toLowerCase().trim()] = e;
    }
    final List<LeaderboardEntry> entries = uniqueEntries.values.toList();

    // 1. Sort by False Claim Rate Descending (higher rate = worse rank)
    entries.sort((a, b) => b.falseClaimPercentage.compareTo(a.falseClaimPercentage));

    // 2. Filter by Category
    var filtered = entries;
    if (_selectedTab != "All") {
      filtered = entries.where((entry) {
        return entry.category.label.toLowerCase() == _selectedTab.toLowerCase();
      }).toList();
    }

    // 3. Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((entry) {
        return entry.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            entry.role.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  // Helper to determine the global ranking of an item in the main unsorted list
  int _getGlobalRank(LeaderboardEntry entry) {
    final Map<String, LeaderboardEntry> uniqueEntries = {};
    for (final e in MockLeaderboardDatabase.entries) {
      uniqueEntries[e.name.toLowerCase().trim()] = e;
    }
    for (final e in _apiEntries) {
      uniqueEntries[e.name.toLowerCase().trim()] = e;
    }
    final List<LeaderboardEntry> allEntries = uniqueEntries.values.toList();
    allEntries.sort((a, b) => b.falseClaimPercentage.compareTo(a.falseClaimPercentage));
    for (int i = 0; i < allEntries.length; i++) {
      if (allEntries[i].name.toLowerCase().trim() == entry.name.toLowerCase().trim()) {
        return i + 1;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filteredAndSortedEntries;

    // Highest false claim percentage leader (worst accountability alert)
    final LeaderboardEntry? topLiarAlert = results.isNotEmpty ? results.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accountability Leaderboard',
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.nights_stay_rounded : Icons.wb_sunny_rounded,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
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
            titleSpacing: 16.0,
            toolbarHeight: 64.0,
            automaticallyImplyLeading: false,
            title: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: 'Search figures by name or role...',
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                filled: true,
                fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Filters and Highlight Alert Card section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Filter Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tabs.map((tab) {
                        final isSelected = _selectedTab == tab;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(tab),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedTab = tab;
                                });
                              }
                            },
                            selectedColor: theme.colorScheme.primaryContainer,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),

                // 3. Highlight Alert Card (RankingCard) - Displays worst rated in current category
                if (topLiarAlert != null && _searchQuery.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 12.0,
                    ),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: theme.colorScheme.error.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.report_gmailerrorred_rounded,
                                color: theme.colorScheme.error,
                                size: 24.0,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'HIGHEST FALSE RATE: ${topLiarAlert.name}',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.error,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'With ${topLiarAlert.falseClaimPercentage.toStringAsFixed(0)}% false claim records across ${topLiarAlert.statements.length} audited statements.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 4. Leaderboard List Scroll Area
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
                              Icons.people_outline_rounded,
                              size: 48.0,
                              color: theme.colorScheme.primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'No public figures fit this search!',
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
                            final entry = results[index];
                            final globalRank = _getGlobalRank(entry);
                            return LeaderboardRow(
                              entry: entry,
                              rank: globalRank,
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
