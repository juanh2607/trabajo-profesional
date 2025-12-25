# Analytics System - Task Breakdown

Detailed task tracking for the analytics implementation.

---

## Phase 1: Database Setup

- [ ] Create Supabase project
- [ ] Create database schema (see [database-schema.sql](database-schema.sql))
- [ ] Set up Row Level Security (RLS) policies
- [ ] Create indexes for common queries
- [ ] Test connection from n8n

---

## Phase 2: n8n Modifications

- [ ] Document current workflow structure
- [ ] Add conversation start timestamp capture
- [ ] Add message timestamp capture
- [ ] Capture token usage from GPT-5 responses
- [ ] Add error logging nodes
- [ ] Create Supabase insert nodes
- [ ] Track hand-off triggers to Slack
- [ ] Test end-to-end data flow

---

## Phase 3: GoHighLevel Integration

- [ ] Review GHL API documentation
- [ ] Set up API credentials
- [ ] Create webhook for appointment events (or polling)
- [ ] Link appointments to conversation IDs
- [ ] Test appointment tracking

---

## Phase 4: Daily AI Reports

- [ ] Create daily report prompt (see [daily-report-prompt.md](daily-report-prompt.md))
- [ ] Create scheduled n8n workflow
- [ ] Fetch conversations from Supabase
- [ ] Send to GPT-5 for analysis
- [ ] Store report in Supabase
- [ ] Send summary to Slack (optional)
- [ ] Test report generation

---

## Phase 5: Next.js Dashboard

- [ ] Set up Next.js project
- [ ] Configure Supabase client
- [ ] Implement authentication
- [ ] Build Overview page (key metrics cards)
- [ ] Build Conversations page (list + detail)
- [ ] Build Analytics page (charts, trends)
- [ ] Build Reports page (AI daily reports)
- [ ] Build Costs page (spending breakdown)
- [ ] Deploy to production

---

## Documentation

- [x] metrics-spec.md - Metric definitions
- [x] database-schema.sql - Supabase schema
- [x] n8n-modifications.md - Workflow changes
- [x] daily-report-prompt.md - GPT-5 prompt
