# Metrics Specification

Detailed definitions for all tracked metrics in the analytics system.

---

## Core Metrics

### 1. Conversation Length
- **Definition**: Total number of messages exchanged in a conversation
- **Unit**: Integer (message count)
- **Calculation**: `COUNT(messages) WHERE conversation_id = X`
- **Segmentation**: By channel, by outcome (resolved/handed-off)
- **Thesis relevance**: Indicates conversation complexity and AI efficiency

### 2. Response Generation Time
- **Definition**: Time taken for GPT-5 to generate each response
- **Unit**: Milliseconds
- **Calculation**: `response_received_at - request_sent_at`
- **Capture point**: n8n HTTP node response
- **Thesis relevance**: System performance, user experience

### 3. Appointments Booked
- **Definition**: Successful appointment bookings through the agent
- **Unit**: Count
- **Source**: GoHighLevel calendar API
- **Segmentation**: By channel, by time period
- **Thesis relevance**: Key conversion metric, business value

### 4. Hand-offs
- **Definition**: Conversations escalated to human agents
- **Unit**: Count
- **Trigger**: Slack notification sent
- **Capture point**: n8n Slack node execution
- **Segmentation**: By reason, by channel, by time
- **Thesis relevance**: AI limitation indicator, operational cost

### 5. Cost
- **Definition**: Total spend on LLM API calls
- **Unit**: USD
- **Calculation**: `(prompt_tokens × input_price) + (completion_tokens × output_price)`
- **Source**: OpenAI API response `usage` object
- **Thesis relevance**: ROI calculation, cost-benefit analysis

### 6. Errors
- **Definition**: Failed operations in the workflow
- **Types**:
  - API errors (LLM, GHL, channel APIs)
  - Timeout errors
  - Parsing/format errors
  - Rate limit errors
- **Capture point**: n8n error handling nodes
- **Thesis relevance**: System reliability, improvement opportunities

---

## Derived Metrics

### 7. First Response Time (FRT)
- **Definition**: Time from first user message to first agent response
- **Unit**: Seconds
- **Calculation**: `first_agent_message.timestamp - first_user_message.timestamp`
- **Target**: < 5 seconds
- **Thesis relevance**: Customer experience KPI

### 8. Resolution Rate
- **Definition**: Percentage of conversations resolved without human intervention
- **Unit**: Percentage
- **Calculation**: `(total_conversations - handoffs) / total_conversations × 100`
- **Target**: > 80%
- **Thesis relevance**: Automation effectiveness

### 9. Sentiment Trajectory
- **Definition**: Change in customer sentiment during conversation
- **Unit**: Score (-1 to +1)
- **Calculation**: `final_sentiment - initial_sentiment`
- **Method**: Analyze first and last user messages with sentiment API
- **Thesis relevance**: AI quality, customer satisfaction

### 10. Channel Performance Index
- **Definition**: Composite score comparing metrics across channels
- **Components**:
  - Resolution rate (weight: 40%)
  - First response time (weight: 30%)
  - Cost per conversation (weight: 30%)
- **Thesis relevance**: Channel optimization decisions

### 11. Peak Hours Distribution
- **Definition**: Message volume by hour of day
- **Unit**: Count per hour
- **Calculation**: `COUNT(messages) GROUP BY HOUR(timestamp)`
- **Thesis relevance**: Capacity planning, staffing decisions

### 12. Cost per Resolution
- **Definition**: Average cost for successfully resolved conversations
- **Unit**: USD
- **Calculation**: `SUM(cost WHERE resolved=true) / COUNT(resolved=true)`
- **Thesis relevance**: Business ROI, efficiency metric

### 13. Token Efficiency
- **Definition**: Tokens used per successful conversation
- **Unit**: Tokens
- **Calculation**: `SUM(total_tokens WHERE resolved=true) / COUNT(resolved=true)`
- **Thesis relevance**: Prompt optimization opportunity

### 14. Repeat Contact Rate
- **Definition**: Same customer contacting again within 48 hours
- **Unit**: Percentage
- **Calculation**: `COUNT(contacts with multiple convos in 48h) / total_unique_contacts × 100`
- **Target**: < 10%
- **Thesis relevance**: Resolution quality indicator

---

## Service & Conversation Metrics

### 15. Service Type Distribution
- **Definition**: Breakdown of conversations by service interest
- **Types**:
  - Weight Loss (GLP-1/peptides) - main program
  - BHRT (Bioidentical Hormone Replacement)
  - Healing Peptides (BPC-157, TB-500)
  - Cognitive Peptides (NAD+)
  - Growth Hormone Peptides (HGH, anti-aging)
  - International Leads
