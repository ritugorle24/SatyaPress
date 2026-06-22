/// Model representing a key timeline milestone for an RTI filing.
class RTITimelineEvent {
  final String date;
  final String detail;

  const RTITimelineEvent({
    required this.date,
    required this.detail,
  });
}

/// Model representing official Right to Information (RTI) findings.
class RTIFinding {
  final String referenceNumber;
  final String fact;
  final String relatedStoryId;
  final String relatedStoryTitle;
  final String whyItMatters;
  final String officialSource;
  final List<RTITimelineEvent> timeline;

  const RTIFinding({
    required this.referenceNumber,
    required this.fact,
    required this.relatedStoryId,
    required this.relatedStoryTitle,
    required this.whyItMatters,
    required this.officialSource,
    required this.timeline,
  });
}

class MockRTIDatabase {
  MockRTIDatabase._();

  static const List<RTIFinding> rtiFindings = [
    RTIFinding(
      referenceNumber: "RTI/ECI/2026/0894",
      fact: "Official Commission minutes reveal that the draft bill boundary changes were submitted directly by corporate lobby groups, bypassing the public registry consultation process.",
      relatedStoryId: "b1",
      relatedStoryTitle: "Regional Electoral Reform Bill Silently Passes Committee Review",
      whyItMatters: "Proves that voter registry updates were not drafted independently, revealing direct private lobby influence in redefining voting boundaries and ID check rules.",
      officialSource: "Election Commission Registry Directorate Archives, Request Ref #894",
      timeline: [
        RTITimelineEvent(
          date: "2026-02-10",
          detail: "RTI request filed seeking communications between the committee and corporate lobbyists.",
        ),
        RTITimelineEvent(
          date: "2026-03-24",
          detail: "Request rejected under 'internal discussions' exemption. First appeal filed.",
        ),
        RTITimelineEvent(
          date: "2026-05-15",
          detail: "Information Commission overrides the rejection, ordering full disclosure of meeting minutes.",
        ),
        RTITimelineEvent(
          date: "2026-06-18",
          detail: "Files released, exposing three drafts sent directly from lobby groups to the committee chair.",
        ),
      ],
    ),
    RTIFinding(
      referenceNumber: "RTI/WRA/2026/1022",
      fact: "Internal telemetry data and safety warnings flagged a 40% reduction in reservoir inflows six months ago, but findings were marked 'restricted' to protect commercial irrigation contracts.",
      relatedStoryId: "b2",
      relatedStoryTitle: "Crucial Western Dams Approach Dead Storage Levels Amid Drought",
      whyItMatters: "Demonstrates that public safety warnings were deliberately withheld, preventing local agricultural networks from adopting early water conservation plans.",
      officialSource: "Department of Water Resources Internal Safety Reports, Appeal Decision Appeal/2026/41",
      timeline: [
        RTITimelineEvent(
          date: "2026-01-05",
          detail: "Request submitted for water level projections and engineering drafts.",
        ),
        RTITimelineEvent(
          date: "2026-03-01",
          detail: "Agency denies access, citing potential market instability in agricultural futures.",
        ),
        RTITimelineEvent(
          date: "2026-04-18",
          detail: "Hearing held before State Information Commission arguing public interest override.",
        ),
        RTITimelineEvent(
          date: "2026-05-30",
          detail: "Unredacted report released showing dam levels were projected to fall to dead storage by June.",
        ),
      ],
    ),
    RTIFinding(
      referenceNumber: "RTI/FTC/2026/0547",
      fact: "Visitor logs and calendar appointments show steering committee members met with tech platforms' corporate lobbyists three times in the 48 hours prior to the antitrust hearing's postponement.",
      relatedStoryId: "b3",
      relatedStoryTitle: "Tech Antitrust Hearing Delayed Indefinitely After Tech Lobby Push",
      whyItMatters: "Establishes a direct correlation between corporate lobby interactions and the indefinite delay of oversight legislation.",
      officialSource: "Legislative Steering Committee Visitor Registers & Comm Logs, Reference #FTC-547",
      timeline: [
        RTITimelineEvent(
          date: "2026-03-12",
          detail: "RTI petition filed for legislative calendars and platform correspondence.",
        ),
        RTITimelineEvent(
          date: "2026-04-20",
          detail: "Steering committee releases heavily redacted logs. Second appeal filed.",
        ),
        RTITimelineEvent(
          date: "2026-05-22",
          detail: "Information Commissioner rules redact codes invalid. Orders immediate release.",
        ),
        RTITimelineEvent(
          date: "2026-06-15",
          detail: "Visitor logs showing platform executives' private access are officially delivered.",
        ),
      ],
    ),
    RTIFinding(
      referenceNumber: "RTI/RBI/2026/3391",
      fact: "Regulatory audit spreadsheets from late 2025 flagged that bad debts at 40 cooperative banks had exceeded safety thresholds, but regulatory intervention was postponed due to upcoming district elections.",
      relatedStoryId: "b4",
      relatedStoryTitle: "Liquidity Crunch Restricts Withdrawals at 40 Rural Cooperative Banks",
      whyItMatters: "Confirms regulatory neglect was politically motivated, leaving depositors unaware of the insolvency risk until their accounts were frozen.",
      officialSource: "Federal Financial Regulation Audit Reports, Release ID RBI-3391",
      timeline: [
        RTITimelineEvent(
          date: "2026-02-05",
          detail: "Request filed for liquidity audit reports of cooperative banks.",
        ),
        RTITimelineEvent(
          date: "2026-03-15",
          detail: "Rejection received claiming disclosure would cause a run on the banking system.",
        ),
        RTITimelineEvent(
          date: "2026-05-02",
          detail: "Second appeal board rules that depositor protection outweighs regulatory secrecy.",
        ),
        RTITimelineEvent(
          date: "2026-06-10",
          detail: "Full audit reports released, showing insolvency risks were flagged in November 2025.",
        ),
      ],
    ),
    RTIFinding(
      referenceNumber: "RTI/MOEF/2026/7488",
      fact: "Ministry correspondence files confirm that coastline heating warnings were received from marine scientists on three separate occasions, but no emergency containment budget was released.",
      relatedStoryId: "b5",
      relatedStoryTitle: "Massive Sea Surface Heating Bleaches 70% of Coastline Reefs",
      whyItMatters: "Proves complete bureaucratic indifference to ecological warning alerts, which blocked critical emergency funding for reef preservation.",
      officialSource: "Coastal Ecological Ministry Correspondence files, Docket ID MOEF-7488",
      timeline: [
        RTITimelineEvent(
          date: "2026-03-20",
          detail: "RTI filed requesting correspondence between the Marine Institute and Ministry.",
        ),
        RTITimelineEvent(
          date: "2026-04-30",
          detail: "Ministry claims records do not exist. Appeal filed with whistleblower proof.",
        ),
        RTITimelineEvent(
          date: "2026-06-02",
          detail: "Central Information Commission issues show-cause notice to the ministry officer.",
        ),
        RTITimelineEvent(
          date: "2026-06-12",
          detail: "Correspondence released, showing scientific alerts were marked 'read' but filed away.",
        ),
      ],
    ),
  ];

