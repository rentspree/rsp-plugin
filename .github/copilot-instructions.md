# Copilot PR Review Instructions

## Repository Overview

**Authoritative Reference**: See `AGENTS.md` in repository root for architecture, conventions, and patterns.

`claude-plugins` is a Claude Code plugin marketplace containing multiple plugin packages. Each package lives under `plugins/<name>/` and contains markdown prompt files and shell scripts. No application code, build system, or dependencies.

## PR Review Checklist

### File Location
- [ ] Components are inside a valid plugin package (`plugins/<package>/`)
- [ ] Commands are in `plugins/<package>/commands/*.md`
- [ ] Skills are in `plugins/<package>/skills/<name>/SKILL.md`
- [ ] Agents are in `plugins/<package>/agents/*.md`
- [ ] Hooks are in `plugins/<package>/hooks/*.sh`
- [ ] No files placed outside the expected directories

### Plugin Package
- [ ] New packages have a valid `.claude-plugin/plugin.json`
- [ ] New packages are registered in `.claude-plugin/marketplace.json`

### Frontmatter
- [ ] YAML frontmatter is present and valid
- [ ] Required fields included for the component type (`description` for commands, `name`/`description` for skills and agents)
- [ ] `allowed-tools` or `tools` field specifies only necessary tools (principle of least privilege)
- [ ] `model` field uses a valid value (`sonnet`, `haiku`, `opus`) if specified

### Naming
- [ ] File and directory names are lowercase kebab-case
- [ ] Names are descriptive of the component's purpose

### Content Quality
- [ ] Prompt is clear, specific, and imperative
- [ ] No secrets, credentials, or internal URLs in prompt content
- [ ] No generic boilerplate — content is RentSpree-specific
- [ ] Hook scripts use `#!/usr/bin/env bash` shebang
- [ ] Hook scripts read stdin JSON and parse with `jq`

### Documentation
- [ ] `README.md` catalog table updated if adding a new component or package
- [ ] Status moved from "Planned" to "Available" for completed plugins
- [ ] `marketplace.json` updated if adding a new plugin package
