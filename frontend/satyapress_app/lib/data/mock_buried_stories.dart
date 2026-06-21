import 'dart:convert';

/// Model representing a buried story.
class BuriedStory {
  final String id;
  final String headline;
  final int gapScore;
  final int publicInterest;
  final int mainstreamCoverage;
  final String whyThisMatters;
  final String category;
  final DateTime date;
  final String details;

  const BuriedStory({
    required this.id,
    required this.headline,
    required this.gapScore,
    required this.publicInterest,
    required this.mainstreamCoverage,
    required this.whyThisMatters,
    required this.category,
    required this.date,
    required this.details,
  });

  factory BuriedStory.fromJson(Map<String, dynamic> json) {
    return BuriedStory(
      id: json['id'] as String,
      headline: json['headline'] as String,
      gapScore: json['gapScore'] as int,
      publicInterest: json['publicInterest'] as int,
      mainstreamCoverage: json['mainstreamCoverage'] as int,
      whyThisMatters: json['whyThisMatters'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      details: json['details'] as String,
    );
  }
}

class MockBuriedStoriesDatabase {
  MockBuriedStoriesDatabase._();

  /// Static raw JSON data representing the coverage gap metrics.
  static const String rawJsonData = '''
  [
    {
      "id": "b1",
      "headline": "Regional Electoral Reform Bill Silently Passes Committee Review",
      "gapScore": 87,
      "publicInterest": 91,
      "mainstreamCoverage": 4,
      "whyThisMatters": "Voter registry updates are being fast-tracked without public consultation, potentially altering voting boundaries and voter access rules for the next decade.",
      "category": "Politics",
      "date": "2026-06-20",
      "details": "The legislative committee has approved the draft bill which alters boundary drawing conventions and tightens digital ID check requirements. No major national news outlets have reported on this development."
    },
    {
      "id": "b2",
      "headline": "Crucial Western Dams Approach Dead Storage Levels Amid Drought",
      "gapScore": 94,
      "publicInterest": 97,
      "mainstreamCoverage": 3,
      "whyThisMatters": "Three major reservoirs supplying irrigation water are weeks away from drying up. The resulting crop failures could trigger food price inflation nationwide.",
      "category": "Environment",
      "date": "2026-06-21",
      "details": "Water levels at the reservoir complex have dropped to 4% capacity. Major media is focusing on national politics, leaving local farming networks without critical early warning alerts."
    },
    {
      "id": "b3",
      "headline": "Tech Antitrust Hearing Delayed Indefinitely After Tech Lobby Push",
      "gapScore": 76,
      "publicInterest": 82,
      "mainstreamCoverage": 6,
      "whyThisMatters": "Delayed scrutiny enables ongoing app store commission structures, keeping subscription costs inflated for digital product consumers.",
      "category": "Tech",
      "date": "2026-06-19",
      "details": "Hearings on developers' bill of rights have been deferred. Lobbying records show significant funding spent by platforms to quiet legislative action."
    },
    {
      "id": "b4",
      "headline": "Liquidity Crunch Restricts Withdrawals at 40 Rural Cooperative Banks",
      "gapScore": 82,
      "publicInterest": 88,
      "mainstreamCoverage": 6,
      "whyThisMatters": "Smallholders and local merchants are unable to access working capital, threatening local retail economies and harvest payments.",
      "category": "Economy",
      "date": "2026-06-18",
      "details": "The regulatory authority placed limits on withdrawals to prevent bank runs. The issue has been treated as local financial trouble, masking structural sector liquidity threats."
    },
    {
      "id": "b5",
      "headline": "Massive Sea Surface Heating Bleaches 70% of Coastline Reefs",
      "gapScore": 80,
      "publicInterest": 85,
      "mainstreamCoverage": 5,
      "whyThisMatters": "The death of local reef colonies will disrupt fishing populations, triggering fish stock collapses and eliminating marine protection buffer zones.",
      "category": "Environment",
      "date": "2026-06-17",
      "details": "Unprecedented water temperatures have caused widespread coral bleaching. The lack of tracking leaves conservation networks without the data needed to secure global relief packages."
    }
  ]
  ''';

  /// Parses the raw JSON string into a list of [BuriedStory] models.
  static List<BuriedStory> getStories() {
    final List<dynamic> decoded = jsonDecode(rawJsonData) as List<dynamic>;
    return decoded
        .map((item) => BuriedStory.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
