import 'package:flutter/material.dart';
import 'mock_claim_data.dart';

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

/// Model representing a single audited statement.
class StatementItem {
  final String id;
  final String date;
  final String preview;
  final String verdict; // True, False, Misleading
  final String actualOutcome;
  final String explanation;
  final List<String> evidenceSources;

  const StatementItem({
    required this.id,
    required this.date,
    required this.preview,
    required this.verdict,
    required this.actualOutcome,
    required this.explanation,
    required this.evidenceSources,
  });

  /// Map StatementItem into ClaimClashItem to support constructor navigation.
  ClaimClashItem toClaimClashItem(String name, String role, String avatarUrl) {
    ClaimVerdict mapVerdict(String v) {
      switch (v.toLowerCase()) {
        case 'true':
          return ClaimVerdict.trueVerdict;
        case 'false':
          return ClaimVerdict.falseVerdict;
        case 'misleading':
        default:
          return ClaimVerdict.misleadingVerdict;
      }
    }

    return ClaimClashItem(
      id: id,
      avatarUrl: avatarUrl,
      name: name,
      role: role,
      date: DateTime.parse(date),
      originalStatement: preview,
      actualOutcome: actualOutcome,
      verdict: mapVerdict(verdict),
      explanation: explanation,
      evidenceSources: evidenceSources,
    );
  }
}

/// Model representing an official promise.
class PromiseItem {
  final String text;
  final String status; // Completed, In Progress, Broken
  final double progress; // 0.0 to 1.0

  const PromiseItem({
    required this.text,
    required this.status,
    required this.progress,
  });
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
  final DateTime trackedSince;
  final int trueCount;
  final int falseCount;
  final int misleadingCount;
  final List<StatementItem> statements;
  final List<PromiseItem> promises;
  final String organization;
  final String personType;

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
    required this.trackedSince,
    required this.trueCount,
    required this.falseCount,
    required this.misleadingCount,
    required this.statements,
    required this.promises,
    required this.organization,
    required this.personType,
  });
}

class MockLeaderboardDatabase {
  MockLeaderboardDatabase._();

  static final List<LeaderboardEntry> entries = _buildMockEntries();

