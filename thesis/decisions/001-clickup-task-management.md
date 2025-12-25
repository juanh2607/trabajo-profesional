# ADR-001: ClickUp for Task Management

**Date**: 2025-12-25
**Status**: Accepted

## Context
Need a system to track tasks, planning, and progress for the call center agent improvements. Previously using local markdown files (`todo.md`, `plans/`).

## Options
1. **Local markdown files**: Simple, version-controlled, but no visibility or collaboration
2. **ClickUp via MCP**: Dedicated tool, real-time sync with Claude Code, better organization

## Decision
Use ClickUp for all task management. Local repo keeps only documentation, specs, and thesis work.

## Rationale
- **Technical**: MCP integration allows Claude to read/write tasks directly, reducing context switching
- **Business**: Better visibility into progress, easier to track for thesis metrics

## Consequences
- Must ask before creating/updating tasks (prevents accidental changes)
- Need to check ClickUp for existing tasks before starting work
- Local repo is cleaner - focused on context, not planning
