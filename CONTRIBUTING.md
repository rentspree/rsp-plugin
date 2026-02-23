# Contributing to claude-plugins

## Adding a New Plugin Package

Any team can create a new plugin package. Use the naming convention `<domain>-plugins` or `<bu>-plugins` (e.g. `payment-plugins`, `screening-plugins`, `infra-plugins`).

1. Create `plugins/<package-name>/.claude-plugin/plugin.json`:

```json
{
  "name": "package-name",
  "description": "What this plugin package provides.",
  "author": "RentSpree Engineering",
  "version": "0.1.0"
}
```

2. Create component directories as needed (`skills/`, `agents/`, `hooks/`).
3. Add the package to `.claude-plugin/marketplace.json` under the `plugins` array.
4. Update the "Available Plugins" table in `README.md`.

## Adding Components to an Existing Package

All components go under `plugins/<package-name>/`.

### Skill

Each skill is a directory with `SKILL.md` as the entrypoint and optional supporting files.

1. Create `plugins/<package>/skills/<skill-name>/SKILL.md`
2. Add frontmatter:

```yaml
---
name: skill-name
description: What the skill does and when to use it.
allowed-tools: Read, Glob, Grep, Write, Edit
model: sonnet
---
```

3. Write the prompt body.
4. Optionally add supporting files in the same directory (templates, examples, scripts) and reference them from `SKILL.md`.
5. Use `@include ./FILE.md` to compose prompts from multiple files.

#### Skill directory layout

```
my-skill/
├── SKILL.md           # Main instructions (required, keep under 500 lines)
├── template.md        # Template for Claude to fill in
├── examples/
│   └── sample.md      # Example output showing expected format
└── scripts/
    └── validate.sh    # Script Claude can execute
```

#### Skill types

**Reference skills** — conventions, patterns, or domain knowledge that Claude applies automatically when relevant:

```yaml
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
```

**Task skills** — step-by-step workflows you invoke manually with `/skill-name`. Set `disable-model-invocation: true` to prevent Claude from triggering them automatically:

```yaml
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

**Background knowledge** — context that Claude should know but users shouldn't invoke directly. Set `user-invocable: false`:

```yaml
---
name: legacy-system-context
description: How the legacy billing system works
user-invocable: false
---

The legacy billing system uses...
```

#### Advanced patterns

**Dynamic context injection** — run shell commands before the skill content is sent to Claude using `` !`command` `` syntax:

```yaml
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`

## Your task
Summarize this pull request...
```

**Subagent execution** — run a skill in an isolated context with `context: fork`:

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

> **Note on commands:** Custom slash commands have been merged into skills. A file at `commands/<name>.md` and a skill at `skills/<name>/SKILL.md` both create the same `/name` command. Existing `commands/` files keep working, but all new components should use the skills format.

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

- **Plugin packages**: `<domain>-plugins` or `<bu>-plugins`, lowercase kebab-case (e.g. `rsp-plugins`, `infra-plugins`, `payment-plugins`)
- **Skills**: lowercase, kebab-case directory name (e.g. `skills/gen-mds/`)
- **Agents**: lowercase, kebab-case (e.g. `mds-updater.md`)
- **Hooks**: lowercase, kebab-case, descriptive of trigger (e.g. `post-write-lint.sh`)

## Frontmatter Reference

### Skills

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Display name and `/slash-command`. Defaults to directory name. Lowercase letters, numbers, hyphens only (max 64 chars) |
| `description` | Recommended | What the skill does and when to use it. Claude uses this to decide when to apply the skill automatically |
| `argument-hint` | No | Hint shown during autocomplete (e.g. `[issue-number]`, `[filename] [format]`) |
| `disable-model-invocation` | No | `true` to prevent Claude from auto-loading this skill. For manual-only workflows. Default: `false` |
| `user-invocable` | No | `false` to hide from `/` menu. For background knowledge. Default: `true` |
| `allowed-tools` | No | Tools Claude can use without asking permission when skill is active |
| `model` | No | Preferred model (`sonnet`, `haiku`, `opus`) |
| `context` | No | `fork` to run in an isolated subagent context |
| `agent` | No | Subagent type when `context: fork` is set (e.g. `Explore`, `Plan`, `general-purpose`, or custom) |

### Agents

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Identifier used to invoke the agent |
| `description` | Yes | Short description shown in help/discovery |
| `tools` | Yes | Tools available to the agent |
| `model` | No | Preferred model (`sonnet`, `haiku`, `opus`) |

### String substitutions (skills)

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed when invoking the skill |
| `$ARGUMENTS[N]` / `$N` | Access a specific argument by 0-based index |
| `${CLAUDE_SESSION_ID}` | Current session ID |

## PR Checklist

- [ ] File is in the correct plugin package directory (`plugins/<package>/`)
- [ ] File is in the correct component directory (`skills/`, `agents/`, or `hooks/`)
- [ ] Plugin package name follows `<domain>-plugins` or `<bu>-plugins` convention
- [ ] Frontmatter is valid YAML with required fields
- [ ] Description is clear and concise
- [ ] `disable-model-invocation: true` is set for task/command-style skills with side effects
- [ ] `SKILL.md` is under 500 lines (move reference material to supporting files)
- [ ] Component has been tested locally (install plugin, run component)
- [ ] README.md catalog table is updated (move from "Planned" to "Available")
- [ ] No secrets or credentials in the plugin files
- [ ] If adding a new package, marketplace.json is updated
- [ ] New skill/agent shared on the **AI Tips & Tricks** Notion page
- [ ] New skill/agent shared in **#coi-ai-coding** on Slack
