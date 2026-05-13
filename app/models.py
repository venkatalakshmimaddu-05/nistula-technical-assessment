from pydantic import BaseModel

class MessageInput(BaseModel):
    source: str
    guest_name: str
    message: str
    timestamp: str
    booking_ref: str
    property_id: str