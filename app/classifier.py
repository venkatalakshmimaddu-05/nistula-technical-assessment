def classify_query(message: str) -> str:
    msg = message.lower()

    if "available" in msg or "availability" in msg:
        return "pre_sales_availability"
    elif "rate" in msg or "price" in msg or "cost" in msg:
        return "pre_sales_pricing"
    elif "check-in" in msg or "wifi" in msg:
        return "post_sales_checkin"
    elif "early" in msg or "airport" in msg or "transfer" in msg:
        return "special_request"
    elif any(word in msg for word in ["not working", "unhappy", "issue", "problem", "refund"]):
        return "complaint"
    else:
        return "general_enquiry"