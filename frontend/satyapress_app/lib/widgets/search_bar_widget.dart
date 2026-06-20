import 'package:flutter/material.dart';

/// A styled search bar widget customized for news search inputs.
class SearchBarWidget extends StatefulWidget {
  /// Custom controller for the text input.
  final TextEditingController? controller;

  /// Custom hint text.
  final String hintText;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when submission occurs.
  final ValueChanged<String>? onSubmitted;

  /// Callback when search is cleared.
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.hintText = 'Search news, topics, sources...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChanged);
    _showClearButton = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChanged);
    }
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClearButton != hasText) {
      setState(() {
        _showClearButton = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _controller.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!('');
                    }
                    if (widget.onClear != null) {
                      widget.onClear!();
                    }
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}
