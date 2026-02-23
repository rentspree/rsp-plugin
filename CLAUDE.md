# CLAUDE.md

## Project Overview

**Authoritative Reference**: See `AGENTS.md` for canonical project information. This file focuses on Claude-specific working instructions.

`claude-plugins` is a Claude Code plugin marketplace repo containing multiple plugin packages. Each plugin package lives under `plugins/<name>/` and contains markdown prompt files and shell scripts. There is no build system, package manager, or test suite.

> **Note:** Custom commands have been merged into skills. There is no separate `commands/` directory. Use `disable-model-invocation: true` in a skill's frontmatter for manual-only invocation.

## Working Instructions

### Planning

- Before adding a new component, check the planned plugins table in `README.md` to avoid duplication.
- Review existing example components to match the established patterns.
- Each component should have a single, clear responsibility.
- When adding a new plugin package, register it in `.claude-plugin/marketplace.json`.
- Plugin packages should follow the `<domain>-plugins` or `<bu>-plugins` naming convention.

### Execution

- Follow the naming conventions: lowercase kebab-case for all files and directories.
- Always include valid YAML frontmatter with the required fields for the component type.
- For skills that need long prompts, use supporting files and reference them from `SKILL.md`. Keep `SKILL.md` under 500 lines.
- Use `@include ./FILE.md` to compose prompts from multiple files.
- Use `disable-model-invocation: true` for task/command-style skills that should only be triggered manually via `/skill-name`.
- Use `user-invocable: false` for background knowledge skills that Claude should apply automatically but users shouldn't invoke directly.
- Use `` !`command` `` syntax for dynamic context injection (e.g. fetching live data before the skill runs).
- Use `context: fork` with `agent: <type>` to run skills in an isolated subagent.
- Hook scripts must start with `#!/usr/bin/env bash` and read event JSON from stdin.
- Do not add runtime dependencies — hooks should only rely on standard unix tools and `jq`.

### After changes

- Update the planned plugins table in `README.md` (move status from "Planned" to "Available").
- Verify the component loads correctly by installing the plugin in Claude Code.
- Follow the PR checklist in `CONTRIBUTING.md`.

### Scope

- This repo contains only Claude Code plugin components — no application code, libraries, or services.
- Do not add generic boilerplate. Every component should be specific to a RentSpree workflow.
- Do not modify `.claude-plugin/marketplace.json` unless adding/removing a plugin package or the metadata schema changes.
- Do not modify a plugin's `.claude-plugin/plugin.json` unless the plugin metadata schema changes.
