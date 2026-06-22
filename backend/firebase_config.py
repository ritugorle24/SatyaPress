import os
import logging
import json
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, firestore

logger = logging.getLogger("FirebaseConfig")

# Load environment variables
load_dotenv()

_db = None

def get_firestore_client():
    """
    Initializes the Firebase Admin SDK using the credentials JSON 
    specified in the environment variable `FIREBASE_CREDENTIALS_JSON`.
    Returns the Firestore client.
    """
    global _db
    if _db is not None:
        return _db

    # Check if Firebase is already initialized
    if not firebase_admin._apps:
        credentials_json = os.getenv("FIREBASE_CREDENTIALS_JSON")
        if credentials_json:
            try:
                logger.info("Initializing Firebase Admin SDK using FIREBASE_CREDENTIALS_JSON environment variable.")
                cred_dict = json.loads(credentials_json)
                cred = credentials.Certificate(cred_dict)
                firebase_admin.initialize_app(cred)
                logger.info("Firebase Admin SDK initialized successfully with certificate dict.")
            except Exception as e:
                logger.error(f"Error initializing Firebase with credentials JSON string: {e}")
                raise e
        else:
            logger.warning("FIREBASE_CREDENTIALS_JSON environment variable not found. Trying Application Default Credentials...")
            try:
                firebase_admin.initialize_app()
                logger.info("Firebase Admin SDK initialized successfully with default credentials.")
            except Exception as default_err:
                logger.error(f"Failed to initialize Firebase with Default Credentials: {default_err}")
                raise default_err
    
    _db = firestore.client()
    return _db
