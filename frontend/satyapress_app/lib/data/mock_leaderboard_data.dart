import 'package:flutter/material.dart';

/// Enum representing categories of public figures.
enum AccountabilityCategory {
  politicians,
  anchors,
  journalists,
  publicFigures;

  String get label {
    switch (this) {
      case AccountabilityCategory.politicians:
        return 'Politicians';
      case AccountabilityCategory.anchors:
        return 'Anchors';
      case AccountabilityCategory.journalists:
        return 'Journalists';
      case AccountabilityCategory.publicFigures:
        return 'Public Figures';
    }
  }

  IconData get icon {
    switch (this) {
      case AccountabilityCategory.politicians:
        return Icons.gavel_rounded;
      case AccountabilityCategory.anchors:
        return Icons.live_tv_rounded;
      case AccountabilityCategory.journalists:
        return Icons.edit_note_rounded;
      case AccountabilityCategory.publicFigures:
        return Icons.people_rounded;
    }
  }
}

/// Enum representing truthfulness trend.
enum AccountabilityTrend {
  up, // Worsening (meaning false claim rate went up)
  down, // Improving (meaning false claim rate went down)
  stable; // Stable
}

/// Model representing a public figure's leaderboard entry.
class LeaderboardEntry {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final AccountabilityCategory category;
  final double falseClaimPercentage;
  final AccountabilityTrend trend;
  final int totalClaimsAudited;
  final String grade;
  final List<String> recentQuotes;

  const LeaderboardEntry({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.category,
    required this.falseClaimPercentage,
    required this.trend,
    required this.totalClaimsAudited,
    required this.grade,
    required this.recentQuotes,
  });
}

class MockLeaderboardDatabase {
  MockLeaderboardDatabase._();

  static final List<LeaderboardEntry> entries = [
    LeaderboardEntry(
      id: "le1",
      name: "Arnab Goswami",
      role: "Editor-in-Chief, Republic TV",
      avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.anchors,
      falseClaimPercentage: 82.0,
      trend: AccountabilityTrend.up,
      totalClaimsAudited: 28,
      grade: "F",
      recentQuotes: [
        "Unredacted intelligence files confirm foreign funding behind regional local protests.",
        "Our channel viewership numbers surpassed all national television networks combined by 400%.",
        "No official environmental permissions were granted for the coastal construction zone."
      ],
    ),
    LeaderboardEntry(
      id: "le2",
      name: "Nirmala Sitharaman",
      role: "Minister of Finance",
      avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.politicians,
      falseClaimPercentage: 66.0,
      trend: AccountabilityTrend.up,
      totalClaimsAudited: 15,
      grade: "D",
      recentQuotes: [
        "All rural cooperative banks have maintained liquidity ratios above the statutory 18% reserve limit.",
        "Inflation rates for basic domestic goods have dropped to historical lows of 2.1%.",
        "National infrastructure funds have released 100% of the allocated irrigation budget."
      ],
    ),
    LeaderboardEntry(
      id: "le3",
      name: "Piyush Goyal",
      role: "Minister of Commerce & Industry",
      avatarUrl: "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.politicians,
      falseClaimPercentage: 54.0,
      trend: AccountabilityTrend.stable,
      totalClaimsAudited: 12,
      grade: "C-",
      recentQuotes: [
        "Our tech exports have grown by 300% in the last 12 months, setting a historic record.",
        "New trade treaties signed with neighboring markets will eliminate tariffs on local startups.",
        "Commercial grain reserves have doubled compared to historical drought thresholds."
      ],
    ),
    LeaderboardEntry(
      id: "le4",
      name: "Sardesai Rajdeep",
      role: "Consulting Editor, India Today Group",
      avatarUrl: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.journalists,
      falseClaimPercentage: 45.0,
      trend: AccountabilityTrend.up,
      totalClaimsAudited: 16,
      grade: "C+",
      recentQuotes: [
        "Exit polls from the state elections show a landslide majority for the steering coalition.",
        "Internal police reports verify boundary changes were completed without administrative push.",
        "At least twelve tech startups closed operations due to the new digital framework compliance."
      ],
    ),
    LeaderboardEntry(
      id: "le5",
      name: "Rajeev Chandrasekhar",
      role: "Minister of State for IT",
      avatarUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.politicians,
      falseClaimPercentage: 40.0,
      trend: AccountabilityTrend.down,
      totalClaimsAudited: 8,
      grade: "B-",
      recentQuotes: [
        "The new Tech Regulations Framework was drafted after three rounds of open meetings.",
        "We have achieved a 98% reduction in cybersecurity incidents across regional state registries.",
        "Over five thousand startup developers were consulted during the policy drafting phase."
      ],
    ),
    LeaderboardEntry(
      id: "le6",
      name: "Dhruv Rathee",
      role: "YouTube Video Essayist & Public Commentator",
      avatarUrl: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.publicFigures,
      falseClaimPercentage: 35.0,
      trend: AccountabilityTrend.down,
      totalClaimsAudited: 22,
      grade: "B",
      recentQuotes: [
        "Corporate lobbies spent over forty-five million dollars in three weeks to defer the hearings.",
        "Over three million citizens live in areas directly affected by water reservoir死 dead pool levels.",
        "Regulatory authorities have consistently blocked access to banking audits using secret exemptions."
      ],
    ),
    LeaderboardEntry(
      id: "le7",
      name: "Palki Sharma",
      role: "Managing Editor, Firstpost",
      avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.anchors,
      falseClaimPercentage: 25.0,
      trend: AccountabilityTrend.down,
      totalClaimsAudited: 18,
      grade: "A-",
      recentQuotes: [
        "Global trade networks are shifting assembly operations away from high-red-tape hubs.",
        "Three reservoir dams have reached dead storage limits, posing extreme agricultural risks.",
        "Lobby records show significant platform budgets spent to quiet anti-monopoly scrutiny."
      ],
    ),
    LeaderboardEntry(
      id: "le8",
      name: "Ravish Kumar",
      role: "Independent Journalist",
      avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80",
      category: AccountabilityCategory.journalists,
      falseClaimPercentage: 15.0,
      trend: AccountabilityTrend.stable,
      totalClaimsAudited: 20,
      grade: "A",
      recentQuotes: [
        "The electoral registry update bill silently passed review without a single public minute.",
        "Withdrawal limits have been restricted at cooperative banks, blocking smallholder finances.",
        "Massive ocean heat waves bleached seventy percent of coastline coral reef colonies."
      ],
    ),
  ];
}
