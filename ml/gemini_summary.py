import os
import logging
from dotenv import load_dotenv

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("GeminiSummary")

# Load environment variables
backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "backend"))
load_dotenv(dotenv_path=os.path.join(backend_dir, ".env"))

try:
    from langchain_google_genai import ChatGoogleGenerativeAI
    from langchain.prompts import PromptTemplate
    LANGCHAIN_AVAILABLE = True
except ImportError:
    LANGCHAIN_AVAILABLE = False

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
    if not LANGCHAIN_AVAILABLE:
        logger.error("LangChain packages not installed. Please install 'langchain' and 'langchain-google-genai'.")
        return "Summary generation unavailable (missing dependencies)."
        
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        logger.error("GEMINI_API_KEY not found in backend/.env file.")
        return "Summary generation unavailable (missing API key)."

    try:
        # Initialize Gemini LLM
        # Using gemini-1.5-flash as it is fast and excellent for summarization
        llm = ChatGoogleGenerativeAI(
            model="gemini-1.5-flash",
            google_api_key=api_key,
            temperature=0.3  # Low temperature for more neutral, factual tone
        )
        
        # Create prompt template
        template = """
        You are an unbiased news analyst for 'SatyaPress'.
        
        Topic: {topic}
        Social Media Mentions: {reddit_mentions}
        Mainstream News Sources Covering This: {sources_covered} out of 5
        
        This topic has significant public interest on social media but is relatively buried by mainstream media.
        Write a 2-3 line, strictly neutral, objective explanation of why this topic matters to the average Indian citizen.
        Do not express any political bias. Focus only on the facts and the potential public impact.
        
        Explanation:
        """
        
        prompt = PromptTemplate(
            input_variables=["topic", "reddit_mentions", "sources_covered"],
            template=template
        )
        
        # Create simple chain
        chain = prompt | llm
        
        # Run inference
        logger.info(f"Generating 'Why it matters' for topic: {topic[:30]}...")
        response = chain.invoke({
            "topic": topic,
            "reddit_mentions": reddit_mentions,
            "sources_covered": sources_covered
        })
        
        return response.content.strip()
        
    except Exception as e:
        logger.error(f"Failed to generate summary with Gemini: {e}")
        return "Summary generation failed."

if __name__ == "__main__":
    # Test case (requires GEMINI_API_KEY in backend/.env)
    test_topic = "Rising local property taxes affecting small shop owners in Tier-2 cities"
    print("--- Gemini Summary Test ---")
    print(f"Topic: {test_topic}")
    summary = generate_why_it_matters(test_topic, 45000, 1)
    print(f"\nWhy it matters:\n{summary}")
