import 'package:flutter/material.dart';

/// A horizontal selector row for sorting metrics.
class SortChips extends StatelessWidget {
  final String selectedSort;
  final List<String> sortOptions;
  final ValueChanged<String> onChanged;

  const SortChips({
    super.key,
    required this.selectedSort,
    required this.sortOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sortOptions.map((option) {
          final isSelected = selectedSort == option;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onChanged(option);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
