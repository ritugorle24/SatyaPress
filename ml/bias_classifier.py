import logging

# Use a try block in case transformers isn't installed yet
try:
    from transformers import pipeline
    TRANSFORMERS_AVAILABLE = True
except ImportError:
    TRANSFORMERS_AVAILABLE = False

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("BiasClassifier")

bias_pipeline = None

def _load_pipeline():
    global bias_pipeline
    if bias_pipeline is not None:
        return
        
    if not TRANSFORMERS_AVAILABLE:
        logger.error("transformers library is not installed. Please install it using 'pip install transformers torch'.")
        return
        
    # Load the model globally so it doesn't reload on every function call
    try:
        logger.info("Loading politicalBiasBERT model (this may take a moment)...")
        bias_pipeline = pipeline("text-classification", model="bucketresearch/politicalBiasBERT")
        logger.info("Model loaded successfully.")
    except Exception as e:
        logger.error(f"Error loading politicalBiasBERT model: {e}")
        bias_pipeline = None

# Eagerly attempt to load if transformers is available
if TRANSFORMERS_AVAILABLE:
    _load_pipeline()

def classify_bias(text: str) -> dict:
    """
    Takes article text as input and returns a dictionary with bias label 
    (LEFT/CENTER/RIGHT) and confidence score.
    """
    if bias_pipeline is None:
        _load_pipeline()
        
    if not bias_pipeline:
        return {"label": "UNKNOWN", "confidence": 0.0}
    
    # Truncate text if it's too long for BERT (max 512 tokens)
    # Using simple character limit (approx 2000 chars) as a safe approximation for tokens
    truncated_text = text[:2000] 
    
    try:
        results = bias_pipeline(truncated_text)
        
        if results and len(results) > 0:
            result = results[0]
            raw_label = result['label'].upper()
            
            # Map potential label outputs to standard LEFT/CENTER/RIGHT
            if 'LEFT' in raw_label:
                mapped_label = 'LEFT'
            elif 'RIGHT' in raw_label:
                mapped_label = 'RIGHT'
            else:
                mapped_label = 'CENTER'
                
            return {
                "label": mapped_label,
                "confidence": round(result['score'], 4)
            }
    except Exception as e:
        logger.error(f"Classification error: {e}")
        
    return {"label": "UNKNOWN", "confidence": 0.0}

def get_sensationalism_score(headline: str) -> int:
    """
    Counts loaded words in headline and returns a sensationalism score 0-100.
    """
    loaded_words = {"fears", "shocking", "explosive", "bold", "exposes", "reveals", "massive"}
    
    # Simple word tokenization and lowercase
    headline_lower = headline.lower()
    
    # Remove basic punctuation to get clean words
    for p in ".,!?'\":;()[]{}":
        headline_lower = headline_lower.replace(p, " ")
        
    words = headline_lower.split()
    
    # Count occurrences of loaded words
    match_count = sum(1 for word in words if word in loaded_words)
    
    # Calculate score 0-100 (cap at 100)
    # Give 30 points per loaded word
    score = min(100, match_count * 30)
    
    return score

if __name__ == "__main__":
    # Test cases
    test_headline = "Massive shocking reveals expose explosive fears in bold new plan!"
    print(f"Headline: '{test_headline}'")
    print(f"Sensationalism Score: {get_sensationalism_score(test_headline)}/100")
    
    test_text = "The government announced a new tax policy today that will affect small businesses."
    print(f"\nClassifying text: '{test_text}'")
    print(classify_bias(test_text))
