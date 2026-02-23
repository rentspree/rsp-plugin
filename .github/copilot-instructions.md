# Copilot PR Review Instructions

## Repository Overview

**Authoritative Reference**: See `AGENTS.md` in repository root for architecture, conventions, and patterns.

`claude-plugins` is a Claude Code plugin marketplace containing multiple plugin packages. Each package lives under `plugins/<name>/` and contains markdown prompt files and shell scripts. No application code, build system, or dependencies.

> **Note:** Custom commands have been merged into skills. There is no separate `commands/` directory. Skills with `disable-model-invocation: true` behave as manual commands.

### Available Packages

| Package | Status |
|---------|--------|
| `rsp-plugins` | Available |
| `infra-plugins` | Planned |
| `data-plugins` | Planned |
| `design-plugins` | Planned |

Teams can freely create new packages following the `<domain>-plugins` or `<bu>-plugins` naming convention.

## PR Review Checklist

### Marketplace Structure
- [ ] No components placed at root level — all components must live inside `plugins/<package>/`
- [ ] No new top-level directories created (only `plugins/`, `.claude-plugin/`, `.github/` exist at root)
- [ ] Plugin package follows the standard layout: `plugins/<package>/.claude-plugin/plugin.json` + component directories
- [ ] Plugin package name follows `<domain>-plugins` or `<bu>-plugins` naming convention

### File Location
- [ ] Skills are in `plugins/<package>/skills/<name>/SKILL.md`
- [ ] Agents are in `plugins/<package>/agents/*.md`
- [ ] Hooks are in `plugins/<package>/hooks/*.sh`
- [ ] No `commands/` directory used — commands should be skills with `disable-model-invocation: true`
- [ ] No component files placed outside expected directories

### Plugin Package Metadata
- [ ] New packages have a valid `.claude-plugin/plugin.json` with `name`, `description`, `author`, `version`
- [ ] New packages are registered in root `.claude-plugin/marketplace.json` under the `plugins` array
- [ ] Package `name` in `plugin.json` matches the directory name under `plugins/`
- [ ] Package `version` matches the root `VERSION` file

### Skill Frontmatter
- [ ] YAML frontmatter is present and valid (delimited by `---`)
- [ ] `description` is provided and explains when Claude should use the skill
- [ ] `allowed-tools` specifies only necessary tools (principle of least privilege)
- [ ] `model` field uses a valid value (`sonnet`, `haiku`, `opus`) if specified
- [ ] `disable-model-invocation: true` is set for task/command-style skills with side effects (deploy, commit, send messages)
- [ ] `user-invocable: false` is set for background knowledge skills that shouldn't appear in `/` menu
- [ ] `context: fork` and `agent` field are used correctly if skill runs in a subagent

### Skill Structure
- [ ] `SKILL.md` is under 500 lines — detailed reference material moved to supporting files
- [ ] Supporting files are referenced from `SKILL.md` so Claude knows when to load them
- [ ] `` !`command` `` dynamic context injection is used correctly (commands run before skill is sent to Claude)

### Agent Frontmatter
- [ ] Required fields: `name`, `description`, `tools`
- [ ] `tools` field specifies only necessary tools
- [ ] Read-only agents do not have Write/Edit tools

### Naming Conventions
- [ ] All file and directory names are **lowercase kebab-case**
- [ ] Plugin package names follow `<domain>-plugins` or `<bu>-plugins` convention
- [ ] Skill directories: `<skill-name>/SKILL.md`
- [ ] Agent files: `<agent-name>.md`
- [ ] Hook files: `<hook-name>.sh`
- [ ] Names are descriptive of the component's purpose

### Content Quality
- [ ] Prompt is clear, specific, and imperative
- [ ] No secrets, credentials, or internal URLs in prompt content
- [ ] No generic boilerplate — content is RentSpree-specific
- [ ] Hook scripts use `#!/usr/bin/env bash` shebang
- [ ] Hook scripts read stdin JSON and parse with `jq`
- [ ] No runtime dependencies added — hooks rely only on standard unix tools and `jq`

### Convention Guards
- [ ] No application code, libraries, or services added to this repo
- [ ] No build system, package manager, or test framework introduced
- [ ] Each component has a single, clear responsibility
- [ ] No new `commands/` directories — use skills instead

### Documentation
- [ ] `README.md` "Available Plugins" table updated if adding a new package
- [ ] `README.md` planned plugins table updated (status moved from "Planned" to "Available") for completed components
- [ ] `marketplace.json` updated if adding a new plugin package
- [ ] `AGENTS.md` "Available Plugin Packages" table updated if adding a new package
