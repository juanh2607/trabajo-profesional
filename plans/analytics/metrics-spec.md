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
