import os
import sys
import time
import logging
import hashlib
import requests
import xml.etree.ElementTree as ET
from email.utils import parsedate_to_datetime
from datetime import datetime, timezone
from dotenv import load_dotenv

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("TOIScraper")

# Load environment variables from backend/.env
backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "backend"))
load_dotenv(dotenv_path=os.path.join(backend_dir, ".env"))

# Append backend directory to sys.path to import firebase_config
sys.path.append(backend_dir)

try:
    from firebase_config import get_firestore_client
    db = get_firestore_client()
    logger.info("Firebase Firestore client initialized successfully.")
except Exception as e:
    logger.error(f"Could not initialize Firebase Firestore client: {e}")
    db = None


def classify_category(headline: str) -> str:
    import re
    headline_lower = headline.lower()
    tech_keywords = ['tech', 'digital', 'ai', 'cyber', 'internet', 'software']
    global_keywords = ['world', 'global', 'international', 'china', 'pakistan', 'russia']
    infra_keywords = ['road', 'highway', 'bridge', 'infrastructure', 'construction', 'corridor']
    
    if any(kw in headline_lower for kw in tech_keywords):
        return 'Tech'
    if any(kw in headline_lower for kw in global_keywords) or re.search(r'\bUS\b|\bU\.S\.\b', headline):
        return 'Global'
    if any(kw in headline_lower for kw in infra_keywords):
        return 'Infrastructure'
    return 'General'


def scrape_toi_india() -> list:
    """
    Scrapes Times of India India News section using the public RSS feed.
    Extracts: headline, url, source name, timestamp.
    Saves to Firebase Firestore collection 'articles' with a 2-second delay.
    Returns the list of scraped articles.
    """
    url = "https://timesofindia.indiatimes.com/rssfeeds/-2128936835.cms"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }

    logger.info(f"Fetching TOI India RSS feed from: {url}")
    try:
        response = requests.get(url, headers=headers, timeout=15)
        response.raise_for_status()
    except Exception as e:
        logger.error(f"Failed to fetch TOI RSS feed: {e}")
        return []

    try:
        root = ET.fromstring(response.content)
    except Exception as e:
        logger.error(f"Failed to parse RSS XML: {e}")
        return []

    items = root.findall(".//item")
    logger.info(f"Found {len(items)} articles in RSS feed.")

    scraped_articles = []

    for index, item in enumerate(items):
        headline = item.find("title").text if item.find("title") is not None else ""
        link = item.find("link").text if item.find("link") is not None else ""
        pub_date = item.find("pubDate").text if item.find("pubDate") is not None else ""

        # TOI uses ISO 8601 format directly (e.g. 2026-06-20T16:31:48+05:30)
        # Try RFC 2822 first (email.utils), fallback to direct ISO string
        timestamp = pub_date
        if pub_date:
            try:
                dt = parsedate_to_datetime(pub_date)
                timestamp = dt.isoformat()
            except Exception:
                try:
                    # TOI already emits ISO format — keep it as-is
                    datetime.fromisoformat(pub_date)
                    timestamp = pub_date
                except Exception as date_err:
                    logger.warning(f"Could not parse pubDate '{pub_date}': {date_err}")

        headline = headline.strip() if headline else ""
        link = link.strip() if link else ""

        if not headline or not link:
            continue

        article_data = {
            "title": headline,
            "url": link,
            "source": "Times of India",
            "published_at": timestamp,
            "category": classify_category(headline)
        }

        # 2-second delay as requested
        logger.info(f"Processing article {index + 1}/{len(items)}: {headline[:40]}...")
        time.sleep(2)

        # Save to Firebase Firestore if db is initialized
        if db is not None:
            try:
                doc_id = hashlib.md5(link.encode("utf-8")).hexdigest()
                db.collection("articles").document(doc_id).set(article_data)
                logger.info(f"Saved to Firestore: ID {doc_id}")
            except Exception as db_err:
                logger.error(f"Failed to save article to Firestore: {db_err}")
        else:
            logger.warning("Firestore DB client not available. Skipping save.")

        scraped_articles.append(article_data)

    logger.info(f"Scrape completed. Successfully processed {len(scraped_articles)} articles.")
    return scraped_articles


if __name__ == "__main__":
    articles = scrape_toi_india()
    print(f"\nScraped {len(articles)} articles.")
    if articles:
        print("Sample Article:", articles[0])
