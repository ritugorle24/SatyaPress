"""
run_all.py
Runs all SatyaPress news scrapers sequentially:
  - NDTV India
  - Republic World India
  - The Hindu India
  - Times of India India
  - Indian Express India

Each scraper saves articles to the Firebase Firestore 'articles' collection.
"""

import logging
import sys
import os

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("RunAll")

# Ensure the scraper directory is importable
scraper_dir = os.path.dirname(os.path.abspath(__file__))
if scraper_dir not in sys.path:
    sys.path.insert(0, scraper_dir)

from ndtv_scraper import scrape_ndtv_india
from republic_scraper import scrape_republic_india
from hindu_scraper import scrape_hindu_india
from toi_scraper import scrape_toi_india
from ie_scraper import scrape_ie_india

SCRAPERS = [
    ("NDTV India",        scrape_ndtv_india),
    ("Republic India",    scrape_republic_india),
    ("The Hindu India",   scrape_hindu_india),
    ("Times of India",    scrape_toi_india),
    ("Indian Express",    scrape_ie_india),
]

def run_all():
    total_articles = []
    for name, scraper_fn in SCRAPERS:
        logger.info(f"\n{'='*50}")
        logger.info(f"Starting scraper: {name}")
        logger.info(f"{'='*50}")
        try:
            articles = scraper_fn()
            logger.info(f"{name}: scraped {len(articles)} articles.")
            total_articles.extend(articles)
        except Exception as e:
            logger.error(f"{name}: scraper failed with error: {e}")

    logger.info(f"\n{'='*50}")
    logger.info(f"All scrapers done. Total articles collected: {len(total_articles)}")
    logger.info(f"{'='*50}")
    return total_articles

if __name__ == "__main__":
    run_all()
