import os
import logging
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, firestore

logger = logging.getLogger("FirebaseConfig")

# Load environment variables
load_dotenv()

_db = None

def get_firestore_client():
    """
    Initializes the Firebase Admin SDK using the credentials path 
    specified in the environment variable `FIREBASE_KEY_PATH`.
    Returns the Firestore client.
    """
    global _db
    if _db is not None:
        return _db

    # Check if Firebase is already initialized
    if not firebase_admin._apps:
        key_path = os.getenv("FIREBASE_KEY_PATH", "firebase-key.json")
        if not os.path.isabs(key_path) and not os.path.exists(key_path):
            potential_path = os.path.abspath(os.path.join(os.path.dirname(__file__), key_path))
            if os.path.exists(potential_path):
                key_path = potential_path
        
        logger.info(f"Initializing Firebase Admin SDK. Credentials path: {key_path}")

        if os.path.exists(key_path):
            try:
                cred = credentials.Certificate(key_path)
                firebase_admin.initialize_app(cred)
                logger.info("Firebase Admin SDK initialized successfully with certificate.")
            except Exception as e:
                logger.error(f"Error initializing Firebase with credentials file: {e}")
                raise e
        else:
            logger.warning(f"Firebase credentials file not found at '{key_path}'. Trying Application Default Credentials...")
            try:
                firebase_admin.initialize_app()
                logger.info("Firebase Admin SDK initialized successfully with default credentials.")
            except Exception as default_err:
                logger.error(f"Failed to initialize Firebase with Default Credentials: {default_err}")
                raise default_err
    
    _db = firestore.client()
    return _db
