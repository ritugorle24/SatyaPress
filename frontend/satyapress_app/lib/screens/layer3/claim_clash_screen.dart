import 'package:flutter/material.dart';
import '../../data/mock_claim_data.dart';
import '../../widgets/claim_card.dart';
import '../../services/api_service.dart';

/// ClaimClashScreen displays public statements of politicians and officials compared directly to verified facts.
class ClaimClashScreen extends StatefulWidget {
  final ClaimClashItem? claim;

  const ClaimClashScreen({
    super.key,
    this.claim,
  });

  @override
  State<ClaimClashScreen> createState() => _ClaimClashScreenState();
}

class _ClaimClashScreenState extends State<ClaimClashScreen> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'True', 'False', 'Misleading'];

  List<ClaimClashItem> _apiClaims = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClaims();
  }

  Future<void> _loadClaims() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Map<String, dynamic> raw = await ApiService.fetchCompare("All");
      final List<ClaimClashItem> parsed = [];
      if (raw.isNotEmpty) {
        final id = raw['id']?.toString() ?? 'c_api_0';
        final topic = raw['topic']?.toString() ?? 'Topic Comparison';
        final summary = raw['consensus_summary']?.toString() ?? raw['key_differences']?.toString() ?? '';
        final headlineA = raw['source_a_headline']?.toString() ?? '';
        final headlineB = raw['source_b_headline']?.toString() ?? '';
        final slantA = raw['source_a_slant']?.toString() ?? '';
        final slantB = raw['source_b_slant']?.toString() ?? '';
        
        if (headlineA.isNotEmpty) {
          parsed.add(
            ClaimClashItem(
              id: id,
              avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80',
              name: 'Consensus: $topic',
              role: 'Stance Contrast Analysis',
              date: DateTime.now(),
              originalStatement: 'Source A: "$headlineA" ($slantA)',
              actualOutcome: 'Source B: "$headlineB" ($slantB)\n\nConsensus: $summary',
              verdict: ClaimVerdict.misleadingVerdict,
              explanation: raw['key_differences']?.toString() ?? 'Stance differences in reporting detected.',
              evidenceSources: const ['Source A Coverage', 'Source B Coverage'],
            ),
          );
        }
      }
      if (mounted) {
        setState(() {
          _apiClaims = parsed;
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

  List<ClaimClashItem> get _filteredClaims {
    if (widget.claim != null) {
      return [widget.claim!];
    }

    final List<ClaimClashItem> claims = [];
    claims.addAll(MockClaimDatabase.claims);
    claims.addAll(_apiClaims);

    if (_selectedFilter == 'All') {
      return claims;
    }
    return claims.where((item) {
      return item.verdict.label.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filteredClaims;
    final isSingleClaim = widget.claim != null;

    final List<Widget> slivers = [];

    if (!isSingleClaim) {
      slivers.add(
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: false,
          primary: false,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 140.0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Public Accountability Review',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Comparing verbal and written claims from public authorities against verified transparency databases.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((option) {
                      final isSelected = _selectedFilter == option;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = option;
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
              ],
            ),
          ),
        ),
      );
      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 12.0)));
    } else {
      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 8.0)));
    }

    if (_isLoading) {
      slivers.add(
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (results.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fact_check_outlined,
                  size: 48.0,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'No public statements fit this filter!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      slivers.add(
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final double horizontalPadding = isWide ? 24.0 : 16.0;

              if (isWide) {
                final col1 = <Widget>[];
                final col2 = <Widget>[];
                for (int i = 0; i < results.length; i++) {
                  if (i % 2 == 0) {
                    col1.add(ClaimCard(claim: results[i]));
                  } else {
                    col2.add(ClaimCard(claim: results[i]));
                  }
                }
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: col1,
                        ),
                      ),
                      if (!isSingleClaim) const SizedBox(width: 16.0),
                      if (!isSingleClaim)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: col2,
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: results.map((claim) => ClaimCard(claim: claim)).toList(),
                  ),
                );
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSingleClaim ? 'Statement Verification' : 'Claim Clash',
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: isSingleClaim
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: slivers,
      ),
    );
  }
}