  static List<LeaderboardEntry> _buildMockEntries() {
    final List<Map<String, dynamic>> rawData = [
      // TV Anchors
      {
        'id': 'le1',
        'name': 'Arnab Goswami',
        'role': 'Editor-in-Chief',
        'organization': 'Republic TV',
        'false_percentage': 82.0,
        'audit_count': 27,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.anchors,
      },
      {
        'id': 'le2',
        'name': 'Anjana Om Kashyap',
        'role': 'Senior Executive Editor',
        'organization': 'Republic TV',
        'false_percentage': 76.0,
        'audit_count': 21,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.anchors,
      },
      {
        'id': 'le3',
        'name': 'Rubika Liyaquat',
        'role': 'Consulting Editor',
        'organization': 'Republic TV',
        'false_percentage': 78.0,
        'audit_count': 21,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.anchors,
      },
      {
        'id': 'le4',
        'name': 'Sudhir Chaudhary',
        'role': 'Consulting Editor',
        'organization': 'Zee News',
        'false_percentage': 71.0,
        'audit_count': 18,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.anchors,
      },
      {
        'id': 'le5',
        'name': 'Rohit Sardana',
        'role': 'Senior Anchor',
        'organization': 'Aaj Tak',
        'false_percentage': 68.0,
        'audit_count': 15,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.anchors,
      },
      {
        'id': 'le6',
        'name': 'Amish Devgan',
        'role': 'Managing Editor',
        'organization': 'News18',
        'false_percentage': 65.0,
        'audit_count': 14,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.anchors,
      },
      {
        'id': 'le7',
        'name': 'Navika Kumar',
        'role': 'Group Editor',
        'organization': 'Times Now',
        'false_percentage': 61.0,
        'audit_count': 16,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.journalists,
      },
      {
        'id': 'le8',
        'name': 'Rahul Shivshankar',
        'role': 'Editorial Director',
        'organization': 'Times Now',
        'false_percentage': 58.0,
        'audit_count': 12,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.journalists,
      },
      {
        'id': 'le9',
        'name': 'Ravish Kumar',
        'role': 'Senior Executive Editor',
        'organization': 'NDTV',
        'false_percentage': 18.0,
        'audit_count': 22,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.journalists,
      },
      {
        'id': 'le10',
        'name': 'Nidhi Razdan',
        'role': 'Executive Editor',
        'organization': 'NDTV',
        'false_percentage': 15.0,
        'audit_count': 19,
        'person_type': 'Anchor',
        'category': AccountabilityCategory.journalists,
      },
      // Politicians
      {
        'id': 'le11',
        'name': 'Smriti Irani',
        'role': 'Union Cabinet Minister',
        'organization': 'BJP',
        'false_percentage': 74.0,
        'audit_count': 20,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le12',
        'name': 'Sambit Patra',
        'role': 'National Spokesperson',
        'organization': 'BJP Spokesperson',
        'false_percentage': 79.0,
        'audit_count': 25,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le13',
        'name': 'Amit Malviya',
        'role': 'National Convenor',
        'organization': 'BJP IT Cell',
        'false_percentage': 81.0,
        'audit_count': 28,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le14',
        'name': 'Kapil Sibal',
        'role': 'Member of Parliament (Rajya Sabha)',
        'organization': 'Independent',
        'false_percentage': 42.0,
        'audit_count': 16,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le15',
        'name': 'Randeep Surjewala',
        'role': 'Member of Parliament',
        'organization': 'Congress',
        'false_percentage': 55.0,
        'audit_count': 18,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le16',
        'name': 'Supriya Shrinate',
        'role': 'Chairperson Social Media',
        'organization': 'Congress',
        'false_percentage': 48.0,
        'audit_count': 14,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le17',
        'name': 'Priyanka Chaturvedi',
        'role': 'Member of Parliament',
        'organization': 'Shiv Sena UBT',
        'false_percentage': 39.0,
        'audit_count': 11,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le18',
        'name': 'Sanjay Raut',
        'role': 'Member of Parliament',
        'organization': 'Shiv Sena UBT',
        'false_percentage': 61.0,
        'audit_count': 17,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le19',
        'name': 'Asaduddin Owaisi',
        'role': 'Member of Parliament',
        'organization': 'AIMIM',
        'false_percentage': 35.0,
        'audit_count': 13,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      {
        'id': 'le20',
        'name': 'KT Rama Rao',
        'role': 'Working President',
        'organization': 'BRS',
        'false_percentage': 44.0,
        'audit_count': 12,
        'person_type': 'Politician',
        'category': AccountabilityCategory.politicians,
      },
      // Public Figures
      {
        'id': 'le21',
        'name': 'Vivek Agnihotri',
        'role': 'Filmmaker',
        'organization': 'Filmmaker',
        'false_percentage': 69.0,
        'audit_count': 9,
        'person_type': 'Public Figure',
        'category': AccountabilityCategory.publicFigures,
      },
      {
        'id': 'le22',
        'name': 'Anand Ranganathan',
        'role': 'Author',
        'organization': 'Author',
        'false_percentage': 63.0,
        'audit_count': 8,
        'person_type': 'Public Figure',
        'category': AccountabilityCategory.publicFigures,
      },
      {
        'id': 'le23',
        'name': 'Swara Bhasker',
        'role': 'Actress/Activist',
        'organization': 'Actress/Activist',
        'false_percentage': 41.0,
        'audit_count': 7,
        'person_type': 'Public Figure',
        'category': AccountabilityCategory.publicFigures,
      },
      {
        'id': 'le24',
        'name': 'Baba Ramdev',
        'role': 'Yoga Guru',
        'organization': 'Yoga Guru',
        'false_percentage': 72.0,
        'audit_count': 11,
        'person_type': 'Public Figure',
        'category': AccountabilityCategory.publicFigures,
      },
      {
        'id': 'le25',
        'name': 'Tejasvi Surya',
        'role': 'Member of Parliament (BJP MP)',
        'organization': 'BJP MP',
        'false_percentage': 67.0,
        'audit_count': 10,
        'person_type': 'Public Figure',
        'category': AccountabilityCategory.publicFigures,
      },
    ];

    final List<LeaderboardEntry> list = [];
    for (final item in rawData) {
      final String id = item['id'] as String;
      final String name = item['name'] as String;
      final String role = item['role'] as String;
      final String organization = item['organization'] as String;
      final double falsePercentage = item['false_percentage'] as double;
      final int auditCount = item['audit_count'] as int;
      final String personType = item['person_type'] as String;
      final AccountabilityCategory category = item['category'] as AccountabilityCategory;

      final String avatarUrl = "https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random";

      // Calculate true, false, misleading count based on falsePercentage and auditCount:
      final int falseCount = (auditCount * (falsePercentage / 100.0)).round();
      final int misleadingCount = (auditCount * 0.15).round().clamp(0, auditCount - falseCount);
      final int trueCount = (auditCount - falseCount - misleadingCount).clamp(0, auditCount);

      final List<StatementItem> statements = [];
      int stmtIndex = 1;
      for (int i = 0; i < falseCount; i++) {
        statements.add(StatementItem(
          id: "${id}_s_$stmtIndex",
          date: DateTime.now().subtract(Duration(days: stmtIndex * 3 + 2)).toString().split(' ')[0],
          preview: "Statement by $name: claim verified as False.",
          verdict: "False",
          actualOutcome: "Fact-checking confirms this statement is False.",
          explanation: "Public records and official data do not support the claim made by $name.",
          evidenceSources: const ["Fact-check Database", "Official Statistics"],
        ));
        stmtIndex++;
      }
      for (int i = 0; i < misleadingCount; i++) {
        statements.add(StatementItem(
          id: "${id}_s_$stmtIndex",
          date: DateTime.now().subtract(Duration(days: stmtIndex * 4 + 1)).toString().split(' ')[0],
          preview: "Statement by $name: claim verified as Misleading.",
          verdict: "Misleading",
          actualOutcome: "Some facts are correct, but critical context was omitted.",
          explanation: "The statement presents a selective or out-of-context version of the facts.",
          evidenceSources: const ["Context Audit Registry"],
        ));
        stmtIndex++;
      }
      for (int i = 0; i < trueCount; i++) {
        statements.add(StatementItem(
          id: "${id}_s_$stmtIndex",
          date: DateTime.now().subtract(Duration(days: stmtIndex * 5)).toString().split(' ')[0],
          preview: "Statement by $name: claim verified as True.",
          verdict: "True",
          actualOutcome: "Factual evidence confirms the statement is completely accurate.",
          explanation: "Official records and verification audits fully support the claim.",
          evidenceSources: const ["Official Audited Documents"],
        ));
        stmtIndex++;
      }

      String grade = "A";
      if (falsePercentage >= 70.0) {
        grade = "F";
      } else if (falsePercentage >= 50.0) {
        grade = "D";
      } else if (falsePercentage >= 35.0) {
        grade = "C";
      }

      list.add(
        LeaderboardEntry(
          id: id,
          name: name,
          role: "$role ($organization)",
          avatarUrl: avatarUrl,
          category: category,
          falseClaimPercentage: falsePercentage,
          trend: AccountabilityTrend.stable,
          totalClaimsAudited: auditCount,
          grade: grade,
          trackedSince: DateTime(2025, 1, 1),
          trueCount: trueCount,
          falseCount: falseCount,
          misleadingCount: misleadingCount,
          statements: statements,
          promises: const [],
          organization: organization,
          personType: personType,
        ),
      );
    }
    return list;
  }
}
