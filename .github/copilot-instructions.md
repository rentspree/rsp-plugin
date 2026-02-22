# Copilot PR Review Instructions

## Repository Overview

**Authoritative Reference**: See `AGENTS.md` in repository root for architecture, conventions, and patterns.

`rsp-plugin` is a Claude Code plugin containing markdown prompt files and shell scripts. No application code, build system, or dependencies.

## PR Review Checklist

### File Location
- [ ] Commands are in `commands/*.md`
- [ ] Skills are in `skills/<name>/SKILL.md`
- [ ] Agents are in `agents/*.md`
- [ ] Hooks are in `hooks/*.sh`
- [ ] No files placed outside the expected directories

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
- [ ] `README.md` catalog table updated if adding a new component
- [ ] Status moved from "Planned" to "Available" for completed plugins
