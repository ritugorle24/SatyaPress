import os
import sys
import time
import logging
import hashlib
import requests
import xml.etree.ElementTree as ET
from email.utils import parsedate_to_datetime
from dotenv import load_dotenv

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("HinduScraper")

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


def scrape_hindu_india() -> list:
    """
    Scrapes The Hindu National News section using the public RSS feed.
    Extracts: headline, url, source name, timestamp.
    Saves to Firebase Firestore collection 'articles' with a 2-second delay.
    Returns the list of scraped articles.
    """
    url = "https://www.thehindu.com/news/national/feeder/default.rss"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }

    logger.info(f"Fetching The Hindu India RSS feed from: {url}")
    try:
        response = requests.get(url, headers=headers, timeout=15)
        response.raise_for_status()
    except Exception as e:
        logger.error(f"Failed to fetch The Hindu RSS feed: {e}")
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

        # Normalize timestamp to ISO format
        timestamp = pub_date
        if pub_date:
            try:
                dt = parsedate_to_datetime(pub_date)
                timestamp = dt.isoformat()
            except Exception as date_err:
                logger.warning(f"Could not parse pubDate '{pub_date}': {date_err}")

        headline = headline.strip() if headline else ""
        link = link.strip() if link else ""

        if not headline or not link:
            continue

        article_data = {
            "title": headline,
            "url": link,
            "source": "The Hindu",
            "published_at": timestamp
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

        if len(scraped_articles) >= 20:
            logger.info("Reached target batch limit of 20 articles. Stopping.")
            break

    logger.info(f"Scrape completed. Successfully processed {len(scraped_articles)} articles.")
    return scraped_articles


if __name__ == "__main__":
    articles = scrape_hindu_india()
    print(f"\nScraped {len(articles)} articles.")
    if articles:
        print("Sample Article:", articles[0])
