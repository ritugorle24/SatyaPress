class CompareCoverageItem {
  final String sourceName;
  final String title;
  final String bias;
  final double biasScore;
  final double credibilityScore;

  const CompareCoverageItem({
    required this.sourceName,
    required this.title,
    required this.bias,
    required this.biasScore,
    required this.credibilityScore,
  });
}

class NewsArticle {
  final String id;
  final String title;
  final String snippet;
  final String content;
  final String sourceName;
  final DateTime timestamp;
  final String? imageUrl;
  final String bias;
  final double biasScore;
  final double credibilityScore;
  final String category;
  final List<String> loadedWords;
  final String framing;
  final String sentiment;
  final double sentimentScore;
  final List<CompareCoverageItem> compareCoverage;
  
  // Sensationalism metrics for Headline Manipulation Detector
  final double sensationalismScore;
  final String neutralRewrite;
  final List<String> manipulationReasons;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.snippet,
    required this.content,
    required this.sourceName,
    required this.timestamp,
    this.imageUrl,
    required this.bias,
    required this.biasScore,
    required this.credibilityScore,
    required this.category,
    required this.loadedWords,
    required this.framing,
    required this.sentiment,
    required this.sentimentScore,
    required this.compareCoverage,
    required this.sensationalismScore,
    required this.neutralRewrite,
    required this.manipulationReasons,
  });
}

class MockNewsDatabase {
  MockNewsDatabase._();

  static final List<NewsArticle> articles = [
    NewsArticle(
      id: '1',
      title: 'Government Enacts Sweeping Tech Regulations Framework',
      snippet: 'India\'s new digital framework imposes stringent regulations on artificial intelligence models, social platforms, and user privacy protection guidelines.',
      content: 'The government has officially announced the implementation of the Digital Protection and Tech Framework (DPTF). Under the new rules, tech companies operating in India must obtain explicit authorization before launching large-scale generative AI models. The framework also strengthens data sovereignty requirements and imposes severe financial penalties for cybersecurity breaches. Proponents argue it establishes necessary safety guardrails, while critics warn it could increase compliance burdens and slow down technical innovation in the region.',
      sourceName: 'The Times of India',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&auto=format&fit=crop&q=60',
      bias: 'Center',
      biasScore: 0.12,
      credibilityScore: 0.89,
      category: 'Tech',
      loadedWords: ['sweeping', 'stringent', 'severe', 'sovereignty', 'guardrails'],
      framing: 'The event is presented as an authoritative policy intervention. The headline uses strong verbs to emphasize governance power, framing the law as a structured security measure.',
      sentiment: 'Neutral-Positive',
      sentimentScore: 0.62,
      sensationalismScore: 0.38,
      neutralRewrite: 'Government announces new digital framework regulating AI and social platforms',
      manipulationReasons: ['Loaded Language', 'Exaggeration'],
      compareCoverage: [
        const CompareCoverageItem(
          sourceName: 'Left News Daily',
          title: 'Activists Alarm: New Digital Rules Grant Authority Massive Censorship Power',
          bias: 'Left-Center',
          biasScore: 0.68,
          credibilityScore: 0.74,
        ),
        const CompareCoverageItem(
          sourceName: 'Free Market Review',
          title: 'Regulatory Red Tape: How the Tech Policy Will Stifle Local Startups',
          bias: 'Right-Center',
          biasScore: 0.72,
          credibilityScore: 0.81,
        ),
      ],
    ),
    NewsArticle(
      id: '2',
      title: 'Global Economic Summit Pledges \$100B for Climate Action',
      snippet: 'Dozens of nations agree to massive funding support for green transition programs in developing economies during the economic summit.',
      content: 'At the conclusion of the Global Economic Summit in New Delhi, delegates representing forty-five countries signed a historic climate pact. The agreement pledges \$100 billion annually starting next year to finance renewable energy projects and carbon mitigation strategies in emerging markets. Developed nations will contribute the majority of the capital. However, several climate action groups remain skeptical, noting that similar commitments made in the past have not been fully honored.',
      sourceName: 'The Hindu',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      imageUrl: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=600&auto=format&fit=crop&q=60',
      bias: 'Left-Center',
      biasScore: 0.55,
      credibilityScore: 0.92,
      category: 'Global',
      loadedWords: ['historic', 'pledges', 'skeptical', 'mitigation', 'emerging'],
      framing: 'Presented with a positive focus on international unity and environmental responsibility, highlighting the scale of funding while casting light doubt on industrial follow-through.',
      sentiment: 'Positive',
      sentimentScore: 0.82,
      sensationalismScore: 0.22,
      neutralRewrite: 'Countries agree on \$100 billion annual climate funding at Global Summit',
      manipulationReasons: ['Emotional Trigger'],
      compareCoverage: [
        const CompareCoverageItem(
          sourceName: 'Financial Outlook',
          title: 'Climate Pact Tax: The Fiscal Impact of the \$100B Redistribution Agenda',
          bias: 'Right',
          biasScore: 0.85,
          credibilityScore: 0.88,
        ),
        const CompareCoverageItem(
          sourceName: 'Science Wire',
          title: 'Is \$100B Enough? Why the Climate Funding is a Drop in the Ocean',
          bias: 'Left',
          biasScore: 0.75,
          credibilityScore: 0.83,
        ),
      ],
    ),
    NewsArticle(
      id: '3',
      title: 'Infrastructure Boom: New Highway Network Set to Boost Trade',
      snippet: 'The government launches a major logistics corridor linking economic hubs, aiming to reduce domestic transportation costs by 20%.',
      content: 'The Ministry of Road Transport has launched the Golden Logistics Highway project, a state-of-the-art interstate network spanning over 2,500 kilometers. The project promises to connect trade hubs and reduce cargo transit times. Government officials claim the project will yield significant economic benefits and create thousands of jobs. Opponents have pointed to localized land acquisition disputes and expressed concerns about ecological disruption in sensitive forest reserves.',
      sourceName: 'Republic World',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=600&auto=format&fit=crop&q=60',
      bias: 'Right-Center',
      biasScore: 0.64,
      credibilityScore: 0.78,
      category: 'Infrastructure',
      loadedWords: ['boom', 'state-of-the-art', 'promises', 'boost', 'disputes'],
      framing: 'Framed around national development and efficiency achievements. Emphasis is placed heavily on productivity gains, with environmental concerns positioned secondary.',
      sentiment: 'Positive',
      sentimentScore: 0.75,
      sensationalismScore: 0.78,
      neutralRewrite: 'Highway Logistics Network launched to reduce trade transport costs',
      manipulationReasons: ['Clickbait', 'Emotional Trigger', 'Loaded Language'],
      compareCoverage: [
        const CompareCoverageItem(
          sourceName: 'Eco-Justice Collective',
          title: 'Forest Devastation: Golden Corridor Project Bulldozes Vital Habitats',
          bias: 'Left',
          biasScore: 0.82,
          credibilityScore: 0.76,
        ),
        const CompareCoverageItem(
          sourceName: 'Neutral Times',
          title: 'Highway Project Connects Hubs Amid Disputes Over Land Rights',
          bias: 'Center',
          biasScore: 0.08,
          credibilityScore: 0.88,
        ),
      ],
    ),
  ];
}
