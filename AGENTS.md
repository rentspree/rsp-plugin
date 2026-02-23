# AGENTS.md

## Purpose & Authority

This file is the **canonical source of truth** for the `claude-plugins` repository. All AI tools and human contributors should reference this document.

Tool-specific files (CLAUDE.md, copilot-instructions.md) must not contradict it.

## Project Summary

`claude-plugins` is the official Claude Code plugin marketplace for the RentSpree engineering team. It provides a centralized, version-controlled collection of plugin packages, each containing shared skills, agents, and hooks that extend Claude Code's capabilities for RentSpree-specific workflows.

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
| `plugins/<name>/skills/` | Skill definitions — each skill is a directory containing `SKILL.md` and optional supporting files. Covers both auto-invoked skills and manual `/command`-style skills |
| `plugins/<name>/agents/` | Agent definitions (`.md` files with YAML frontmatter) |
| `plugins/<name>/hooks/` | Hook scripts (`.sh` files) — shell scripts for lifecycle events |

> **Note:** Custom commands have been merged into skills. There is no separate `commands/` directory. Skills with `disable-model-invocation: true` behave as manual commands (only triggered via `/skill-name`).

## Available Plugin Packages

| Package | Description |
|---------|-------------|
| `rsp-plugins` | Core RentSpree plugins — shared skills, agents, and hooks |

Teams can freely create new packages following the `<domain>-plugins` or `<bu>-plugins` naming convention.

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

**Skills** (`skills/<name>/SKILL.md`):
- YAML frontmatter with `name`, `description`, and optional fields (`allowed-tools`, `model`, `disable-model-invocation`, `user-invocable`, `context`, `agent`, `argument-hint`)
- Each skill is a directory with `SKILL.md` as the entrypoint and optional supporting files (templates, examples, scripts)
- Support `@include ./FILE.md` to compose prompts from multiple files
- Two categories:
  - **Reference skills** — conventions and knowledge Claude applies automatically when relevant
  - **Task skills** — step-by-step workflows invoked manually via `/skill-name` (set `disable-model-invocation: true`)

**Agents** (`agents/*.md`):
- YAML frontmatter with `name`, `description`, `tools`, `model`
- Define autonomous sub-agents with scoped tool access

**Hooks** (`hooks/*.sh`):
- Bash scripts that read JSON event data from stdin
- Must be registered in Claude Code settings under lifecycle event keys (e.g. `PostToolUse`)

### Advanced skill patterns

- **Dynamic context injection**: Use `` !`command` `` syntax to run shell commands before the skill content is sent to Claude. The output replaces the placeholder.
- **Subagent execution**: Set `context: fork` to run a skill in an isolated subagent. Combine with `agent: Explore` (or other agent types) to control the execution environment.
- **Invocation control**:
  - `disable-model-invocation: true` — only the user can invoke (for workflows with side effects)
  - `user-invocable: false` — only Claude can invoke (for background knowledge)
- **String substitutions**: `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N`, `${CLAUDE_SESSION_ID}`

### How hooks differ from other components

Skills and agents are prompt-based and invoked within Claude Code's conversation context. Hooks are external shell scripts that run outside the conversation — they react to lifecycle events, receive structured JSON on stdin, and output warnings or feedback to stderr/stdout.

## Conventions & Patterns

### Naming

- All file and directory names use **lowercase kebab-case**
- Plugin packages: `plugins/<domain>-plugins/` or `plugins/<bu>-plugins/`
- Skills: `plugins/<package>/skills/<skill-name>/SKILL.md`
- Agents: `plugins/<package>/agents/<agent-name>.md`
- Hooks: `plugins/<package>/hooks/<descriptive-trigger-name>.sh`

### Skill directory layout

```
my-skill/
├── SKILL.md           # Main instructions (required, keep under 500 lines)
├── template.md        # Template for Claude to fill in
├── examples/
│   └── sample.md      # Example output showing expected format
└── scripts/
    └── validate.sh    # Script Claude can execute
```

### Frontmatter

All markdown components use YAML frontmatter delimited by `---`. See CONTRIBUTING.md for the full reference table.

### Prompt style

- Write clear, imperative instructions
- Use numbered steps for multi-step workflows
- Specify constraints explicitly (e.g. "read-only", "do not create files")
- Keep prompts focused — one responsibility per component

## Adding a New Plugin Package

Any team can create a new package. Use the naming convention `<domain>-plugins` or `<bu>-plugins` (e.g. `payment-plugins`, `screening-plugins`, `infra-plugins`).

1. Create `plugins/<name>/.claude-plugin/plugin.json` with name, description, author, version
2. Add component directories as needed (`skills/`, `agents/`, `hooks/`)
3. Register the package in `.claude-plugin/marketplace.json` under the `plugins` array
4. Update the "Available Plugin Packages" table above and the "Available Plugins" table in `README.md`

## Legacy / Technical Debt

Current example components (`example-skill`, `example-command`, `example-agent`, `example-hook`) in `rsp-plugins` are scaffolding templates and should be replaced or supplemented with real plugins as they are built.

## Testing Expectations

There is no automated test suite. Verification is manual:

1. Install the plugin package via Claude Code
2. Confirm skills appear in `/help` or slash-command autocomplete
3. Run each component and verify expected behavior
4. For hooks, confirm they trigger on the registered lifecycle event

## Maintenance Contract

Update this file when:

- A new plugin package is added to the marketplace
- A new component type is introduced
- Naming conventions or frontmatter schema changes
- The marketplace or plugin metadata format evolves
- Major structural reorganization occurs
