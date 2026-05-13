from fastapi import FastAPI, HTTPException
from app.models import MessageInput
from app.utils import normalize_message, calculate_confidence, decide_action
from app.classifier import classify_query
from app.ai_service import get_ai_reply

app = FastAPI()


@app.get("/")
def home():
    return {"message": "Nistula Guest Messaging API is running"}


@app.post("/webhook/message")
def handle_message(data: MessageInput):
    try:
        # Step 1: Normalize
        normalized = normalize_message(data)

        # Step 2: Classify
        query_type = classify_query(data.message)
        normalized["query_type"] = query_type

        # Step 3: AI Response
        drafted_reply = get_ai_reply(normalized)

        # Step 4: Confidence Score
        confidence = calculate_confidence(query_type, data.message)

        # Step 5: Action Decision
        action = decide_action(confidence, query_type)

        return {
            "message_id": normalized["message_id"],
            "query_type": query_type,
            "drafted_reply": drafted_reply,
            "confidence_score": confidence,
            "action": action
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))