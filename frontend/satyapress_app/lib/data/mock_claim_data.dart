import 'package:flutter/material.dart';

/// Enum representing the fact-check verdict.
enum ClaimVerdict {
  trueVerdict,
  falseVerdict,
  misleadingVerdict;

  String get label {
    switch (this) {
      case ClaimVerdict.trueVerdict:
        return 'TRUE';
      case ClaimVerdict.falseVerdict:
        return 'FALSE';
      case ClaimVerdict.misleadingVerdict:
        return 'MISLEADING';
    }
  }

  Color get color {
    switch (this) {
      case ClaimVerdict.trueVerdict:
        return const Color(0xFF10B981); // Soft Green
      case ClaimVerdict.falseVerdict:
        return const Color(0xFFEF4444); // Soft Red
      case ClaimVerdict.misleadingVerdict:
        return const Color(0xFFF59E0B); // Soft Amber
    }
  }

  IconData get icon {
    switch (this) {
      case ClaimVerdict.trueVerdict:
        return Icons.check_circle_rounded;
      case ClaimVerdict.falseVerdict:
        return Icons.cancel_rounded;
      case ClaimVerdict.misleadingVerdict:
        return Icons.warning_amber_rounded;
    }
  }
}

/// Model representing a public claim comparison entry.
class ClaimClashItem {
  final String id;
  final String avatarUrl;
  final String name;
  final String role;
  final DateTime date;
  final String originalStatement;
  final String actualOutcome;
  final ClaimVerdict verdict;
  final String explanation;
  final List<String> evidenceSources;

  const ClaimClashItem({
    required this.id,
    required this.avatarUrl,
    required this.name,
    required this.role,
    required this.date,
    required this.originalStatement,
    required this.actualOutcome,
    required this.verdict,
    required this.explanation,
    required this.evidenceSources,
  });
}

class MockClaimDatabase {
  MockClaimDatabase._();

  static final List<ClaimClashItem> claims = [
    ClaimClashItem(
      id: "c1",
      avatarUrl: "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&auto=format&fit=crop&q=80",
      name: "Piyush Goyal",
      role: "Minister of Commerce & Industry",
      date: DateTime(2026, 6, 15),
      originalStatement: "Our tech exports have grown by 300% in the last 12 months, setting a historic record for digital services growth in the region.",
      actualOutcome: "Ministry annual audit spreadsheets show service exports increased by 14.5% year-on-year. The 300% figure was a 5-year cumulative projection draft, not actual annual results.",
      verdict: ClaimVerdict.falseVerdict,
      explanation: "The minister cited future optimistic projections as current annual results during his press brief. Actual export registers grew steadily but did not approach the stated 300% mark.",
      evidenceSources: [
        "Ministry of Commerce Annual Service Trade Audit (FY 2025-26)",
        "Software Technology Parks of India Export Log Ref #STPI-2026-90"
      ],
    ),
    ClaimClashItem(
      id: "c2",
      avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80",
      name: "Nirmala Sitharaman",
      role: "Minister of Finance",
      date: DateTime(2026, 6, 18),
      originalStatement: "All rural cooperative banks have maintained liquidity ratios above the statutory 18% reserve limit throughout the current year.",
      actualOutcome: "Regulatory filings disclosed that at least 40 rural cooperative banks dropped to 8-10% liquidity, prompting immediate regulatory caps on customer withdrawals.",
      verdict: ClaimVerdict.falseVerdict,
      explanation: "While national scheduled banks met the requirement, a cluster of rural cooperative banks faced severe liquidity crunches, contradicting claims of total systemic compliance.",
      evidenceSources: [
        "Federal Financial Regulation Audit Reports, Release ID RBI-3391",
        "National Federation of State Cooperative Banks Secrecy Appeal Audit #391"
      ],
    ),
    ClaimClashItem(
      id: "c3",
      avatarUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80",
      name: "Rajeev Chandrasekhar",
      role: "Minister of State for Electronics & IT",
      date: DateTime(2026, 6, 12),
      originalStatement: "The new Tech Regulations Framework was drafted after three rounds of open meetings with local tech startup founders.",
      actualOutcome: "Visitor logs released under RTI reveal that while public meetings occurred, the final regulatory drafts were edited directly during closed sessions with major tech platform lobbies.",
      verdict: ClaimVerdict.misleadingVerdict,
      explanation: "Startup representatives were present at general assemblies, but the critical clauses governing AI approvals were revised during closed-door sessions with corporate lobby firms.",
      evidenceSources: [
        "Steering Committee Visitor Registers & Comm Logs, Reference #FTC-547",
        "Startup Coalition Joint Protest Declaration, June 14"
      ],
    ),
    ClaimClashItem(
      id: "c4",
      avatarUrl: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&auto=format&fit=crop&q=80",
      name: "Dr. Sunita Narain",
      role: "Environmental Science Director",
      date: DateTime(2026, 6, 17),
      originalStatement: "Over 70% of the coastline coral colonies are undergoing bleaching due to record sea surface temperatures this summer.",
      actualOutcome: "Marine Biology Institute satellite surveys and in-water divers' reports confirm bleaching stress across approximately 71.5% of the coastal coral monitoring zones.",
      verdict: ClaimVerdict.trueVerdict,
      explanation: "Ocean temperature monitoring data directly confirms the statement. Sea surface temperatures reached +2.1°C above historical medians, triggering reef bleaching.",
      evidenceSources: [
        "Marine Biology Coastline Survey, Sea Surface Bleaching Index 2026",
        "Ministry of Environment Correspondence Docket MOEF-7488"
      ],
    ),
  ];
}
