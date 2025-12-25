-- Analytics Database Schema for Supabase
-- Call Center Agent Metrics System

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-----------------------------------------------------------
-- CORE TABLES
-----------------------------------------------------------

-- Contacts (customers/patients)
CREATE TABLE contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id TEXT UNIQUE,              -- GHL contact ID
    channel TEXT NOT NULL,                 -- 'instagram', 'facebook', 'sms'
    first_seen_at TIMESTAMPTZ DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ DEFAULT NOW(),
    total_conversations INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}'
);

-- Conversations
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contact_id UUID REFERENCES contacts(id),
    channel TEXT NOT NULL,
    started_at TIMESTAMPTZ DEFAULT NOW(),
    ended_at TIMESTAMPTZ,
    status TEXT DEFAULT 'active',          -- 'active', 'resolved', 'handed_off'
    resolution_type TEXT,                  -- 'auto', 'handoff', 'timeout', 'appointment'
    message_count INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    total_cost DECIMAL(10,6) DEFAULT 0,
    first_response_time_ms INTEGER,
    metadata JSONB DEFAULT '{}'
);

-- Messages
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
    role TEXT NOT NULL,                    -- 'user', 'assistant', 'system'
    content TEXT,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    tokens_used INTEGER,
    generation_time_ms INTEGER,            -- Time to generate (assistant only)
    sentiment_score DECIMAL(3,2),          -- -1.00 to 1.00
    metadata JSONB DEFAULT '{}'
);

-- Hand-offs
CREATE TABLE handoffs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID REFERENCES conversations(id),
    reason TEXT,                           -- 'user_request', 'complexity', 'error', etc.
    triggered_at TIMESTAMPTZ DEFAULT NOW(),
    slack_message_id TEXT,
    resolved_by TEXT,                      -- Human agent name/ID
    resolved_at TIMESTAMPTZ,
    notes TEXT
);

-- Appointments
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID REFERENCES conversations(id),
    ghl_appointment_id TEXT UNIQUE,
    contact_id UUID REFERENCES contacts(id),
    booked_at TIMESTAMPTZ DEFAULT NOW(),
    appointment_datetime TIMESTAMPTZ,
    status TEXT DEFAULT 'scheduled',       -- 'scheduled', 'completed', 'cancelled', 'no_show'
    metadata JSONB DEFAULT '{}'
);

-- Errors
CREATE TABLE errors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID REFERENCES conversations(id),
    error_type TEXT NOT NULL,              -- 'api', 'timeout', 'parse', 'rate_limit'
    error_source TEXT,                     -- 'openai', 'ghl', 'instagram', etc.
    error_message TEXT,
    error_code TEXT,
    occurred_at TIMESTAMPTZ DEFAULT NOW(),
    resolved BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}'
);

-- Daily Reports (AI-generated)
CREATE TABLE daily_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_date DATE UNIQUE NOT NULL,
    generated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Summary metrics
    total_conversations INTEGER,
    total_messages INTEGER,
    total_cost DECIMAL(10,4),
    resolution_rate DECIMAL(5,2),
    avg_response_time_ms INTEGER,
    appointments_booked INTEGER,
    handoffs_count INTEGER,
    errors_count INTEGER,

    -- AI analysis
    summary TEXT,                          -- Overall summary
    quality_scores JSONB,                  -- Individual conversation scores
    patterns_identified JSONB,             -- Common issues/trends
    recommendations JSONB,                 -- Improvement suggestions

    -- Raw data for reference
    raw_metrics JSONB
);

-----------------------------------------------------------
-- INDEXES
-----------------------------------------------------------

-- Conversations
CREATE INDEX idx_conversations_contact ON conversations(contact_id);
CREATE INDEX idx_conversations_channel ON conversations(channel);
CREATE INDEX idx_conversations_started ON conversations(started_at);
CREATE INDEX idx_conversations_status ON conversations(status);

-- Messages
CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_timestamp ON messages(timestamp);
CREATE INDEX idx_messages_role ON messages(role);

-- Handoffs
CREATE INDEX idx_handoffs_conversation ON handoffs(conversation_id);
CREATE INDEX idx_handoffs_triggered ON handoffs(triggered_at);

-- Appointments
CREATE INDEX idx_appointments_conversation ON appointments(conversation_id);
CREATE INDEX idx_appointments_booked ON appointments(booked_at);
CREATE INDEX idx_appointments_datetime ON appointments(appointment_datetime);

-- Errors
CREATE INDEX idx_errors_conversation ON errors(conversation_id);
CREATE INDEX idx_errors_type ON errors(error_type);
CREATE INDEX idx_errors_occurred ON errors(occurred_at);

-- Daily Reports
CREATE INDEX idx_reports_date ON daily_reports(report_date);

-----------------------------------------------------------
-- VIEWS (for common queries)
-----------------------------------------------------------

-- Daily metrics summary
CREATE VIEW daily_metrics AS
SELECT
    DATE(started_at) as date,
    channel,
    COUNT(*) as conversations,
    SUM(message_count) as messages,
    SUM(total_cost) as cost,
    AVG(first_response_time_ms) as avg_frt_ms,
    COUNT(*) FILTER (WHERE status = 'resolved') as resolved,
    COUNT(*) FILTER (WHERE status = 'handed_off') as handed_off
FROM conversations
GROUP BY DATE(started_at), channel;

-- Hourly volume (for peak hours)
CREATE VIEW hourly_volume AS
SELECT
    DATE(timestamp) as date,
    EXTRACT(HOUR FROM timestamp) as hour,
    channel,
    COUNT(*) as message_count
FROM messages
WHERE role = 'user'
GROUP BY DATE(timestamp), EXTRACT(HOUR FROM timestamp), channel;

-----------------------------------------------------------
-- ROW LEVEL SECURITY (RLS)
-----------------------------------------------------------

-- Enable RLS on all tables
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE handoffs ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE errors ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_reports ENABLE ROW LEVEL SECURITY;

-- Policies (adjust based on your auth setup)
-- For service role (n8n), allow all operations
-- For dashboard users, allow read-only

-- Example: Allow authenticated users to read all data
CREATE POLICY "Allow authenticated read" ON conversations
    FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow authenticated read" ON messages
    FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow authenticated read" ON daily_reports
    FOR SELECT TO authenticated USING (true);

-- Service role can do everything (used by n8n)
-- No policy needed - service role bypasses RLS

-----------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------

-- Update conversation stats after new message
CREATE OR REPLACE FUNCTION update_conversation_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE conversations
    SET
        message_count = message_count + 1,
        total_tokens = total_tokens + COALESCE(NEW.tokens_used, 0),
        ended_at = NEW.timestamp
    WHERE id = NEW.conversation_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_message_insert
    AFTER INSERT ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_conversation_stats();

-- Update contact last_seen and conversation count
CREATE OR REPLACE FUNCTION update_contact_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE contacts
    SET
        last_seen_at = NOW(),
        total_conversations = total_conversations + 1
    WHERE id = NEW.contact_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_conversation_insert
    AFTER INSERT ON conversations
    FOR EACH ROW
    EXECUTE FUNCTION update_contact_stats();
