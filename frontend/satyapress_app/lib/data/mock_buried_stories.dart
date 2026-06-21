// lib/data/mock_buried_stories.dart
// Mock buried stories data for SatyaPress UI development and testing.
// These represent underreported stories with high public interest
// but low mainstream media coverage.

const List<Map<String, dynamic>> mockBuriedStories = [
  {
    "topic": "Water Crisis in Marathwada",
    "location": "Marathwada, Maharashtra",
    "gap_score": 94,
    "public_interest": "Very High",
    "media_coverage": "Minimal",
    "reddit_mentions": 50000,
    "sources_covered": 1,
    "why_it_matters":
        "• Over 14 villages have had no municipal water supply for 25+ consecutive days.\n"
        "• Crops are failing and livestock are dying, threatening livelihoods of thousands of families.\n"
        "• The crisis is absent from prime-time debates despite affecting lakhs of citizens.",
    "rti_tag": true,
    "rti_note":
        "An RTI filed in 2024 revealed that ₹340 crore allocated for Marathwada water infrastructure was unspent.",
  },
  {
    "topic": "Farmer Protests in Vidarbha",
    "location": "Vidarbha, Maharashtra",
    "gap_score": 87,
    "public_interest": "High",
    "media_coverage": "Low",
    "reddit_mentions": 12000,
    "sources_covered": 1,
    "why_it_matters":
        "• Farmers are protesting against rising input costs with no relief from the state government.\n"
        "• Suicide rates among Vidarbha farmers remain among the highest in the country.\n"
        "• The protest has lasted over 3 weeks but received no prime-time coverage from major national outlets.",
    "rti_tag": false,
    "rti_note": "",
  },
  {
    "topic": "Tribal Displacement in Odisha",
    "location": "Niyamgiri Hills, Odisha",
    "gap_score": 91,
    "public_interest": "High",
    "media_coverage": "None",
    "reddit_mentions": 8000,
    "sources_covered": 0,
    "why_it_matters":
        "• Thousands of tribal families face displacement due to a new mining project.\n"
        "• Constitutional protections under Schedule V are reportedly being bypassed.\n"
        "• No mainstream news outlet has sent reporters to cover the affected villages.",
    "rti_tag": false,
    "rti_note": "",
  },
  {
    "topic": "Teacher Protest in Jharkhand",
    "location": "Ranchi, Jharkhand",
    "gap_score": 78,
    "public_interest": "Moderate",
    "media_coverage": "None",
    "reddit_mentions": 5000,
    "sources_covered": 0,
    "why_it_matters":
        "• Over 10,000 contractual teachers have been protesting unpaid salaries for 6 months.\n"
        "• The schools they teach in serve predominantly rural and underprivileged communities.\n"
        "• The protest is completely absent from national news despite the scale of the issue.",
    "rti_tag": false,
    "rti_note": "",
  },
  {
    "topic": "Governance Failure in Bihar",
    "location": "Bihar",
    "gap_score": 83,
    "public_interest": "High",
    "media_coverage": "None",
    "reddit_mentions": 9000,
    "sources_covered": 0,
    "why_it_matters":
        "• Multiple state welfare schemes show less than 30% fund utilisation for the third year in a row.\n"
        "• Beneficiaries of schemes like housing and nutrition programs report never receiving entitlements.\n"
        "• State officials have not responded to questions from local journalists or civil society groups.",
    "rti_tag": false,
    "rti_note": "",
  },
];
