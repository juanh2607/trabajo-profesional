This folder contains all of the content needed for the versioning of Dr Jones call-center AI agent.

## Directory Structure

### Core Folders
- `prompts/`: prompts for each of the sub-agents (orchestrator, user_engagement, medical_expert, business_expert, scheduling_assistant)
- `files/`: files the agent has access to or that were used to improve the prompts
- `old/`: old content that could be deleted but I keep it just in case
- `documentation/`: system architecture documentation, diagrams, and visual aids
- `WIP/`: work in progress and experimental content

## Architecture

- We are using n8n for the agent workflow
