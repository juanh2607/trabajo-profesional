# Daily Report - GPT-5 Prompt

System prompt and instructions for generating daily AI analysis reports.

---

## n8n Workflow Setup

### Schedule
- **Trigger**: Cron - Daily at 6:00 AM (before business hours)
- **Timezone**: Match client timezone

### Data Fetch
Query from Supabase:
```sql
SELECT
    c.*,
    json_agg(m.* ORDER BY m.timestamp) as messages
FROM conversations c
LEFT JOIN messages m ON m.conversation_id = c.id
WHERE c.started_at >= CURRENT_DATE - INTERVAL '1 day'
  AND c.started_at < CURRENT_DATE
GROUP BY c.id
```

---

## System Prompt

```
You are an AI analytics specialist reviewing customer service conversations for a healthcare call center. Your role is to:

1. Evaluate conversation quality
2. Identify patterns and issues
3. Provide actionable recommendations

Context:
- Industry: Healthcare/Medical
- Channels: Instagram, Facebook, SMS
- Agent type: AI-powered (GPT-5) with human escalation
- Goals: High resolution rate, fast response times, appointment bookings

Be specific, data-driven, and focus on actionable insights.
```

---

## Analysis Prompt Template

```
Analyze the following conversations from {{ date }}.

## Summary Metrics
- Total conversations: {{ total_conversations }}
- Messages exchanged: {{ total_messages }}
- Total cost: ${{ total_cost }}
- Appointments booked: {{ appointments }}
- Hand-offs: {{ handoffs }}
- Errors: {{ errors }}

## Conversations to Analyze

{{ conversations_json }}

---

Please provide:

### 1. Quality Scores (1-10 for each conversation)
Rate each conversation on:
- Helpfulness: Did the agent address the user's needs?
- Accuracy: Were responses correct and appropriate?
- Efficiency: Was the conversation concise without being abrupt?
- Professionalism: Was the tone appropriate for healthcare?
- Resolution: Was the issue successfully resolved?

Format:
```json
{
  "conversation_id": "score (1-10)",
  "breakdown": {
    "helpfulness": X,
    "accuracy": X,
    "efficiency": X,
    "professionalism": X,
    "resolution": X
  },
  "notes": "Brief explanation"
}
```

### 2. Patterns Identified
List any recurring themes:
- Common questions or requests
- Frequent issues or complaints
- Times when the agent struggled
- Successful interaction patterns

### 3. Recommendations
Provide 3-5 specific, actionable recommendations:
- Prompt improvements
- Knowledge gaps to address
- Process changes
- Escalation rule adjustments

### 4. Overall Summary
Write a 2-3 paragraph summary suitable for sharing with the client, highlighting:
- Key achievements
- Areas for improvement
- Suggested next steps
```

---

## Response Format

Request structured JSON response:

```json
{
  "report_date": "YYYY-MM-DD",
  "summary": "Overall summary text...",

  "quality_scores": [
    {
      "conversation_id": "uuid",
      "overall_score": 8.5,
      "breakdown": {
        "helpfulness": 9,
        "accuracy": 8,
        "efficiency": 9,
        "professionalism": 8,
        "resolution": 9
      },
      "notes": "Explanation..."
    }
  ],

  "patterns_identified": [
    {
      "pattern": "Pattern description",
      "frequency": "how often observed",
      "impact": "high/medium/low",
      "examples": ["conversation_id_1", "conversation_id_2"]
    }
  ],

  "recommendations": [
    {
      "priority": 1,
      "category": "prompt/knowledge/process/escalation",
      "recommendation": "Specific recommendation",
      "rationale": "Why this matters",
      "expected_impact": "What improvement to expect"
    }
  ],

  "metrics_analysis": {
    "resolution_rate_assessment": "Good/Needs improvement",
    "response_time_assessment": "Good/Needs improvement",
    "cost_efficiency_assessment": "Good/Needs improvement",
    "notable_outliers": []
  }
}
```

---

## Storing the Report

Insert into `daily_reports` table:

```sql
INSERT INTO daily_reports (
    report_date,
    total_conversations,
    total_messages,
    total_cost,
    resolution_rate,
    avg_response_time_ms,
    appointments_booked,
    handoffs_count,
    errors_count,
    summary,
    quality_scores,
    patterns_identified,
    recommendations,
    raw_metrics
) VALUES (
    '{{ date }}',
    {{ metrics.total_conversations }},
    {{ metrics.total_messages }},
    {{ metrics.total_cost }},
    {{ metrics.resolution_rate }},
    {{ metrics.avg_response_time }},
    {{ metrics.appointments }},
    {{ metrics.handoffs }},
    {{ metrics.errors }},
    '{{ gpt_response.summary }}',
    '{{ gpt_response.quality_scores | json }}',
    '{{ gpt_response.patterns_identified | json }}',
    '{{ gpt_response.recommendations | json }}',
    '{{ raw_metrics | json }}'
);
```

---

## Slack Summary (Optional)

Send a brief daily summary to Slack:

```
📊 *Daily Report - {{ date }}*

*Key Metrics:*
• Conversations: {{ total }} ({{ resolved }} resolved, {{ handoffs }} hand-offs)
• Appointments: {{ appointments }}
• Avg Response Time: {{ frt }}ms
• Cost: ${{ cost }}

*Top Recommendation:*
{{ recommendations[0].recommendation }}

*Overall:* {{ quality_assessment }}

_Full report available in dashboard_
```

---

## Token Optimization Tips

To reduce daily report costs:

1. **Summarize conversations**: Send condensed versions, not full transcripts
2. **Batch processing**: If many conversations, process in chunks
3. **Skip obvious successes**: Only analyze in detail conversations that were handed off or had issues
4. **Use function calling**: Request structured JSON output for reliable parsing

### Condensed Conversation Format

Instead of full messages, send:
```json
{
  "id": "conversation_id",
  "channel": "instagram",
  "message_count": 8,
  "duration_minutes": 12,
  "outcome": "resolved",
  "appointment_booked": true,
  "summary": "User asked about availability, booked appointment for next week",
  "key_exchanges": [
    {"user": "First message...", "agent": "First response..."},
    {"user": "Key question...", "agent": "Key response..."}
  ]
}
```
