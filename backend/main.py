import os
import logging
from typing import List, Dict, Any
# pyrefly: ignore [missing-import]
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, firestore

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger("SatyaPressBackend")

# Load environment variables
load_dotenv()

# Initialize FastAPI App
app = FastAPI(
    title="SatyaPress API",
    description="India's AI-Powered Truth & Accountability News Platform Backend",
    version="1.0.0"
)

# Enable CORS for Flutter and general frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Firebase Firestore Initialization
db = None
use_mock_data = False

try:
    from firebase_config import get_firestore_client
    db = get_firestore_client()
    logger.info("Firestore client retrieved successfully via firebase_config.")
except Exception as e:
    logger.error(f"Failed to initialize Firestore via firebase_config: {e}. Running in Mock Fallback mode.")
    use_mock_data = True

# --- Realistic Mock Data for Fallback/Development Mode ---
MOCK_ARTICLES = [
    {
        "id": "art_1",
        "title": "New RTI Reveal Shows Infrastructure Budgets Underutilized",
        "content": "An analysis of public records indicates that key urban planning projects in metro cities utilized less than 45% of allocated funds over the last fiscal year.",
        "author": "SatyaPress Investigative Desk",
        "source": "RTI India Portal",
        "published_at": "2026-06-20T08:00:00Z",
        "category": "Governance",
        "url": "https://satyapress.in/articles/rti-reveal-infrastructure-budget",
        "sentiment": "neutral",
        "bias_rating": "unbiased"
    },
    {
        "id": "art_2",
        "title": "Air Quality Index in North India Worsens Unseasonably",
        "content": "Satellite imagery and local monitoring stations detect early spikes in PM2.5 levels, raising health concerns across several northern states.",
        "author": "Priya Sharma",
        "source": "SatyaPress Environment",
        "published_at": "2026-06-19T14:30:00Z",
        "category": "Environment",
        "url": "https://satyapress.in/articles/aqi-north-india-unseasonable",
        "sentiment": "negative",
        "bias_rating": "unbiased"
    }
]

MOCK_BURIED_STORIES = [
    {
        "id": "buried_1",
        "title": "Severe Water Crisis in Rural Maharashtra Districts Goes Unreported",
        "summary": "While major headlines focus on celebrity news, 14 villages in Marathwada have had no municipal water access for 25 consecutive days.",
        "source": "Local Grassroots Reports",
        "why_buried": "Mainstream news prioritized prime-time political debates and entertainment coverage over local rural issues.",
        "impact_score": 8.7,
        "categories": ["Environment", "Human Rights", "Governance"],
        "date_detected": "2026-06-20",
        "url_references": []
    },
    {
        "id": "buried_2",
        "title": "Small-Scale Artisanal Fishers Protest Off-Shore Drilling Approvals",
        "summary": "Local fisher communities on the southern coast stage peaceful demonstrations against rapid licensing of off-shore extraction sites which threaten marine ecosystems.",
        "source": "Coastal Union Dispatch",
        "why_buried": "Industrial lobby pressure and high-interest national security news kept this protest out of mainstream media feeds.",
        "impact_score": 7.5,
        "categories": ["Economy", "Environment"],
        "date_detected": "2026-06-18",
        "url_references": []
    }
]

MOCK_ACCOUNTABILITY = [
    {
        "id": "acc_1",
        "publisher": "National Daily Times",
        "bias_score": 0.28,
        "factual_accuracy": "High",
        "retraction_count": 2,
        "sensationalism_index": "Low",
        "main_violations": [],
        "last_updated": "2026-06-20T00:00:00Z"
    },
    {
        "id": "acc_2",
        "publisher": "Republic Broadcast Network",
        "bias_score": 0.72,
        "factual_accuracy": "Mixed",
        "retraction_count": 14,
        "sensationalism_index": "High",
        "main_violations": ["Sensationalized headlines", "Unverified social media reporting"],
        "last_updated": "2026-06-20T00:00:00Z"
    }
]

MOCK_COMPARE = [
    {
        "id": "comp_1",
        "topic": "New Agricultural Policy Bill Debate",
        "source_a_headline": "Historic Farm Bill Sets to Double Income, Free Farmers from Middlemen",
        "source_b_headline": "Farmers Protest Hasty Bill Passage, Express Fear of Corporate Control",
        "source_a_slant": "Highly Favorable / Pro-Government",
        "source_b_slant": "Critical / Pro-Protester",
        "key_differences": "Source A focuses entirely on market deregulation benefits and official speeches. Source B highlights farmer protests, lack of parliamentary consensus, and minimum support price (MSP) anxieties.",
        "consensus_summary": "The bill relaxes restrictions on agricultural trading, but faces significant pushback over the lack of statutory MSP guarantees.",
        "date_analyzed": "2026-06-20"
    }
]

