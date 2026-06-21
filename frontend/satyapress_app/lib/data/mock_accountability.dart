// lib/data/mock_accountability.dart
// Mock accountability data for SatyaPress UI development and testing.

const List<Map<String, dynamic>> mockChannels = [
  {
    'name': 'Republic TV',
    'trust_score': 'LOW',
    'total': 23,
    'flagged': 18,
    'anchors': [
      {
        'name': 'Anjana Om Kashyap',
        'tracked_since': 'Jan 2025',
        'misleading': 5,
        'false_claims': 2,
        'true_claims': 1,
        'statements': [
          {
            'date': 'May 14 2025',
            'statement': 'Do kaudi ke teachers jinhe na akkal hai na kuch',
            'verdict': 'Misleading',
            'source': 'Alt News',
          },
          {
            'date': 'March 2 2025',
            'statement': 'Pakistan launched full scale attack on Indian territory',
            'verdict': 'False',
            'source': 'Alt News',
          },
          {
            'date': 'January 15 2025',
            'statement': 'Opposition has no vision for India',
            'verdict': 'Misleading',
            'source': 'BOOM Live',
          },
        ],
      }
    ],
  },
  {
    'name': 'NDTV',
    'trust_score': 'MEDIUM',
    'total': 14,
    'flagged': 4,
    'anchors': [],
  },
  {
    'name': 'The Hindu',
    'trust_score': 'HIGH',
    'total': 9,
    'flagged': 0,
    'anchors': [],
  },
];
