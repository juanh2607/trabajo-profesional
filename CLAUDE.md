# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Behavior Guidelines

<communication>
- Use adaptive communication: concise for simple tasks, detailed for complex ones
- Always communicate in English
- When facing uncertainty or multiple valid approaches, present options with a recommendation
- Ask clarifying questions liberally - better to ask than assume
</communication>

<documentation>
- Use Mermaid for diagrams instead of ASCII
- Break tasks hierarchically: high-level phases with expandable subtasks
- Focus on practical understanding over academic formality
</documentation>

<working-style>
- Proactively suggest improvements, optimizations, and related ideas
- When planning, provide hierarchical breakdowns (phases → tasks → subtasks)
- Always recommend one option when presenting choices
- Consider the overall project context when making changes
- Proactively check for redundancies and inconsistencies across files
</working-style>

## Project Overview

<description>
This is a **planning and documentation repository** for a production healthcare call center agent. The actual n8n workflows run on a separate server - this repo serves as the central hub for improvement planning and thesis documentation.
</description>

<production-system>
- **Industry**: Healthcare/Medical
- **Channels**: Instagram, Facebook, SMS (incoming messages)
- **Tech Stack**:
  - **n8n**: Agent orchestration and workflow automation
  - **GoHighLevel (GHL)**: Lead/contact management CRM
  - **Slack**: Real-time client/team communication
- **Volume**: ~100+ messages during off-peak hours (nights), production system
- **LLM**: GPT-5 (OpenAI) for response generation
</production-system>

<goals>
1. **Scale & Performance**: Improve capacity, reliability, and response times
2. **New Features**: Explore and plan additional capabilities
3. **Analytics**: Implement metrics tracking and monitoring
4. **Thesis**: Document as Software Engineering + Business/Operations academic work
</goals>

## Repository Structure

<structure>
```
/Call-Center Agent/
├── CLAUDE.md              # This file - project context
├── current-state/         # Documentation of existing system
│   └── architecture.md    # Current tech stack and data flow
├── plans/                 # Improvement plans by category
│   ├── analytics/         # Metrics and monitoring plans
│   ├── scaling/           # Performance and capacity plans
│   └── features/          # New feature proposals
└── thesis/                # Academic documentation
    ├── outline.md         # Thesis structure
    └── research/          # Supporting research
```
</structure>

## Working in This Repository

<repo-contains>
- Planning documents and improvement proposals
- Architecture documentation
- Thesis drafts and research notes
- Feature specifications
</repo-contains>

<repo-does-not-contain>
- n8n workflow JSON files (those live on the n8n server)
- Application code
- Credentials or API keys
</repo-does-not-contain>

<context>
- The n8n agent is already in production - changes require careful planning
- GoHighLevel handles lead data - integrations must respect their API limits
- Slack is used for human escalation and client notifications
- All improvements should consider both technical and business impact (thesis focus)
</context>

## Active Plans

<analytics-system status="in-progress">

Building a comprehensive metrics and analytics system.

**Tech Stack**:
- Supabase (PostgreSQL) for data storage
- Next.js dashboard for visualization
- GPT-5 for daily AI-generated reports

**Metrics Being Tracked**:
- Conversation length, response time, appointments, hand-offs, cost, errors
- First response time, resolution rate, sentiment, channel performance
- Peak hours, cost per resolution, token efficiency, repeat contacts

**Key Files**:
- `plans/analytics/metrics-spec.md` - Detailed metric definitions
- `plans/analytics/database-schema.sql` - Supabase schema
- `plans/analytics/n8n-modifications.md` - Workflow changes needed
- `plans/analytics/daily-report-prompt.md` - AI report generation

**Implementation Phases**:
1. Database Setup (Supabase)
2. n8n Modifications (data capture)
3. GoHighLevel Integration (appointments)
4. Daily AI Reports
5. Next.js Dashboard

</analytics-system>
