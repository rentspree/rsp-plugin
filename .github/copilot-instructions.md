# Copilot PR Review Instructions

## Repository Overview

**Authoritative Reference**: See `AGENTS.md` in repository root for architecture, conventions, and patterns.

`claude-plugins` is a Claude Code plugin marketplace containing multiple plugin packages. Each package lives under `plugins/<name>/` and contains markdown prompt files and shell scripts. No application code, build system, or dependencies.

### Available Packages

| Package | Status |
|---------|--------|
| `rsp-plugins` | Available |
| `infra-plugins` | Planned |
| `data-plugins` | Planned |
| `design-plugins` | Planned |

## PR Review Checklist

### Marketplace Structure
- [ ] No components placed at root level — all components must live inside `plugins/<package>/`
- [ ] No new top-level directories created (only `plugins/`, `.claude-plugin/`, `.github/` exist at root)
- [ ] Plugin package follows the standard layout: `plugins/<package>/.claude-plugin/plugin.json` + component directories

### File Location
- [ ] Commands are in `plugins/<package>/commands/*.md`
- [ ] Skills are in `plugins/<package>/skills/<name>/SKILL.md`
- [ ] Agents are in `plugins/<package>/agents/*.md`
- [ ] Hooks are in `plugins/<package>/hooks/*.sh`
- [ ] No component files placed outside these directories (e.g. not in root `commands/`, `skills/`, `agents/`, `hooks/`)

### Plugin Package Metadata
- [ ] New packages have a valid `.claude-plugin/plugin.json` with `name`, `description`, `author`, `version`
- [ ] New packages are registered in root `.claude-plugin/marketplace.json` under the `plugins` array
- [ ] Package `name` in `plugin.json` matches the directory name under `plugins/`
- [ ] Package `version` matches the root `VERSION` file

### Frontmatter
- [ ] YAML frontmatter is present and valid (delimited by `---`)
- [ ] Required fields included for the component type:
  - Commands: `description`, `allowed-tools`
  - Skills: `name`, `description`, `allowed-tools`, `model`
  - Agents: `name`, `description`, `tools`, `model`
- [ ] `allowed-tools` or `tools` field specifies only necessary tools (principle of least privilege)
- [ ] `model` field uses a valid value (`sonnet`, `haiku`, `opus`) if specified

### Naming Conventions
- [ ] All file and directory names are **lowercase kebab-case**
- [ ] Plugin package names are kebab-case (e.g. `rsp-plugins`, `infra-plugins`)
- [ ] Command files: `<command-name>.md`
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
- [ ] Skills use `@include` for large prompts instead of monolithic files
- [ ] Each component has a single, clear responsibility
- [ ] Agents specify tool constraints (read-only agents should not have Write/Edit tools)

### Documentation
- [ ] `README.md` "Available Plugins" table updated if adding a new package
- [ ] `README.md` planned plugins table updated (status moved from "Planned" to "Available") for completed components
- [ ] `marketplace.json` updated if adding a new plugin package
- [ ] `AGENTS.md` "Available Plugin Packages" table updated if adding a new package
