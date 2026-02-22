# CLAUDE.md

## Project Overview

**Authoritative Reference**: See `AGENTS.md` for canonical project information. This file focuses on Claude-specific working instructions.

`rsp-plugin` is a Claude Code plugin repo containing markdown prompt files and shell scripts. There is no build system, package manager, or test suite.

## Working Instructions

### Planning

- Before adding a new component, check the planned plugins table in `README.md` to avoid duplication.
- Review existing example components to match the established patterns.
- Each component should have a single, clear responsibility.

### Execution

- Follow the naming conventions: lowercase kebab-case for all files and directories.
- Always include valid YAML frontmatter with the required fields for the component type.
- For skills that need long prompts, split into multiple files using `@include`.
- Hook scripts must start with `#!/usr/bin/env bash` and read event JSON from stdin.
- Do not add runtime dependencies — hooks should only rely on standard unix tools and `jq`.

### After changes

- Update the planned plugins table in `README.md` (move status from "Planned" to "Available").
- Verify the component loads correctly by installing the plugin in Claude Code.
- Follow the PR checklist in `CONTRIBUTING.md`.

### Scope

- This repo contains only Claude Code plugin components — no application code, libraries, or services.
- Do not add generic boilerplate. Every component should be specific to a RentSpree workflow.
- Do not modify `.claude-plugin/plugin.json` unless the plugin metadata schema changes.
