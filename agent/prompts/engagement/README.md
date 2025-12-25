# Engagement Agent Templates

## Overview
The `user_engagement.md` prompt dynamically injects stage-specific templates during conversation processing. This folder contains those stage-specific synthesis patterns.

## How It Works

1. **Orchestrator** packages conversation context + sub-agent JSON responses
2. **n8n workflow** selects the appropriate template file based on current stage
3. **Template content** is injected into `{{ $json.templates }}` in user_engagement.md
4. **user_engagement** synthesizes JSON → conversational response using the pattern

## Template Structure

Each template file follows this format:

```markdown
# Stage [X]: [Stage Name]

<templates>
<template>
<scenario>[Brief description: lead situation, what sub-agent returned]</scenario>

<structured_input>
[Only the relevant sub-agent JSON or key context - keep concise]
</structured_input>

<final_response>
[Your conversational response to the lead]
</final_response>
</template>

<!-- Additional templates as needed -->
</templates>
```

### Examples by Stage:

**Stage 2b (Medical Context):**
```xml
<structured_input>
{
  "clinical_question": "Do you notice energy crashes after meals?",
  "rationale": "Checking for insulin resistance"
}
</structured_input>
```

**Stage 3 (Solution Proposal):**
```xml
<structured_input>
{
  "probable_cause_identified": "insulin_resistance",
  "solution_teaser": "Dr. Jones specializes in reversing insulin resistance"
}
</structured_input>
```

**Stage 4 (Booking):**
```xml
<structured_input>
{
  "time_slots": [
    {"formatted": "Tomorrow at 12pm EST"},
    {"formatted": "Tomorrow at 5pm EST"}
  ]
}
</structured_input>
```

## Template Files

- `1 - Greeting.md` - Initial greeting patterns (typically no sub-agent data)
- `2a - Ruin Identification.md` - Emotional discovery patterns
- `2b - Medical Context.md` - Medical question synthesis (medical_expert JSON → warm questions)
- `3 - Solution Proposal.md` - Solution delivery (medical_expert JSON → confident proposal + booking)
- `4 - Booking Consultation.md` - Scheduling (scheduling_assistant JSON → conversational slots)

## Guidelines

- Include 5-10 diverse examples per stage
- Show various lead scenarios (frustrated, analytical, brief, committed, etc.)
- Demonstrate JSON transformation clearly
- Keep `<structured_input>` concise - only relevant sub-agent data
- Reference main prompt tags (e.g., `<empathy_guide>`, `<prohibited_patterns>`) rather than repeating content
- Show both simple and complex scenarios for each stage
