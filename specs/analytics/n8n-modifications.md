# n8n Workflow Modifications

Guide for modifying the existing n8n agent workflow to capture analytics data.

---

## Overview

The current n8n workflow needs modifications to:
1. Capture timestamps at key points
2. Extract token usage from GPT-5 responses
3. Log errors systematically
4. Send data to Supabase
5. Track hand-off events

---

## Prerequisites

### Supabase Credentials in n8n
Create a new credential in n8n:
- **Type**: Supabase
- **Host**: `https://[project-id].supabase.co`
- **Service Role Key**: From Supabase dashboard → Settings → API

### Environment Variables (Optional)
```
SUPABASE_URL=https://[project-id].supabase.co
SUPABASE_SERVICE_KEY=[your-service-role-key]
```

---

## Modification Points

### 1. Conversation Start

**Location**: After webhook receives first message from a new conversation

**Add nodes**:
```
[Webhook] → [Check if New Conversation] → [Create Conversation Record]
                                                      ↓
                                              [Supabase Insert]
```

**Supabase Insert - conversations**:
```json
{
  "contact_id": "{{ $json.contact_id }}",
  "channel": "{{ $json.channel }}",
  "started_at": "{{ $now.toISO() }}",
  "status": "active"
}
```

**Store conversation_id**: Save the returned ID in workflow data for later use.

---

### 2. Message Capture

**Location**: After each message is received and before/after LLM response

**For User Messages**:
```json
{
  "conversation_id": "{{ $json.conversation_id }}",
  "role": "user",
  "content": "{{ $json.message_content }}",
  "timestamp": "{{ $now.toISO() }}"
}
```

**For Assistant Messages** (after GPT-5 response):
```json
{
  "conversation_id": "{{ $json.conversation_id }}",
  "role": "assistant",
  "content": "{{ $json.response_content }}",
  "timestamp": "{{ $now.toISO() }}",
  "tokens_used": "{{ $json.usage.total_tokens }}",
  "generation_time_ms": "{{ $json.generation_time }}"
}
```

---

### 3. Token Usage & Cost Tracking

**Location**: After GPT-5 HTTP Request node

**Extract from OpenAI response**:
```javascript
// In a Code node after OpenAI call
const usage = $input.first().json.usage;
const inputTokens = usage.prompt_tokens;
const outputTokens = usage.completion_tokens;
const totalTokens = usage.total_tokens;

// GPT-5 pricing (update as needed)
const INPUT_PRICE = 0.01;  // per 1K tokens
const OUTPUT_PRICE = 0.03; // per 1K tokens

const cost = (inputTokens / 1000 * INPUT_PRICE) + (outputTokens / 1000 * OUTPUT_PRICE);

return {
  input_tokens: inputTokens,
  output_tokens: outputTokens,
  total_tokens: totalTokens,
  cost: cost
};
```

**Update conversation total**:
```sql
UPDATE conversations
SET total_tokens = total_tokens + {{ $json.total_tokens }},
    total_cost = total_cost + {{ $json.cost }}
WHERE id = '{{ $json.conversation_id }}'
```

---

### 4. Response Time Measurement

**Method 1: Using Code Node**

```javascript
// Before OpenAI call
$workflow.variables.llm_start = Date.now();
return $input.all();
```

```javascript
// After OpenAI call
const generationTime = Date.now() - $workflow.variables.llm_start;
return {
  ...$input.first().json,
  generation_time: generationTime
};
```

**Method 2: Using Date & Time Nodes**

Place "Date & Time" nodes before and after the HTTP call, then calculate difference.

---

### 5. First Response Time

**Location**: First assistant response in conversation

```javascript
// Check if this is first response
const isFirstResponse = $json.message_count === 0;

if (isFirstResponse) {
  const frt = Date.now() - new Date($json.conversation_started_at).getTime();

  // Update conversation with FRT
  return {
    conversation_id: $json.conversation_id,
    first_response_time_ms: frt
  };
}
```

---

### 6. Error Handling

**Add Error Trigger nodes** to catch failures:

```
[Any Node] → [Error Trigger] → [Log Error to Supabase]
```

**Error logging payload**:
```json
{
  "conversation_id": "{{ $json.conversation_id }}",
  "error_type": "{{ $json.error.type }}",
  "error_source": "{{ $json.error.node }}",
  "error_message": "{{ $json.error.message }}",
  "error_code": "{{ $json.error.code }}",
  "occurred_at": "{{ $now.toISO() }}"
}
```

---

### 7. Hand-off Tracking

**Location**: Before Slack notification node

**Add Supabase insert before Slack**:
```json
{
  "conversation_id": "{{ $json.conversation_id }}",
  "reason": "{{ $json.handoff_reason }}",
  "triggered_at": "{{ $now.toISO() }}"
}
```

**Update conversation status**:
```sql
UPDATE conversations
SET status = 'handed_off',
    resolution_type = 'handoff'
WHERE id = '{{ $json.conversation_id }}'
```

---

### 8. Conversation End Detection

**Triggers for ending a conversation**:
- User sends closing message ("thanks", "bye", etc.)
- No message for X minutes (timeout)
- Hand-off occurs
- Appointment booked

**Update conversation on end**:
```json
{
  "id": "{{ $json.conversation_id }}",
  "ended_at": "{{ $now.toISO() }}",
  "status": "resolved",
  "resolution_type": "auto"
}
```

---

## Workflow Diagram (Conceptual)

```
┌──────────────────────────────────────────────────────────────────┐
│                        MODIFIED WORKFLOW                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Webhook] → [Check New Convo?]                                  │
│                    │                                              │
│                    ├─ Yes → [Create Convo in Supabase]           │
│                    │                                              │
│                    ▼                                              │
│  [Save User Message to Supabase]                                 │
│                    │                                              │
│                    ▼                                              │
│  [Start Timer] → [GPT-5 Call] → [Stop Timer]                     │
│                                      │                            │
│                                      ▼                            │
│  [Extract Tokens & Cost] → [Save Assistant Message to Supabase]  │
│                                      │                            │
│                                      ▼                            │
│  [Update Convo Stats in Supabase]                                │
│                    │                                              │
│       ┌───────────┼───────────┐                                   │
│       ▼           ▼           ▼                                   │
│  [Hand-off?] [Appointment?] [End Convo?]                         │
│       │           │           │                                   │
│       ▼           ▼           ▼                                   │
│  [Log to     [Log to     [Update                                 │
│   Supabase]   Supabase]   Status]                                │
│                                                                   │
│  [Error Handler] → [Log Error to Supabase]                       │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Testing Checklist

- [ ] New conversation creates record in Supabase
- [ ] Messages are logged with correct timestamps
- [ ] Token usage is captured correctly
- [ ] Generation time is measured accurately
- [ ] First response time is calculated for first message only
- [ ] Errors are caught and logged
- [ ] Hand-offs update conversation status
- [ ] Conversation end is detected and recorded
- [ ] Cost calculation matches expected values
