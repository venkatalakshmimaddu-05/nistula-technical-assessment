-- Enable UUID support
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--------------------------------------------------
-- 1. GUESTS (Unified across all channels)
--------------------------------------------------
CREATE TABLE guests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- A guest may come from multiple platforms (WhatsApp, Airbnb, etc.)
CREATE TABLE guest_identities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guest_id UUID REFERENCES guests(id) ON DELETE CASCADE,
    source TEXT NOT NULL, -- whatsapp, airbnb, etc.
    external_user_id TEXT, -- platform-specific ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 2. PROPERTIES
--------------------------------------------------
CREATE TABLE properties (
    id TEXT PRIMARY KEY, -- e.g. villa-b1
    name TEXT,
    location TEXT,
    max_guests INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 3. RESERVATIONS
--------------------------------------------------
CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_ref TEXT UNIQUE,
    guest_id UUID REFERENCES guests(id),
    property_id TEXT REFERENCES properties(id),
    check_in DATE,
    check_out DATE,
    status TEXT, -- confirmed, cancelled, completed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 4. CONVERSATIONS (Thread of messages)
--------------------------------------------------
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guest_id UUID REFERENCES guests(id),
    reservation_id UUID REFERENCES reservations(id),
    property_id TEXT REFERENCES properties(id),
    source TEXT, -- primary source of conversation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 5. MESSAGES (CORE TABLE)
--------------------------------------------------
CREATE TABLE messages (
    id UUID PRIMARY KEY,
    conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,

    source TEXT NOT NULL, -- whatsapp, airbnb, etc.
    message_text TEXT NOT NULL,
    message_type TEXT DEFAULT 'inbound', -- inbound / outbound

    query_type TEXT, -- classification
    ai_drafted BOOLEAN DEFAULT FALSE,
    ai_edited BOOLEAN DEFAULT FALSE,
    auto_sent BOOLEAN DEFAULT FALSE,

    confidence_score FLOAT,
    action TEXT, -- auto_send / agent_review / escalate

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 6. AI RESPONSES (Separation for audit/debugging)
--------------------------------------------------
CREATE TABLE ai_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id UUID REFERENCES messages(id) ON DELETE CASCADE,

    prompt TEXT,
    response TEXT,
    model_used TEXT,
    latency_ms INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 7. AGENT ACTIONS (Human intervention tracking)
--------------------------------------------------
CREATE TABLE agent_actions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id UUID REFERENCES messages(id),

    agent_name TEXT,
    action_type TEXT, -- edited, approved, escalated
    notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 8. SYSTEM EVENTS (for automation & alerts)
--------------------------------------------------
CREATE TABLE system_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    event_type TEXT, -- complaint_detected, escalation_triggered
    reference_id UUID, -- could be message_id or conversation_id
    metadata JSONB,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- INDEXES (IMPORTANT FOR PERFORMANCE)
--------------------------------------------------
CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_query_type ON messages(query_type);
CREATE INDEX idx_messages_confidence ON messages(confidence_score);
CREATE INDEX idx_reservations_guest ON reservations(guest_id);
CREATE INDEX idx_conversations_guest ON conversations(guest_id);