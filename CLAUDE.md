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

## Task Management

<clickup>
This project uses ClickUp for all task management via MCP server.

**Proactive Usage**:
- Use ClickUp MCP tools for tracking tasks, progress, and planning
- Check ClickUp for existing tasks before starting work
- Reference task IDs when working on specific items

**Before Creating/Updating Tasks**:
- ALWAYS ask user for confirmation before creating new tasks
- ALWAYS ask user for confirmation before updating existing tasks
- Gather context of current tasks to avoid duplicates

**Organization**:
- Create sub-tasks under parent tasks for better hierarchy
- Use descriptive task names that reflect the work
- Keep tasks in appropriate lists/folders
- Use markdown descriptions for rich formatting (headers, lists, code blocks)

**Workspace Structure**:
- Space: "Trabajo Profesional"
- Use search to find existing related tasks before creating new ones
</clickup>

## Thesis Documentation

<thesis-documentation>
This project doubles as a thesis (Software Engineering + Business/Operations). Proactively remind the user to document their work.

**Daily Log** (`thesis/log/`):
- One file per day: `YYYY-MM-DD.md`
- Sections: Done, Decisions, Notes

**Proactive Reminders** - Prompt to update the log:
- Before pushing changes to git
- After completing significant tasks
- When making important decisions
- At end of work sessions

**Guidelines**:
- Document everything - decisions, reasoning, outcomes, learnings
- Capture both technical and business observations
- Link to ClickUp tasks when relevant
- Can compile/organize into formal sections later
</thesis-documentation>

## Project Overview

<description>
This is a **context and documentation repository** for a production healthcare call center agent. The actual n8n workflows run on a separate server. Task management and planning lives in ClickUp - this repo holds technical specs, documentation, and thesis work.
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
/
├── CLAUDE.md              # This file - project context
├── agent/                 # Call center agent documentation
│   ├── documentation/     # Main agent docs, diagrams, PDFs
│   ├── files/             # Training transcripts, playbook, business domain
│   ├── prompts/           # All agent prompts (orchestrator, experts, etc.)
│   └── WIP/               # Work in progress items
├── architecture/          # System documentation
│   └── current-state.md   # Current tech stack and data flow
├── specs/                 # Technical specifications
│   ├── analytics/         # Database schemas, metrics definitions
│   └── prompts/           # Analytics-related prompts
└── thesis/                # Academic documentation
    ├── outline.md         # Thesis structure
    ├── research/          # Supporting research
    └── log/               # Daily work log (YYYY-MM-DD.md)
```
</structure>

## Working in This Repository

<repo-contains>
- Agent prompts and documentation (how the call center agent works)
- Architecture and system documentation
- Technical specifications (schemas, prompts)
- Thesis drafts and research notes
</repo-contains>

<repo-does-not-contain>
- Task management or planning (lives in ClickUp)
- n8n workflow JSON files (live on the n8n server)
- Application code
- Credentials or API keys
</repo-does-not-contain>

<context>
- The n8n agent is already in production - changes require careful planning
- GoHighLevel handles lead data - integrations must respect their API limits
- Slack is used for human escalation and client notifications
- All improvements should consider both technical and business impact (thesis focus)
</context>
