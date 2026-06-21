import 'dart:convert';

/// Model representing a key timeline milestone for a buried story.
class TimelineEvent {
  final String date;
  final String event;

  const TimelineEvent({
    required this.date,
    required this.event,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      date: json['date'] as String,
      event: json['event'] as String,
    );
  }
}

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
  final List<String> sourcesCovering;
  final List<String> sourcesIgnoring;
  final List<TimelineEvent> timeline;
  final String aiInsight;

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
    required this.sourcesCovering,
    required this.sourcesIgnoring,
    required this.timeline,
    required this.aiInsight,
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
      sourcesCovering: List<String>.from(json['sourcesCovering'] as List),
      sourcesIgnoring: List<String>.from(json['sourcesIgnoring'] as List),
      timeline: (json['timeline'] as List)
          .map((item) => TimelineEvent.fromJson(item as Map<String, dynamic>))
          .toList(),
      aiInsight: json['aiInsight'] as String,
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
      "details": "The legislative committee has approved the draft bill which alters boundary drawing conventions and tightens digital ID check requirements. No major national news outlets have reported on this development.",
      "sourcesCovering": [
        "Independent Registry Ledger",
        "The State Capital Sentinel",
        "Democracy Watch Substack"
      ],
      "sourcesIgnoring": [
        "National Cable News Network",
        "Global Tribune Herald",
        "Metro Daily Bulletin",
        "Morning Chronicle Post"
      ],
      "timeline": [
        {
          "date": "2026-06-05",
          "event": "Draft bill introduced by committee chair without public hearing."
        },
        {
          "date": "2026-06-12",
          "event": "Closed-door markup session finalized with minor edits."
        },
        {
          "date": "2026-06-18",
          "event": "Tech lobby submits registry compliance petition."
        },
        {
          "date": "2026-06-20",
          "event": "Bill voted out of committee 7-2 with minimal minutes published."
        }
      ],
      "aiInsight": "This story has high structural impact but lacks visual elements or sensational conflict, making it less attractive for high-traffic cable news networks. Additionally, the fast-track committee nature keeps the legislative text buried under jargon, shielding it from standard press radar."
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
      "details": "Water levels at the reservoir complex have dropped to 4% capacity. Major media is focusing on national politics, leaving local farming networks without critical early warning alerts.",
      "sourcesCovering": [
        "West Coast Water Journal",
        "Dryland Farmers Gazette",
        "Hydrological Science Forum"
      ],
      "sourcesIgnoring": [
        "National Cable News Network",
        "Global Tribune Herald",
        "Metro Daily Bulletin",
        "Morning Chronicle Post"
      ],
      "timeline": [
        {
          "date": "2026-04-15",
          "event": "Reservoir capacity falls below historical median of 35%."
        },
        {
          "date": "2026-05-10",
          "event": "State water engineers declare Tier 1 shortage warnings."
        },
        {
          "date": "2026-06-01",
          "event": "Agriculture union files emergency allocation requests."
        },
        {
          "date": "2026-06-21",
          "event": "Dead pool storage levels reached at three secondary dams."
        }
      ],
      "aiInsight": "Mainstream networks are prioritizing national election cycles and high-profile trials, which draw higher immediate ratings. Because slow-onset environmental degradation has no single 'breaking point,' editors delay reporting until the crisis reaches domestic kitchen tables."
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
      "details": "Hearings on developers' bill of rights have been deferred. Lobbying records show significant funding spent by platforms to quiet legislative action.",
      "sourcesCovering": [
        "Byte & Law Quarterly",
        "Silicon Platform Watchdog",
        "Capital Antitrust Report"
      ],
      "sourcesIgnoring": [
        "National Cable News Network",
        "Global Tribune Herald",
        "Metro Daily Bulletin",
        "Morning Chronicle Post"
      ],
      "timeline": [
        {
          "date": "2026-05-20",
          "event": "Senate subcommittee schedules antitrust oversight hearing."
        },
        {
          "date": "2026-06-02",
          "event": "Joint platform coalition files compliance objections."
        },
        {
          "date": "2026-06-12",
          "event": "Lobbying disclosures reveal \$45M spending surge."
        },
        {
          "date": "2026-06-19",
          "event": "Hearing postponed indefinitely without press release."
        }
      ],
      "aiInsight": "Corporate ownership of major media networks results in a conflict of interest when reporting on tech antitrust, leading to minimal coverage of lobby spending. The story's reliance on complex regulatory filings further deters fast-paced news outlets."
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
      "details": "The regulatory authority placed limits on withdrawals to prevent bank runs. The issue has been treated as local financial trouble, masking structural sector liquidity threats.",
      "sourcesCovering": [
        "Rural Finance Monitor",
        "Smallholder Advocate",
        "Cooperative Banking Digest"
      ],
      "sourcesIgnoring": [
        "National Cable News Network",
        "Global Tribune Herald",
        "Metro Daily Bulletin",
        "Morning Chronicle Post"
      ],
      "timeline": [
        {
          "date": "2026-05-18",
          "event": "Interbank lending rates spike for rural cooperatives."
        },
        {
          "date": "2026-06-02",
          "event": "Withdrawal limits of \$500 per day enacted at 12 branches."
        },
        {
          "date": "2026-06-10",
          "event": "Regulator implements blanket restructuring orders."
        },
        {
          "date": "2026-06-18",
          "event": "40 banks halt cash disbursements entirely."
        }
      ],
      "aiInsight": "Mainstream financial outlets tend to focus on major stock markets and corporate indices, categorizing small cooperative failures as localized problems. This mask of local issues obscures a systemic risk to agricultural supply-chain finance."
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
      "details": "Unprecedented water temperatures have caused widespread coral bleaching. The lack of tracking leaves conservation networks without the data needed to secure global relief packages.",
      "sourcesCovering": [
        "Marine Biology Letters",
        "Coastal Ecological Review",
        "Eco-Science Press"
      ],
      "sourcesIgnoring": [
        "National Cable News Network",
        "Global Tribune Herald",
        "Metro Daily Bulletin",
        "Morning Chronicle Post"
      ],
      "timeline": [
        {
          "date": "2026-05-01",
          "event": "Sea surface temperature anomalies hit +2.1°C."
        },
        {
          "date": "2026-05-25",
          "event": "In-water divers report early coral stress indicators."
        },
        {
          "date": "2026-06-10",
          "event": "Reef survey confirms bleaching across 70% of study zone."
        },
        {
          "date": "2026-06-17",
          "event": "International oceanographic union issues red alert status."
        }
      ],
      "aiInsight": "Niche scientific data is rarely translated into public interest narratives by general news desks. Without dynamic imagery or direct metropolitan impact, environmental crises are sidelined behind domestic political debates."
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
