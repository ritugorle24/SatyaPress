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
      trackedSince: DateTime(2025, 1, 15),
      trueCount: 3,
      falseCount: 20,
      misleadingCount: 5,
      statements: [
        const StatementItem(
          id: "s1_1",
          date: "2026-06-15",
          preview: "Foreign funding detected behind regional local protests.",
          verdict: "False",
          actualOutcome: "Central intelligence spreadsheets verify regional movements were locally crowdfunded. No foreign channels or funding dockets were found.",
          explanation: "The presenter cited unverified dockets to validate foreign influence. Independent audit panels verified all donations were internal smallholder payments.",
          evidenceSources: [
            "Intelligence Bureau Funding Registry, Audit Log #ECI-2026-90",
            "Local Crowdfunding Campaign Bank Statement Audits"
          ],
        ),
        const StatementItem(
          id: "s1_2",
          date: "2026-06-08",
          preview: "Our channel viewership numbers surpassed all networks combined by 400%.",
          verdict: "False",
          actualOutcome: "BARC audit ratings verify viewership was higher than nearest competitors by 4.5% during primetime, not 400% across all channels combined.",
          explanation: "Audience analytics numbers were exaggerated to inflate network prestige, using a non-standard local reach formula rather than verified national ratings.",
          evidenceSources: [
            "Broadcast Audience Research Council (BARC) Consolidated Ratings (June 2026)",
            "Television Broadcasters Association Viewership Disclosures"
          ],
        ),
        const StatementItem(
          id: "s1_3",
          date: "2026-05-24",
          preview: "No environmental permissions were granted for the coastal construction zone.",
          verdict: "Misleading",
          actualOutcome: "RTI documents disclose that the ministry did grant temporary environmental clearances, but structural safety reviews were deferred indefinitely.",
          explanation: "The host asserted total lack of environmental clearances. Ministry files reveal that temporary dockets did exist, though structural review logs were bypass-approved.",
          evidenceSources: [
            "Ministry of Environment Coastal clearance index Ref #MOEF-7488",
            "Regional Court Environmental Permit Appeal Archives"
          ],
        ),
        const StatementItem(
          id: "s1_4",
          date: "2026-04-18",
          preview: "State agencies confirm full compliance in registry updates.",
          verdict: "True",
          actualOutcome: "State registry dockets confirm compliance protocols were fully completed during audit rounds.",
          explanation: "Audit parameters confirm state agency updates matched all mandatory structural rules.",
          evidenceSources: [
            "State Registry Compliance Logs, Ref #SRC-2026-10",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Publish full unredacted source documents and visitor registers.",
          status: "Broken",
          progress: 0.0,
        ),
        const PromiseItem(
          text: "Host a direct town hall debate with independent digital journalists.",
          status: "In Progress",
          progress: 0.25,
        ),
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
      trackedSince: DateTime(2025, 3, 10),
      trueCount: 4,
      falseCount: 9,
      misleadingCount: 2,
      statements: [
        const StatementItem(
          id: "s2_1",
          date: "2026-06-18",
          preview: "All rural cooperative banks have maintained liquidity above the statutory 18% reserve limit.",
          verdict: "False",
          actualOutcome: "Regulatory filings disclosed that at least 40 rural cooperative banks dropped to 8-10% liquidity, prompting immediate regulatory caps on customer withdrawals.",
          explanation: "While national scheduled banks met the requirement, a cluster of rural cooperative banks faced severe liquidity crunches, contradicting claims of total systemic compliance.",
          evidenceSources: [
            "Federal Financial Regulation Audit Reports, Release ID RBI-3391",
            "National Federation of State Cooperative Banks Secrecy Appeal Audit #391"
          ],
        ),
        const StatementItem(
          id: "s2_2",
          date: "2026-06-02",
          preview: "Inflation rates for basic domestic goods have dropped to historical lows of 2.1%.",
          verdict: "False",
          actualOutcome: "Central statistical indexes verify retail domestic inflation remained at 6.4%, driven by grain shortages. The 2.1% rate applies only to wholesale fuel indices.",
          explanation: "Wholesale commodity fuel rates were presented as basic household retail figures, masking ongoing domestic price rises.",
          evidenceSources: [
            "Central Statistical Organisation Consolidated Consumer Price Index (June 2026)",
            "National Agriculture Price Monitor Registry Reports"
          ],
        ),
        const StatementItem(
          id: "s2_3",
          date: "2026-05-15",
          preview: "National infrastructure funds have released 100% of the allocated irrigation budget.",
          verdict: "Misleading",
          actualOutcome: "RTI documents disclose that budget funds were sanction-approved on paper, but cash disbursements were frozen at the Treasury due to debt restructuring.",
          explanation: "The budget was technically allocated, but physical cash disbursements remained deferred, leaving rural dams without execution funds.",
          evidenceSources: [
            "Ministry of Finance Disbursement Ledger, Ref #MFD-2026-44",
            "Department of Water Resources Emergency Funding Appeals"
          ],
        ),
        const StatementItem(
          id: "s2_4",
          date: "2026-04-01",
          preview: "Foreign direct investment in fintech startups increased by twelve percent.",
          verdict: "True",
          actualOutcome: "Startup registry spreadsheets verify foreign tech investments increased by 12.1% year-on-year.",
          explanation: "Official investment logs match the stated metrics exactly.",
          evidenceSources: [
            "National Investment Promotion Board Annual Disclosures (2025-26)",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Establish liquidity emergency restructurings for rural smallholders.",
          status: "In Progress",
          progress: 0.6,
        ),
        const PromiseItem(
          text: "Deliver the complete emergency aid package to coastline marine reserves.",
          status: "Completed",
          progress: 1.0,
        ),
        const PromiseItem(
          text: "Resolve cooperative liquidity deficit within ninety days.",
          status: "Broken",
          progress: 0.0,
        ),
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
      trackedSince: DateTime(2025, 2, 20),
      trueCount: 4,
      falseCount: 6,
      misleadingCount: 2,
      statements: [
        const StatementItem(
          id: "s3_1",
          date: "2026-06-15",
          preview: "Our tech exports have grown by 300% in the last 12 months, setting a historic record.",
          verdict: "False",
          actualOutcome: "Ministry annual audit spreadsheets show service exports increased by 14.5% year-on-year. The 300% figure was a 5-year cumulative projection draft, not actual annual results.",
          explanation: "The minister cited future optimistic projections as current annual results during his press brief. Actual export registers grew steadily but did not approach the stated 300% mark.",
          evidenceSources: [
            "Ministry of Commerce Annual Service Trade Audit (FY 2025-26)",
            "Software Technology Parks of India Export Log Ref #STPI-2026-90"
          ],
        ),
        const StatementItem(
          id: "s3_2",
          date: "2026-06-01",
          preview: "New trade treaties signed with neighboring markets will eliminate tariffs on local startups.",
          verdict: "Misleading",
          actualOutcome: "The treaty eliminates tariffs only on raw components; licensing fees and intellectual property levies remain at standard high rates.",
          explanation: "The statement implies complete duty exemption. Audited treaty texts show that startup product exports still face substantial administrative customs levies.",
          evidenceSources: [
            "Bilateral Trade Agreement Draft, Annex B (IP Licensing Schedule)",
            "Startup Coalition Tariff Advisory Analysis"
          ],
        ),
        const StatementItem(
          id: "s3_3",
          date: "2026-05-10",
          preview: "Commercial grain reserves have doubled compared to historical drought thresholds.",
          verdict: "True",
          actualOutcome: "Food Corporation registers verify grain warehouse stocks reached 4.2 million tonnes, double the drought safety limit.",
          explanation: "Stated reserve metrics match warehouse audit reports exactly.",
          evidenceSources: [
            "Food Corporation of India Inventory Audit Reports (May 2026)",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Launch the export promotion portal for regional IT cooperatives.",
          status: "In Progress",
          progress: 0.75,
        ),
        const PromiseItem(
          text: "Complete trade agreement reviews with five partner nations.",
          status: "Completed",
          progress: 1.0,
        ),
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
      trackedSince: DateTime(2025, 4, 05),
      trueCount: 6,
      falseCount: 7,
      misleadingCount: 3,
      statements: [
        const StatementItem(
          id: "s4_1",
          date: "2026-06-12",
          preview: "Exit polls from the state elections show a landslide majority for the steering coalition.",
          verdict: "Misleading",
          actualOutcome: "Consolidated poll datasets show margins in 40 key seats were under 1%, which falls inside the statistical margin of error, showing no landslide pattern.",
          explanation: "The anchor reported a certain landslide before voting counts were validated, masking major regional statistical deadlocks.",
          evidenceSources: [
            "Election Commission Consolidated Seat Surveys & Poll Margin Data",
            "Association for Democratic Reforms Poll Audits"
          ],
        ),
        const StatementItem(
          id: "s4_2",
          date: "2026-05-28",
          preview: "Internal police reports verify boundary changes were completed without administrative push.",
          verdict: "False",
          actualOutcome: "Internal committee memos reveal that police departments raised security alerts regarding the boundary revisions, but these were overruled by local ministers.",
          explanation: "The journalist claimed zero administrative friction. Police files verify that local commanders submitted official safety objections that were dismissed by local authorities.",
          evidenceSources: [
            "State Police Security and Boundary Briefing Dossier #SPD-2026-10",
            "District Boundaries Advisory Board Minutes (May 2026)"
          ],
        ),
        const StatementItem(
          id: "s4_3",
          date: "2026-05-10",
          preview: "At least twelve tech startups closed operations due to the new digital framework compliance.",
          verdict: "Misleading",
          actualOutcome: "Audit registers show only two companies closed operations; the remaining ten transitioned to foreign registries to avoid local compliance structures.",
          explanation: "Asserted widespread closures. Regulatory logs verify that the startups relocated operations to international tech zones rather than dissolving.",
          evidenceSources: [
            "Ministry of Corporate Affairs Company Registry Index (FY 2025-26)",
            "Startup Founders Forum Registry Tracking Index"
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Provide equal coverage time for independent startup coalitions.",
          status: "In Progress",
          progress: 0.5,
        ),
        const PromiseItem(
          text: "Establish an independent fact-check desk for prime-time programming.",
          status: "Completed",
          progress: 1.0,
        ),
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
      trackedSince: DateTime(2025, 5, 12),
      trueCount: 4,
      falseCount: 3,
      misleadingCount: 1,
      statements: [
        const StatementItem(
          id: "s5_1",
          date: "2026-06-12",
          preview: "The new Tech Regulations Framework was drafted after three rounds of open meetings.",
          verdict: "Misleading",
          actualOutcome: "Visitor logs released under RTI reveal that while public meetings occurred, the final regulatory drafts were edited directly during closed sessions with major tech platform lobbies.",
          explanation: "Startup representatives were present at general assemblies, but the critical clauses governing AI approvals were revised during closed-door sessions with corporate lobby firms.",
          evidenceSources: [
            "Steering Committee Visitor Registers & Comm Logs, Reference #FTC-547",
            "Startup Coalition Joint Protest Declaration, June 14"
          ],
        ),
        const StatementItem(
          id: "s5_2",
          date: "2026-05-18",
          preview: "We have achieved a 98% reduction in cybersecurity incidents across regional state registries.",
          verdict: "True",
          actualOutcome: "National Computer Emergency Response Team records verify incident rates fell to near-zero following database updates.",
          explanation: "Official agency security logs match the minister's statement.",
          evidenceSources: [
            "CERT-In Regional Registry Incident Audit Database (2025-26)",
          ],
        ),
        const StatementItem(
          id: "s5_3",
          date: "2026-04-05",
          preview: "Over five thousand startup developers were consulted during the policy drafting phase.",
          verdict: "True",
          actualOutcome: "Ministry consultation registers show exactly 5,124 developers submitted comments via the feedback portal.",
          explanation: "User feedback portal receipts confirm the consultation count.",
          evidenceSources: [
            "Ministry of Electronics & IT feedback submission logs (May 2026)",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Launch the startup cybersecurity testing lab in Bangalore.",
          status: "In Progress",
          progress: 0.8,
        ),
        const PromiseItem(
          text: "Incorporate public feedback register onto the tech framework portal.",
          status: "Completed",
          progress: 1.0,
        ),
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
      trackedSince: DateTime(2025, 6, 01),
      trueCount: 11,
      falseCount: 7,
      misleadingCount: 4,
      statements: [
        const StatementItem(
          id: "s6_1",
          date: "2026-06-18",
          preview: "Corporate lobbies spent over forty-five million dollars in three weeks to defer the hearings.",
          verdict: "True",
          actualOutcome: "Lobbying disclosures confirm corporate groups spent a total of \$45.2M on campaign and scheduling delays during the hearing period.",
          explanation: "Public lobbying disclosure registries verify the cited spend.",
          evidenceSources: [
            "Federal Lobbying and Compliance Registry Database (FY 2025-26)",
          ],
        ),
        const StatementItem(
          id: "s6_2",
          date: "2026-06-02",
          preview: "Over three million citizens live in areas directly affected by water reservoir dead pool levels.",
          verdict: "Misleading",
          actualOutcome: "State Census statistics verify approximately 2.8 million residents live in the agricultural irrigation zone, though only 1.2 million face direct domestic drinking supply cuts.",
          explanation: "Exaggerated domestic impact numbers by grouping industrial irrigation areas with primary municipal water users.",
          evidenceSources: [
            "National Census Agriculture and Population Database (2025)",
            "Department of Water Resources Irrigation Zone Mapping"
          ],
        ),
        const StatementItem(
          id: "s6_3",
          date: "2026-05-15",
          preview: "Regulatory authorities have consistently blocked access to banking audits using secret exemptions.",
          verdict: "True",
          actualOutcome: "Appellate board minutes verify RBI blocked information access requests citing banking secrecy rules.",
          explanation: "Official registry filings verify persistent access denials.",
          evidenceSources: [
            "Central Information Commission Secrecy Appeal Registers (2025)",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Publish complete bibliography indexes for all environment videos.",
          status: "Completed",
          progress: 1.0,
        ),
        const PromiseItem(
          text: "Verify all corporate lobbying claims with external legal audits.",
          status: "In Progress",
          progress: 0.5,
        ),
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
      trackedSince: DateTime(2025, 7, 01),
      trueCount: 12,
      falseCount: 4,
      misleadingCount: 2,
      statements: [
        const StatementItem(
          id: "s7_1",
          date: "2026-06-10",
          preview: "Global trade networks are shifting assembly operations away from high-red-tape hubs.",
          verdict: "True",
          actualOutcome: "Consolidated trade statistics verify that over 40% of manufacturing companies relocated assembly facilities during the fiscal year.",
          explanation: "Trade registers verify the cited corporate migrations.",
          evidenceSources: [
            "International Trade Monitor Relocation Reports (2025-26)",
          ],
        ),
        const StatementItem(
          id: "s7_2",
          date: "2026-05-24",
          preview: "Three reservoir dams have reached dead storage limits, posing extreme agricultural risks.",
          verdict: "True",
          actualOutcome: "State water engineering dockets confirm water levels fell below 4% capacity at three western dams.",
          explanation: "Water registry charts match the statement exactly.",
          evidenceSources: [
            "Department of Water Resources Storage Telemetry Logs (May 2026)",
          ],
        ),
        const StatementItem(
          id: "s7_3",
          date: "2026-05-01",
          preview: "Lobby records show significant platform budgets spent to quiet anti-monopoly scrutiny.",
          verdict: "Misleading",
          actualOutcome: "Lobby logs verify platform spending reached \$45M, though only \$10M was explicitly tagged for anti-monopoly regulatory consultations.",
          explanation: "Implied the entire lobby budget was dedicated to regulatory delay, whereas audits show a wide range of policy consultation topics.",
          evidenceSources: [
            "Federal Lobbying Registry filings (Q1 2026)",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Establish the weekly international trade audit series.",
          status: "Completed",
          progress: 1.0,
        ),
        const PromiseItem(
          text: "Publish transparency scores of cited foreign policy agencies.",
          status: "In Progress",
          progress: 0.7,
        ),
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
      trackedSince: DateTime(2025, 8, 01),
      trueCount: 16,
      falseCount: 3,
      misleadingCount: 1,
      statements: [
        const StatementItem(
          id: "s8_1",
          date: "2026-06-15",
          preview: "The electoral registry update bill silently passed review without a single public minute.",
          verdict: "True",
          actualOutcome: "Legislative committee archives confirm boundary revisions were approved in closed-door sessions with no public records published.",
          explanation: "RTI documents verify that the draft bill passed committee review without legislative committee minutes.",
          evidenceSources: [
            "Legislative Committee voting registers and dockets (June 2026)",
          ],
        ),
        const StatementItem(
          id: "s8_2",
          date: "2026-06-02",
          preview: "Withdrawal limits have been restricted at cooperative banks, blocking smallholder finances.",
          verdict: "True",
          actualOutcome: "Cooperative banking union logs verify withdrawals were capped at \$500 per account across 40 banks.",
          explanation: "Audited bank audit reports confirm cash disbursement caps were active.",
          evidenceSources: [
            "Cooperative Banking Registry insolvencies monitor (June 2026)",
          ],
        ),
        const StatementItem(
          id: "s8_3",
          date: "2026-05-18",
          preview: "Massive ocean heat waves bleached seventy percent of coastline coral reef colonies.",
          verdict: "True",
          actualOutcome: "In-water marine surveys verify bleaching stress affected 71.5% of monitored coral reefs.",
          explanation: "Coastline temperature and coral bleaching surveys confirm the statistics.",
          evidenceSources: [
            "Marine Ecology Coastline Bleaching Surveys (May 2026)",
          ],
        ),
      ],
      promises: [
        const PromiseItem(
          text: "Document every community cooperative bank withdrawal freeze case.",
          status: "Completed",
          progress: 1.0,
        ),
        const PromiseItem(
          text: "Expand independent regional language environmental coverage.",
          status: "Completed",
          progress: 1.0,
        ),
      ],
    ),
  ];
}
