# Current System Architecture

## Overview

The call center agent handles incoming messages from multiple channels for a healthcare client, automatically responding and managing leads.

## Components

### Message Channels (Inbound)
- **Instagram** - Direct messages
- **Facebook** - Messenger messages
- **SMS** - Text messages

### Core Systems

#### n8n (Workflow Automation)
- Receives incoming messages via webhooks
- Processes and routes conversations
- Generates AI-powered responses
- Triggers actions in other systems

#### GoHighLevel (CRM)
- Stores contact/lead information
- Manages conversation history
- Handles campaign and pipeline tracking

#### Slack (Team Communication)
- Receives alerts for escalations
- Notifies team of important events
- Allows human intervention when needed

## Data Flow

```
[Instagram/Facebook/SMS]
        │
        ▼
    [n8n Agent]
        │
        ├──► [GoHighLevel] ──► Lead Management
        │
        └──► [Slack] ──► Human Escalation
```

## Current Metrics (To Be Documented)
- [ ] Average messages per day
- [ ] Response time
- [ ] Resolution rate
- [ ] Human escalation rate
- [ ] Peak hours vs off-peak distribution
