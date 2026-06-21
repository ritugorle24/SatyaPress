import 'package:flutter/material.dart';
import '../data/mock_leaderboard_data.dart';

/// TrendIndicator renders a visual arrow signifying performance improvement or decline.
class TrendIndicator extends StatelessWidget {
  final AccountabilityTrend trend;

  const TrendIndicator({
    super.key,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    String tooltip;

    switch (trend) {
      case AccountabilityTrend.up:
        // Worsening (Higher false claim rate)
        iconData = Icons.arrow_upward_rounded;
        iconColor = const Color(0xFFEF4444); // Red
        tooltip = "False claim rate worsening";
        break;
      case AccountabilityTrend.down:
        // Improving (Lower false claim rate)
        iconData = Icons.arrow_downward_rounded;
        iconColor = const Color(0xFF10B981); // Green
        tooltip = "False claim rate improving";
        break;
      case AccountabilityTrend.stable:
        iconData = Icons.trending_flat_rounded;
        iconColor = const Color(0xFF94A3B8); // Slate gray
        tooltip = "False claim rate stable";
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size: 16.0,
          color: iconColor,
        ),
      ),
    );
  }
}
