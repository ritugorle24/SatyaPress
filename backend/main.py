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
    
    try:
        docs = db.collection(collection_name).stream()
        results = []
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            results.append(data)
        
        # If collection exists but is empty, we can still return empty array or default to mock for initial UX
        if not results:
            logger.info(f"Collection '{collection_name}' is empty in Firestore. Returning empty list.")
        return results
    except Exception as err:
        logger.error(f"Error fetching collection '{collection_name}' from Firestore: {err}. Falling back to mock data.")
        return fallback_data

# --- Endpoints ---

@app.get("/")
def read_root():
    return {
        "app": "SatyaPress API",
        "status": "Online",
        "firebase_connected": db is not None and not use_mock_data
    }

@app.get("/articles", response_model=List[Dict[str, Any]])
def get_articles():
    """Retrieve all news articles."""
    return get_firestore_collection("articles", MOCK_ARTICLES)

@app.get("/buried-stories", response_model=List[Dict[str, Any]])
def get_buried_stories():
    """Retrieve under-reported/buried news stories detected by the system."""
    return get_firestore_collection("buried_stories", MOCK_BURIED_STORIES)

@app.get("/accountability", response_model=List[Dict[str, Any]])
def get_accountability():
    """Retrieve media accountability records and bias scores."""
    return get_firestore_collection("accountability", MOCK_ACCOUNTABILITY)

@app.get("/compare", response_model=List[Dict[str, Any]])
def get_compare():
    """Retrieve comparison reports between different media coverages on identical topics."""
    return get_firestore_collection("compare", MOCK_COMPARE)

# Entry point for running the server
if __name__ == "__main__":
    import uvicorn
    # Read host and port from environment variables with defaults
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", 8000))
    
    logger.info(f"Starting server on {host}:{port}")
    uvicorn.run("main:app", host=host, port=port, reload=True)
