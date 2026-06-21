import 'package:flutter/material.dart';

/// A customized primary action button supporting icons and loading states.
class PrimaryButton extends StatelessWidget {
  /// The textual label of the button.
  final String label;

  /// Triggered when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Show a loading spinner instead of the text/icon.
  final bool isLoading;

  /// Expand the button to full width of its parent.
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buttonContent = isLoading
        ? SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.0),
                const SizedBox(width: 8.0),
              ],
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );

    Widget button = ElevatedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      child: buttonContent,
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
