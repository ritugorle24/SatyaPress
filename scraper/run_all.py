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
import hashlib

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

# Add backend dir to import firebase_config
backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "backend"))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

try:
    from firebase_config import get_firestore_client
    db = get_firestore_client()
except Exception as e:
    logger.error(f"Could not load Firebase client: {e}")
    db = None

# Add ml dir to import bias_classifier
ml_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "ml"))
if ml_dir not in sys.path:
    sys.path.insert(0, ml_dir)

from bias_classifier import classify_bias, get_sensationalism_score

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
            
            # Post-processing: Apply ML Models and update Firestore
            if db and articles:
                logger.info(f"Applying AI models to {len(articles)} articles from {name}...")
                for idx, article in enumerate(articles):
                    headline = article.get("title", "")
                    summary = article.get("summary", "") # Typically empty from RSS, but we include it if present
                    url = article.get("url", "")
                    
                    if not headline or not url:
                        continue
                        
                    # Calculate Firestore document ID via MD5 hash (as used in the scrapers)
                    doc_id = hashlib.md5(url.encode("utf-8")).hexdigest()
                    
                    # Combine headline and summary for BERT
                    full_text = f"{headline} {summary}".strip()
                    
                    # ML inferences
                    bias_result = classify_bias(full_text)
                    sens_score = get_sensationalism_score(headline)
                    
                    # Extract values
                    label = bias_result.get("label", "UNKNOWN")
                    confidence = bias_result.get("confidence", 0.0)
                    
                    # Update Firestore document with new ML fields
                    try:
                        db.collection("articles").document(doc_id).update({
                            "bias_label": label,
                            "bias_score": confidence,
                            "bias_confidence": confidence,
                            "sensationalism_score": sens_score
                        })
                    except Exception as db_err:
                        # Depending on the timing, it's possible update() fails if the document isn't fully committed yet, 
                        # but since the scraper runs synchronously beforehand, it should exist.
                        logger.error(f"Failed to update article {doc_id} with ML data: {db_err}")
                        
                logger.info(f"Finished applying AI models for {name}.")
            
            total_articles.extend(articles)
        except Exception as e:
            logger.error(f"{name}: scraper failed with error: {e}")

    logger.info(f"\n{'='*50}")
    logger.info(f"All scrapers done. Total articles collected & analyzed: {len(total_articles)}")
    logger.info(f"{'='*50}")
    return total_articles

if __name__ == "__main__":
    run_all()
