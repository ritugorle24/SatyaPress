import os
import logging
from dotenv import load_dotenv

from google import genai
from google.genai import types

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("GeminiSummary")

# Load environment variables
backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "backend"))
load_dotenv(dotenv_path=os.path.join(backend_dir, ".env"))

def generate_why_it_matters(topic: str, reddit_mentions: int, sources_covered: int) -> str:
    """
    Sends a prompt to Gemini asking for a 2-3 line neutral explanation of why
    this buried story matters to the average Indian citizen.

    Args:
        topic (str): The subject of the buried story.
        reddit_mentions (int): Number of social media mentions.
        sources_covered (int): Number of mainstream sources covering it (out of 5).

    Returns:
        str: A 2-3 line summary.
    """
    fallback_summary = (
        f"This topic '{topic}' is gaining traction online ({reddit_mentions:,} mentions) "
        f"but is covered by only {sources_covered}/5 mainstream sources, suggesting it may be "
        f"underreported relative to its public significance."
    )

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        logger.error("GEMINI_API_KEY not found in backend/.env. Using fallback summary.")
        return fallback_summary

    try:
        client = genai.Client(api_key=api_key)

        prompt = f"""You are an unbiased news analyst for 'SatyaPress', an Indian media accountability platform.

Topic: {topic}
Social Media Mentions: {reddit_mentions:,}
Mainstream News Sources Covering This: {sources_covered} out of 5

This topic has significant public interest online but limited mainstream media coverage.
Write a 2-3 line, strictly neutral, objective explanation of why this topic matters to the average Indian citizen.
Do not express any political bias. Focus only on facts and potential public impact.
Keep it concise and accessible.

Explanation:"""

        logger.info(f"Generating 'Why it matters' for: {topic[:50]}...")

        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt,
            config=types.GenerateContentConfig(
                temperature=0.3,
                max_output_tokens=150
            )
        )

        return response.text.strip()

    except Exception as e:
        logger.error(f"Gemini API call failed: {e}")
        return fallback_summary


if __name__ == "__main__":
    test_topic = "Rising local property taxes affecting small shop owners in Tier-2 cities"
    print("--- Gemini Summary Test ---")
    print(f"Topic: {test_topic}")
    summary = generate_why_it_matters(test_topic, 45000, 1)
    print(f"\nWhy it matters:\n{summary}")
