import uuid

def normalize_message(data):
    return {
        "message_id": str(uuid.uuid4()),
        "source": data.source,
        "guest_name": data.guest_name,
        "message_text": data.message,
        "timestamp": data.timestamp,
        "booking_ref": data.booking_ref,
        "property_id": data.property_id,
        "query_type": None
    }


def calculate_confidence(query_type: str, message: str) -> float:
    message_length = len(message)

    if query_type == "complaint":
        return 0.4
    elif message_length < 20:
        return 0.65
    elif query_type in ["pre_sales_availability", "pre_sales_pricing"]:
        return 0.9
    else:
        return 0.8


def decide_action(confidence: float, query_type: str) -> str:
    if query_type == "complaint":
        return "escalate"
    elif confidence >= 0.85:
        return "auto_send"
    elif 0.6 <= confidence < 0.85:
        return "agent_review"
    else:
        return "escalate"