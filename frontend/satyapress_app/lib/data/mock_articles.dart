// lib/data/mock_articles.dart
// Mock article data for SatyaPress UI development and testing.
// Contains 9 articles across 3 sources (NDTV, Republic, The Hindu)
// covering the same 3 topics to enable bias comparison.

const List<Map<String, dynamic>> mockArticles = [
  // ── NDTV (LEFT bias, credibility ~72) ──────────────────────────────────────

  {
    "headline": "Labour Laws Rolled Back: Workers Left Vulnerable as Corporates Gain Ground",
    "source": "NDTV",
    "bias": "LEFT",
    "credibility": 72,
    "loaded_words": ["rolled back", "vulnerable", "corporates"],
    "summary": "New amendments weaken worker protections and shift power to employers, critics warn.",
  },
  {
    "headline": "India-Pakistan Tensions Escalate: Diplomatic Channels Remain Frozen",
    "source": "NDTV",
    "bias": "LEFT",
    "credibility": 72,
    "loaded_words": ["escalate", "frozen", "tensions"],
    "summary": "Analysts say the breakdown in dialogue risks destabilising an already fragile border.",
  },
  {
    "headline": "Farmer Protests Return as Government Ignores Minimum Support Price Demand",
    "source": "NDTV",
    "bias": "LEFT",
    "credibility": 72,
    "loaded_words": ["ignores", "protests", "demand"],
    "summary": "Tens of thousands of farmers march again after months of failed negotiations over MSP.",
  },

  // ── Republic World (RIGHT bias, credibility ~58) ────────────────────────────

  {
    "headline": "Bold Labour Reforms Unleash Economic Growth and Job Creation",
    "source": "Republic",
    "bias": "RIGHT",
    "credibility": 58,
    "loaded_words": ["bold", "unleash", "growth"],
    "summary": "Government's decisive labour code overhaul is praised by industry as a historic move.",
  },
  {
    "headline": "India Stands Firm Against Pakistan's Provocations — A Strong Nation Speaks",
    "source": "Republic",
    "bias": "RIGHT",
    "credibility": 58,
    "loaded_words": ["provocations", "firm", "strong"],
    "summary": "Experts back India's tough diplomatic stance as Pakistan faces international isolation.",
  },
  {
    "headline": "Anti-National Elements Behind Farmer Protests, Says Intelligence Report",
    "source": "Republic",
    "bias": "RIGHT",
    "credibility": 58,
    "loaded_words": ["anti-national", "exposes", "infiltrated"],
    "summary": "Security officials allege foreign interference is fuelling unrest among farming communities.",
  },

  // ── The Hindu (CENTER bias, credibility ~88) ────────────────────────────────

  {
    "headline": "Labour Code Amendments: A Detailed Look at What Changes for Workers and Employers",
    "source": "The Hindu",
    "bias": "CENTER",
    "credibility": 88,
    "loaded_words": [],
    "summary": "A factual breakdown of the four new labour codes and their practical implications.",
  },
  {
    "headline": "India-Pakistan Relations: Examining the History and the Path Ahead",
    "source": "The Hindu",
    "bias": "CENTER",
    "credibility": 88,
    "loaded_words": [],
    "summary": "A balanced analysis of bilateral ties, covering security concerns and diplomatic options.",
  },
  {
    "headline": "Farmer Protests: Demands, Government Response, and What Experts Say",
    "source": "The Hindu",
    "bias": "CENTER",
    "credibility": 88,
    "loaded_words": [],
    "summary": "A report presenting farmer union demands alongside the government's stated position.",
  },
];
