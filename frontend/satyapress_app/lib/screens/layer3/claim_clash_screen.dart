import 'package:flutter/material.dart';
import '../../data/mock_claim_data.dart';
import '../../widgets/claim_card.dart';

/// ClaimClashScreen displays public statements of politicians and officials compared directly to verified facts.
class ClaimClashScreen extends StatefulWidget {
  const ClaimClashScreen({super.key});

  @override
  State<ClaimClashScreen> createState() => _ClaimClashScreenState();
}

class _ClaimClashScreenState extends State<ClaimClashScreen> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'True', 'False', 'Misleading'];

  List<ClaimClashItem> get _filteredClaims {
    final claims = MockClaimDatabase.claims;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Claim Clash',
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
          // Headline/Explainer header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
              ],
            ),
          ),

          // Filters row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
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
          ),
          const SizedBox(height: 12.0),

          // Main list container
          Expanded(
            child: results.isEmpty
                ? Center(
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
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;
                      final double horizontalPadding = isWide ? 24.0 : 16.0;

                      if (isWide) {
                        // Two column layout to prevent height constraint issues
                        final col1 = <Widget>[];
                        final col2 = <Widget>[];
                        for (int i = 0; i < results.length; i++) {
                          if (i % 2 == 0) {
                            col1.add(ClaimCard(claim: results[i]));
                          } else {
                            col2.add(ClaimCard(claim: results[i]));
                          }
                        }
                        return SingleChildScrollView(
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
                              const SizedBox(width: 16.0),
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
                        // Standard ListView on mobile
                        return ListView.builder(
                          itemCount: results.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 8.0,
                          ),
                          itemBuilder: (context, index) {
                            return ClaimCard(claim: results[index]);
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
