# AGENTS.md

## Purpose & Authority

This file is the **canonical source of truth** for the `rsp-plugin` repository. All AI tools and human contributors should reference this document.

Tool-specific files (CLAUDE.md, copilot-instructions.md) must not contradict it.

## Project Summary

`rsp-plugin` is the official Claude Code plugin for the RentSpree engineering team. It provides a centralized, version-controlled collection of shared skills, commands, agents, and hooks that extend Claude Code's capabilities for RentSpree-specific workflows.

- **Serves**: RentSpree engineers using Claude Code
- **Installed via**: `/plugin install rsp-plugin@rentspree`
- **This is not**: a standalone application, library, or service — it is a Claude Code plugin composed entirely of markdown prompt files and shell scripts

## Repository Map

| Directory | Responsibility |
|-----------|---------------|
| `.claude-plugin/` | Plugin metadata (`plugin.json`) — required for Claude Code to recognize this as a plugin |
| `commands/` | Slash command definitions (`.md` files with YAML frontmatter) — one-shot prompts triggered by `/command-name` |
| `skills/` | Skill definitions — each skill is a directory containing `SKILL.md` and optional included files. Triggered by `/skill-name` or invoked by agents |
| `agents/` | Agent definitions (`.md` files with YAML frontmatter) — autonomous sub-agents spawned via the `Task` tool |
| `hooks/` | Hook scripts (`.sh` files) — shell scripts registered in Claude Code settings that run on lifecycle events (e.g. PostToolUse) |

## Development Workflow

This repo has no build step, dependencies, or test suite. Development consists of adding or editing markdown and shell files.

### Setup

```bash
gh repo clone rentspree/rsp-plugin
```

### Testing locally

Install the plugin in Claude Code and verify components appear:

```
/plugin install rsp-plugin@rentspree
```

Or symlink for local development.

### Linting

No automated linting is configured. Validate YAML frontmatter manually.

## Architecture Overview

### Plugin metadata

`.claude-plugin/plugin.json` declares the plugin name, description, author, and version. Claude Code reads this to register the plugin.

### Component types

Each component type has a specific file format:

- **Commands** (`commands/*.md`): YAML frontmatter with `description`, `allowed-tools`, `argument-hint`. Prompt body follows the frontmatter.
- **Skills** (`skills/*/SKILL.md`): YAML frontmatter with `name`, `description`, `allowed-tools`, `model`. Support `@include ./FILE.md` to split prompts across files.
- **Agents** (`agents/*.md`): YAML frontmatter with `name`, `description`, `tools`, `model`. Define autonomous sub-agents with scoped tool access.
- **Hooks** (`hooks/*.sh`): Bash scripts that read JSON event data from stdin. Must be registered in Claude Code settings under lifecycle event keys (e.g. `PostToolUse`).

### How hooks differ from other components

Commands, skills, and agents are prompt-based and invoked within Claude Code's conversation context. Hooks are external shell scripts that run outside the conversation — they react to lifecycle events, receive structured JSON on stdin, and output warnings or feedback to stderr/stdout.

## Conventions & Patterns

### Naming

- All file and directory names use **lowercase kebab-case**
- Commands: `commands/<command-name>.md`
- Skills: `skills/<skill-name>/SKILL.md`
- Agents: `agents/<agent-name>.md`
- Hooks: `hooks/<descriptive-trigger-name>.sh`

### Frontmatter

All markdown components use YAML frontmatter delimited by `---`. Required fields vary by component type (see CONTRIBUTING.md for the full reference table).

### Prompt style

- Write clear, imperative instructions
- Use numbered steps for multi-step workflows
- Specify constraints explicitly (e.g. "read-only", "do not create files")
- Keep prompts focused — one responsibility per component

## Legacy / Technical Debt

This is a new repository with no legacy code. Current example components (`example-command`, `example-skill`, `example-agent`, `example-hook`) are scaffolding templates and should be replaced or supplemented with real plugins as they are built.

## Testing Expectations

There is no automated test suite. Verification is manual:

1. Install the plugin via Claude Code
2. Confirm commands appear in `/help` or slash-command autocomplete
3. Run each component and verify expected behavior
4. For hooks, confirm they trigger on the registered lifecycle event

## Maintenance Contract

Update this file when:

- A new component type is introduced
- Naming conventions or frontmatter schema changes
- The plugin metadata format evolves
- Major structural reorganization occurs
