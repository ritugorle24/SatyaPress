import 'package:flutter/material.dart';

/// A horizontal filter chips list for category selection.
class FilterChips extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onChanged;

  const FilterChips({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onChanged(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