# --- Helper Functions ---
def get_firestore_collection(collection_name: str, fallback_data: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Helper to stream documents from Firestore or fall back to mock data if Firestore is unavailable."""
    if use_mock_data or db is None:
        logger.info(f"Serving fallback mock data for collection: '{collection_name}'")
        return fallback_data
    
    docs = db.collection(collection_name).stream()
    results = []
    for doc in docs:
        data = doc.to_dict()
        data["id"] = doc.id
        results.append(data)
    
    return results

# --- Endpoints ---

@app.get("/")
def read_root():
    return {
        "app": "SatyaPress API",
        "status": "Online",
        "firebase_connected": db is not None and not use_mock_data
    }

@app.get("/articles")
def get_articles(source: str = None):
    """Retrieve all news articles."""
    try:
        articles = get_firestore_collection("articles", MOCK_ARTICLES)
        logger.info(f"Checked {len(articles)} articles in /articles")
        
        if source:
            articles = [a for a in articles if a.get("source", "").lower() == source.lower()]
            
        logger.info(f"Returned {len(articles)} results in /articles")
        return articles
    except Exception as e:
        logger.error(f"Error in /articles: {e}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@app.get("/buried-stories")
def get_buried_stories():
    """Retrieve under-reported/buried news stories detected by the system."""
    try:
        buried = get_firestore_collection("buried_stories", [])
        if buried:
            logger.info(f"Returned {len(buried)} from buried_stories collection")
            return buried
            
        logger.info("buried_stories collection empty, generating dynamically from articles...")
        articles = get_firestore_collection("articles", [])
        logger.info(f"Checked {len(articles)} articles for dynamic buried stories")
        
        if not articles:
            return MOCK_BURIED_STORIES
            
        results = []
        articles_by_src = {}
        for a in articles:
            src = a.get("source", "Unknown")
            if src not in articles_by_src:
                articles_by_src[src] = []
            articles_by_src[src].append(a)
            
        for a in articles:
            title = a.get("title", "").lower()
            words = set(w for w in title.split() if len(w) > 4)
            src = a.get("source", "Unknown")
            
            covered_by_others = False
            for other_src, other_articles in articles_by_src.items():
                if other_src == src:
                    continue
                for oa in other_articles:
                    other_title = oa.get("title", "").lower()
                    other_words = set(w for w in other_title.split() if len(w) > 4)
                    if len(words.intersection(other_words)) >= 2:
                        covered_by_others = True
                        break
                if covered_by_others:
                    break
                    
            if not covered_by_others:
                results.append({
                    "topic": a.get("title", ""),
                    "headline": a.get("title", ""),
                    "source": src,
                    "url": a.get("url", ""),
                    "reason": "Covered by fewer than 2 sources",
                    "timestamp": a.get("published_at", "")
                })
                
        results = results[:15]
        logger.info(f"Dynamically generated and returned {len(results)} buried stories")
        return results
        
    except Exception as e:
        logger.error(f"Error in /buried-stories: {e}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@app.get("/accountability")
def get_accountability():
    """Retrieve media accountability records and bias scores."""
    try:
        acc = get_firestore_collection("accountability", [])
        if acc:
            logger.info(f"Returned {len(acc)} from accountability collection")
            return acc
            
        logger.info("accountability collection empty, generating dynamically from articles...")
        articles = get_firestore_collection("articles", [])
        logger.info(f"Checked {len(articles)} articles for accountability keywords")
        
        if not articles:
            return MOCK_ACCOUNTABILITY
            
        keywords = ["scam", "corruption", "court", "arrest", "probe", "investigation", "police", "government", "minister", "complaint", "case", "fraud", "expose", "allegation"]
        
        results = []
        for a in articles:
            title = a.get("title", "").lower()
            matched_kws = [kw for kw in keywords if kw in title]
            if matched_kws:
                results.append({
                    "headline": a.get("title", ""),
                    "source": a.get("source", "Unknown"),
                    "url": a.get("url", ""),
                    "timestamp": a.get("published_at", ""),
                    "reason": f"Matches accountability keywords: {', '.join(matched_kws)}"
                })
                
        results = results[:20]
        logger.info(f"Dynamically generated and returned {len(results)} accountability articles")
        return results
        
    except Exception as e:
        logger.error(f"Error in /accountability: {e}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@app.get("/compare")
def get_compare(topic: str = None):
    """Retrieve comparison reports between different media coverages on identical topics."""
    try:
        if not topic:
            return get_firestore_collection("compare", MOCK_COMPARE)
            
        articles = get_firestore_collection("articles", [])
        logger.info(f"Checked {len(articles)} articles in /compare for topic '{topic}'")
        
        topic_lower = topic.lower()
        matched = []
        
        for a in articles:
            title = a.get("title", "").lower()
            url = a.get("url", "").lower()
            summary = a.get("summary", "").lower()
            content = a.get("content", "").lower()
            
            # Exact Match
            if topic_lower in title or topic_lower in url or topic_lower in summary or topic_lower in content:
                matched.append(a)
                continue
                
            # Partial keyword match
            topic_words = [w for w in topic_lower.split() if len(w) > 3]
            for w in topic_words:
                if w in title or w in url or w in summary or w in content:
                    matched.append(a)
                    break
        
        # Group by source
        grouped = {}
        for m in matched:
            src = m.get("source", "Unknown")
            if src not in grouped:
                grouped[src] = []
            
            grouped[src].append({
                "id": m.get("id"),
                "headline": m.get("title", ""),
                "title": m.get("title", ""),
                "source": src,
                "url": m.get("url", ""),
                "timestamp": m.get("published_at", ""),
                "bias_label": m.get("bias_label", "UNKNOWN"),
                "bias_score": m.get("bias_score", 0.0)
            })
            
        logger.info(f"Returned {len(matched)} matched articles across {len(grouped)} sources in /compare")
        return [{"topic": topic, "sources": grouped, "total_matches": len(matched)}]
        
    except Exception as e:
        logger.error(f"Error in /compare: {e}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

# Entry point for running the server
if __name__ == "__main__":
    import uvicorn
    # Read host and port from environment variables with defaults
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", 8000))
    
    logger.info(f"Starting server on {host}:{port}")
    uvicorn.run("main:app", host=host, port=port, reload=True)
