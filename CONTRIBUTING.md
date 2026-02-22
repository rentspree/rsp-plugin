# Contributing to claude-plugins

## Adding a New Plugin Package

1. Create `plugins/<package-name>/.claude-plugin/plugin.json`:

```json
{
  "name": "package-name",
  "description": "What this plugin package provides.",
  "author": "RentSpree Engineering",
  "version": "0.1.0"
}
```

2. Create component directories as needed (`commands/`, `skills/`, `agents/`, `hooks/`).
3. Add the package to `.claude-plugin/marketplace.json` under the `plugins` array.
4. Update the "Available Plugins" table in `README.md`.

## Adding Components to an Existing Package

All components go under `plugins/<package-name>/`.

### Command

1. Create `plugins/<package>/commands/<command-name>.md`
2. Add frontmatter:

```yaml
---
description: What the command does.
allowed-tools: Read, Glob, Grep
argument-hint: "[optional args]"
---
```

3. Write the prompt body below the frontmatter.

### Skill

1. Create `plugins/<package>/skills/<skill-name>/SKILL.md`
2. Add frontmatter:

```yaml
---
name: skill-name
description: What the skill does.
allowed-tools: Read, Glob, Grep, Write, Edit
model: sonnet
---
```

3. Write the prompt body. Use `@include ./FILE.md` to split large prompts across files.
4. Optionally add supporting files (e.g. `CONVENTIONS.md`) in the same directory.

### Agent

1. Create `plugins/<package>/agents/<agent-name>.md`
2. Add frontmatter:

```yaml
---
name: agent-name
description: What the agent does.
tools: Read, Glob, Grep
model: haiku
---
```

3. Write the agent's system prompt. Specify constraints (read-only, scoped tools, etc.).

### Hook

1. Create `plugins/<package>/hooks/<hook-name>.sh`
2. Start with `#!/usr/bin/env bash`
3. Read the event JSON from stdin using `event=$(cat)`
4. Parse fields with `jq` (e.g. `echo "$event" | jq -r '.tool_name'`)
5. Document the registration snippet in a comment at the top of the file.

## Naming Conventions

- **Plugin packages**: lowercase, kebab-case (e.g. `rsp-plugins`, `infra-plugins`)
- **Commands**: lowercase, kebab-case (e.g. `morning-brew.md`)
- **Skills**: lowercase, kebab-case directory name (e.g. `skills/gen-mds/`)
- **Agents**: lowercase, kebab-case (e.g. `mds-updater.md`)
- **Hooks**: lowercase, kebab-case, descriptive of trigger (e.g. `post-write-lint.sh`)

## Frontmatter Reference

| Field | Used In | Description |
|-------|---------|-------------|
| `name` | Skills, Agents | Identifier used to invoke the component |
| `description` | All | Short description shown in help/discovery |
| `allowed-tools` | Commands, Skills | Tools the component can use |
| `tools` | Agents | Tools available to the agent |
| `model` | Skills, Agents | Preferred model (`sonnet`, `haiku`, `opus`) |
| `argument-hint` | Commands | Hint shown for command arguments |

## PR Checklist

- [ ] File is in the correct plugin package directory (`plugins/<package>/`)
- [ ] File is in the correct component directory (`commands/`, `skills/`, `agents/`, or `hooks/`)
- [ ] Frontmatter is valid YAML with required fields
- [ ] Description is clear and concise
- [ ] Component has been tested locally (install plugin, run component)
- [ ] README.md catalog table is updated (move from "Planned" to "Available")
- [ ] No secrets or credentials in the plugin files
- [ ] If adding a new package, marketplace.json is updated
