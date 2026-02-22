# AGENTS.md

## Purpose & Authority

This file is the **canonical source of truth** for the `claude-plugins` repository. All AI tools and human contributors should reference this document.

Tool-specific files (CLAUDE.md, copilot-instructions.md) must not contradict it.

## Project Summary

`claude-plugins` is the official Claude Code plugin marketplace for the RentSpree engineering team. It provides a centralized, version-controlled collection of plugin packages, each containing shared skills, commands, agents, and hooks that extend Claude Code's capabilities for RentSpree-specific workflows.

- **Serves**: RentSpree engineers using Claude Code
- **Installed via**:
  ```
  /plugin marketplace add rentspree/claude-plugins
  /plugin install rsp-plugins@rentspree
  ```
- **This is not**: a standalone application, library, or service — it is a Claude Code plugin marketplace composed entirely of markdown prompt files and shell scripts

## Repository Map

| Path | Responsibility |
|------|---------------|
| `.claude-plugin/marketplace.json` | Marketplace catalog — lists all available plugin packages |
| `plugins/<name>/` | Individual plugin package directory |
| `plugins/<name>/.claude-plugin/plugin.json` | Plugin metadata — required for Claude Code to recognize the plugin |
| `plugins/<name>/commands/` | Slash command definitions (`.md` files with YAML frontmatter) |
| `plugins/<name>/skills/` | Skill definitions — each skill is a directory containing `SKILL.md` and optional included files |
| `plugins/<name>/agents/` | Agent definitions (`.md` files with YAML frontmatter) |
| `plugins/<name>/hooks/` | Hook scripts (`.sh` files) — shell scripts for lifecycle events |

## Available Plugin Packages

| Package | Description |
|---------|-------------|
| `rsp-plugins` | Core RentSpree plugins — shared skills, commands, agents, and hooks |

## Development Workflow

This repo has no build step, dependencies, or test suite. Development consists of adding or editing markdown and shell files.

### Setup

```bash
gh repo clone rentspree/claude-plugins
```

### Testing locally

Install a plugin package in Claude Code and verify components appear:

```
/plugin marketplace add rentspree/claude-plugins
/plugin install rsp-plugins@rentspree
```

Or symlink for local development.

### Linting

No automated linting is configured. Validate YAML frontmatter manually.

## Architecture Overview

### Marketplace metadata

`.claude-plugin/marketplace.json` declares the marketplace name, description, author, version, and a list of available plugin packages with their paths.

### Plugin metadata

Each `plugins/<name>/.claude-plugin/plugin.json` declares the plugin name, description, author, and version. Claude Code reads this to register the plugin.

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
- Plugin packages: `plugins/<package-name>/`
- Commands: `plugins/<package>/commands/<command-name>.md`
- Skills: `plugins/<package>/skills/<skill-name>/SKILL.md`
- Agents: `plugins/<package>/agents/<agent-name>.md`
- Hooks: `plugins/<package>/hooks/<descriptive-trigger-name>.sh`

### Frontmatter

All markdown components use YAML frontmatter delimited by `---`. Required fields vary by component type (see CONTRIBUTING.md for the full reference table).

### Prompt style

- Write clear, imperative instructions
- Use numbered steps for multi-step workflows
- Specify constraints explicitly (e.g. "read-only", "do not create files")
- Keep prompts focused — one responsibility per component

## Adding a New Plugin Package

1. Create `plugins/<name>/.claude-plugin/plugin.json` with name, description, author, version
2. Add component directories as needed (`commands/`, `skills/`, `agents/`, `hooks/`)
3. Register the package in `.claude-plugin/marketplace.json` under the `plugins` array
4. Update the "Available Plugin Packages" table above and the "Available Plugins" table in `README.md`

## Legacy / Technical Debt

Current example components (`example-command`, `example-skill`, `example-agent`, `example-hook`) in `rsp-plugins` are scaffolding templates and should be replaced or supplemented with real plugins as they are built.

## Testing Expectations

There is no automated test suite. Verification is manual:

1. Install the plugin package via Claude Code
2. Confirm commands appear in `/help` or slash-command autocomplete
3. Run each component and verify expected behavior
4. For hooks, confirm they trigger on the registered lifecycle event

## Maintenance Contract

Update this file when:

- A new plugin package is added to the marketplace
- A new component type is introduced
- Naming conventions or frontmatter schema changes
- The marketplace or plugin metadata format evolves
- Major structural reorganization occurs
