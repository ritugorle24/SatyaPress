import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("GapEngine")

def calculate_gap_score(reddit_mentions: int, sources_covered: int) -> float:
    """
    Calculates a gap score between 0-100 based on Reddit mentions and mainstream source coverage.
    Higher reddit mentions + lower sources covered = higher gap score.
    
    Args:
        reddit_mentions (int): Number of mentions on Reddit/Social Media.
        sources_covered (int): Number of mainstream sources covering the story (out of 5).
        
    Returns:
        float: Gap score capped at 100.
               Formula: gap_score = (reddit_mentions/1000 * 0.6) + ((5-sources_covered)/5 * 100 * 0.4)
    """
    # Ensure sources_covered is sensibly bound between 0 and 5
    sources_covered = max(0, min(5, sources_covered))
    
    # The formula provided:
    social_factor = (reddit_mentions / 1000.0) * 0.6
    source_factor = ((5 - sources_covered) / 5.0) * 100.0 * 0.4
    
    gap_score = social_factor + source_factor
    
    # Cap at 100
    gap_score = min(100.0, gap_score)
    
    return round(gap_score, 2)

if __name__ == "__main__":
    # Test cases to verify the formula
    test_cases = [
        (100000, 0), # High social talk, 0 mainstream coverage -> Expect 100
        (100000, 5), # High social talk, fully covered by mainstream -> Expect 60
        (50000,  2), # Moderate social talk, 2 mainstream sources -> Expect 30 + 24 = 54
        (1000,   1), # Low social talk, 1 mainstream source -> Expect 0.6 + 32 = 32.6
        (0,      5), # No social talk, fully covered -> Expect 0
    ]
    
    print("--- Coverage Gap Engine Test ---")
    for reddit, sources in test_cases:
        score = calculate_gap_score(reddit, sources)
        print(f"Reddit Mentions: {reddit:6d} | Sources Covered: {sources}/5 | Gap Score: {score}")