  /// Retrieves the RTI finding matching a specific story ID or generates a deterministic fallback.
  static RTIFinding getByStoryId(String storyId, {String? title, String? category, String? source}) {
    try {
      return rtiFindings.firstWhere((finding) => finding.relatedStoryId == storyId);
    } catch (_) {
      final cleanTitle = title ?? "Buried Story Investigation";
      final cleanCategory = category ?? "Governance";
      final cleanSource = source ?? "Local Sources";
      final int hash = storyId.hashCode.abs();
      final refNum = "RTI/${cleanCategory.toUpperCase().replaceAll(' ', '')}/2026/${(hash % 9000) + 1000}";
      
      final fact = "Internal correspondence obtained under the RTI Act confirms that multiple audit reports regarding '$cleanTitle' were submitted to the division head, but official regulatory action was delayed.";
      final whyItMatters = "Proves that decision-makers had direct visibility into the situation at an early stage, but public disclosure was deferred.";
      final officialSource = "Ministry of ${cleanCategory.isEmpty ? 'Governance' : cleanCategory} ($cleanSource Archive), File Ref #RTI-${hash % 1000}";
      
      final timeline = [
        RTITimelineEvent(
          date: "2026-03-${(hash % 10) + 10}",
          detail: "RTI request filed seeking documents on $cleanTitle.",
        ),
        RTITimelineEvent(
          date: "2026-04-${(hash % 10) + 10}",
          detail: "Initial response from the Public Information Officer was incomplete. First appeal filed.",
        ),
        RTITimelineEvent(
          date: "2026-05-${(hash % 10) + 10}",
          detail: "State Information Commission ordered the release of the unredacted files within 15 days.",
        ),
        RTITimelineEvent(
          date: "2026-06-12",
          detail: "Documents officially released to the applicant, validating the lack of mainstream reporting.",
        ),
      ];

      return RTIFinding(
        referenceNumber: refNum,
        fact: fact,
        relatedStoryId: storyId,
        relatedStoryTitle: cleanTitle,
        whyItMatters: whyItMatters,
        officialSource: officialSource,
        timeline: timeline,
      );
    }
  }
}
