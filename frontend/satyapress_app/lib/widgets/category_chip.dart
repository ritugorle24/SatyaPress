import 'package:flutter/material.dart';

/// A toggleable filter/tag chip widget (e.g. for "Politics", "Tech").
class CategoryChip extends StatelessWidget {
  /// The textual label of the category.
  final String label;

  /// Selected state of the chip.
  final bool isSelected;

  /// Triggered when the chip is pressed.
  final VoidCallback? onTap;

  /// Optional icon placed before the label.
  final IconData? icon;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final backgroundColor = isSelected 
        ? theme.colorScheme.primaryContainer 
        : theme.colorScheme.surfaceContainerHighest;

    final textColor = isSelected 
        ? theme.colorScheme.onPrimaryContainer 
        : theme.colorScheme.onSurfaceVariant;

    final borderColor = isSelected 
        ? theme.colorScheme.primary.withValues(alpha: 0.5) 
        : theme.colorScheme.outlineVariant;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.0,
                color: textColor,
              ),
              const SizedBox(width: 6.0),
            ],
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