- **Unit**: Count and percentage per type
- **Source**: Human Escalator classification
- **Thesis relevance**: Market demand analysis, service expansion decisions

### 16. Conversion Rate by Service
- **Definition**: Booking rate segmented by service type
- **Unit**: Percentage
- **Calculation**: `appointments_booked / conversations × 100` per service type
- **Thesis relevance**: Service-specific performance, ROI per service

### 17. Stage Funnel Progression
- **Definition**: Lead progression through conversation stages
- **Stages**:
  - Stage 1: Greeting
  - Stage 2a: Emotional Context (Ruin Identification)
  - Stage 2b: Medical Context (Probable Cause)
  - Stage 3: Solution Proposal
  - Stage 4: Booking Consultation
- **Metrics per stage**:
  - Entry count
  - Exit count
  - Drop-off rate
  - Average time in stage
- **Thesis relevance**: Identifies bottlenecks, optimization opportunities

### 18. Stage Completion Rate
- **Definition**: Percentage of conversations reaching each stage
- **Unit**: Percentage
- **Calculation**: `conversations_reaching_stage / total_conversations × 100`
- **Thesis relevance**: Funnel analysis, agent effectiveness

---

## Medical Context Metrics

### 19. Probable Cause Distribution
- **Definition**: Breakdown of identified probable causes
- **Types**:
  - Metabolism Slowdown
  - Medication Desensitization
  - Hormone Imbalance
  - Insulin Resistance
- **Unit**: Count and percentage per type
- **Source**: Medical Expert agent output
- **Thesis relevance**: Patient population insights, solution personalization

### 20. Ruin Identification Rate
- **Definition**: Percentage of conversations where lead's ruin was identified
- **Unit**: Percentage
- **Calculation**: `conversations_with_ruin / total_conversations × 100`
- **Thesis relevance**: Discovery phase effectiveness

### 21. Conversion Rate by Probable Cause
- **Definition**: Booking rate segmented by identified probable cause
- **Unit**: Percentage
- **Thesis relevance**: Which medical contexts convert best

---

## Escalation Metrics

### 22. Escalation Type Breakdown
- **Definition**: Hand-offs categorized by type
- **Categories**:
  - **Service-based**: BHRT, Healing Peptides, Cognitive Peptides, Growth Hormone Peptides, International
  - **Critical**: Medical Emergency, Safety Concern, Severe Reaction, Technical Issue, Underage, Parent Inquiry
  - **Sub-agent**: Medical Expert hand-off, Business Expert hand-off
- **Unit**: Count and percentage per type
- **Thesis relevance**: Identifies gaps in AI capability, safety monitoring

### 23. Critical Escalation Rate
- **Definition**: Percentage of conversations requiring urgent human intervention
- **Unit**: Percentage
- **Target**: < 1%
- **Thesis relevance**: Safety monitoring, risk assessment

---

## Sub-Agent Performance Metrics

### 24. Sub-Agent Invocation Count
- **Definition**: Number of times each specialist agent is called
- **Agents**:
  - Medical Expert
  - Business Expert
  - Scheduling Assistant
  - Human Escalator
  - Reply Gatekeeper
- **Unit**: Count per agent
- **Thesis relevance**: Agent utilization patterns

### 25. Sub-Agent Hand-off Rate
- **Definition**: Percentage of invocations where agent couldn't fully answer
- **Unit**: Percentage per agent
- **Calculation**: `hand_off_required_count / total_invocations × 100`
- **Thesis relevance**: Knowledge base gaps, training opportunities

### 26. Scheduling Success Rate
- **Definition**: Percentage of booking attempts that succeed
- **Unit**: Percentage
- **Calculation**: `successful_bookings / booking_attempts × 100`
- **Thesis relevance**: Scheduling flow optimization

### 27. Reply Gatekeeper Suppression Rate
- **Definition**: Percentage of responses suppressed (not sent)
- **Unit**: Percentage
- **Calculation**: `NO_REPLY_count / total_gatekeeper_calls × 100`
- **Thesis relevance**: Conversation quality, redundancy prevention

---

## Aggregation Periods

| Period | Use Case |
|--------|----------|
| Real-time | Dashboard live metrics |
| Hourly | Peak hours analysis |
| Daily | Daily reports, trend detection |
| Weekly | Performance reviews |
| Monthly | Thesis analysis, executive reports |

---

## Data Retention

| Data Type | Retention |
|-----------|-----------|
| Raw messages | 90 days |
| Aggregated metrics | 2 years |
| Daily reports | 2 years |
| Errors | 30 days |
