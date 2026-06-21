import 'package:flutter/material.dart';
import '../../data/mock_leaderboard_data.dart';
import '../../widgets/leaderboard_row.dart';

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
    "Public Figures"
  ];

  List<LeaderboardEntry> get _filteredAndSortedEntries {
    final entries = List<LeaderboardEntry>.from(MockLeaderboardDatabase.entries);

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
    final allEntries = List<LeaderboardEntry>.from(MockLeaderboardDatabase.entries);
    allEntries.sort((a, b) => b.falseClaimPercentage.compareTo(a.falseClaimPercentage));
    for (int i = 0; i < allEntries.length; i++) {
      if (allEntries[i].id == entry.id) {
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
        title: Text(
          'Accountability Registry',
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
          // 1. Search Bar Widget
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
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
                              'With ${topLiarAlert.falseClaimPercentage.toStringAsFixed(0)}% false claim records across ${topLiarAlert.totalClaimsAudited} audited statements.',
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

          // 4. Leaderboard List
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  )
                : ListView.builder(
                    itemCount: results.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final entry = results[index];
                      final globalRank = _getGlobalRank(entry);
                      return LeaderboardRow(
                        entry: entry,
                        rank: globalRank,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
