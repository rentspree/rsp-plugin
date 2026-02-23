# claude-plugins

RentSpree Claude Code Plugin Marketplace — a collection of plugin packages for the RentSpree engineering team. Developers install only the plugins they need.

## Install

```
# Add the marketplace
/plugin marketplace add rentspree/claude-plugins

# Install a specific plugin package
/plugin install rsp-plugins@rentspree
```

## Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json             # Marketplace catalog (required)
├── plugins/
│   ├── rsp-plugins/                 # Core RentSpree plugins
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json          # Plugin metadata (required)
│   │   ├── skills/
│   │   │   ├── example-skill/
│   │   │   │   ├── SKILL.md         # Skill with supporting files
│   │   │   │   └── CONVENTIONS.md   # Supporting file (@include)
│   │   │   └── example-command/
│   │   │       └── SKILL.md         # User-invoked skill (disable-model-invocation)
│   │   ├── agents/
│   │   │   └── example-agent.md     # Autonomous agents
│   │   └── hooks/
│   │       └── example-hook.sh      # Lifecycle hook scripts
│   ├── infra-plugins/               # Infrastructure & DevOps plugins (planned)
│   │   └── ...
│   ├── data-plugins/                # Data engineering & analytics plugins (planned)
│   │   └── ...
│   └── design-plugins/              # Design system & UI plugins (planned)
│       └── ...
├── .github/
│   ├── workflows/
│   │   ├── version-bump.yaml
│   │   └── default-label.yaml
│   └── copilot-instructions.md
├── VERSION
├── AGENTS.md
├── CLAUDE.md
├── README.md
└── CONTRIBUTING.md
```

## Available Plugins

| Package | Description | Status | Install |
|---------|-------------|--------|---------|
| `rsp-plugins` | Core RentSpree plugins — skills, agents, and hooks | Available | `/plugin install rsp-plugins@rentspree` |
| `infra-plugins` | Infrastructure & DevOps plugins | Planned | — |
| `data-plugins` | Data engineering & analytics plugins | Planned | — |
| `design-plugins` | Design system & UI plugins | Planned | — |

Teams can freely create new plugin packages following the `<domain>-plugins` or `<bu>-plugins` naming convention (e.g. `payment-plugins`, `screening-plugins`). See [Adding a New Plugin Package](#adding-a-new-plugin-package).

## Component Types

| Type | Location | Trigger | Description |
|------|----------|---------|-------------|
| **Skill** | `skills/<name>/SKILL.md` | User runs `/skill-name`, or Claude invokes automatically | Reusable prompt modules with supporting files |
| **Agent** | `agents/*.md` | Spawned via `Task` tool | Autonomous sub-agents with scoped tools |
| **Hook** | `hooks/*.sh` | Lifecycle events (e.g. PostToolUse) | Shell scripts that react to Claude Code events |

> **Note:** Custom slash commands have been merged into skills. A skill with `disable-model-invocation: true` behaves like a manual command — only triggered by `/skill-name`. Existing `commands/*.md` files still work but new components should use the skills format.

### Skill types

Skills can serve two purposes:

- **Reference skills** — conventions, patterns, domain knowledge that Claude applies to your work. Claude loads these automatically when relevant.
- **Task skills** — step-by-step workflows (deploy, commit, generate). Set `disable-model-invocation: true` so they only run when you invoke `/skill-name`.

### Skill directory layout

Each skill is a directory with `SKILL.md` as the entrypoint and optional supporting files:

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── template.md        # Template for Claude to fill in
├── examples/
│   └── sample.md      # Example output showing expected format
└── scripts/
    └── validate.sh    # Script Claude can execute
```

Keep `SKILL.md` under 500 lines. Move detailed reference material to separate files and reference them from `SKILL.md`.

### How hooks differ

Hooks are **not** invoked by the user or agent directly. They are shell scripts registered in Claude Code settings that run automatically in response to lifecycle events (e.g. after a tool is used). They receive event data as JSON on stdin and can provide warnings or feedback.

## Roadmap

New skills, agents, and hooks will be gradually added based on the most upvoted ideas from the **AI Tips & Tricks** channel. Have a workflow you'd like automated? Upvote it there and the team will prioritize it.

### Planned Plugins (rsp-plugins)

| Name | Type | Status | Notion |
|------|------|--------|--------|
| `/cpr` | Skill | Planned | [link](https://www.notion.so/2e23b0bdee3e8005a6afe1cd4b30b59e) |
| `/gen-mds` | Skill | Planned | [link](https://www.notion.so/2e63b0bdee3e8156851ed6f5df824bd1) |
| `/clip` | Skill | Planned | [link](https://www.notion.so/30c3b0bdee3e80fd9cf5c56c9bc02367) |
| `/adr` | Skill | Planned | — |
| `/tic-master` | Skill | Planned | — |
| `/morning-brew` | Skill | Planned | — |
| `/ticket` | Skill | Planned | [link](https://www.notion.so/2f13b0bdee3e804ebf52d5c84cf1e8d1) |
| `committer` | Agent | Planned | — |
| `mds-updater` | Agent | Planned | — |
| Auto-Format/Lint | Hook | Planned | [link](https://www.notion.so/30a3b0bdee3e8029b34ac9617218373a) |

## Adding a New Plugin Package

Any team can create a new plugin package. Use the naming convention `<domain>-plugins` or `<bu>-plugins` (e.g. `payment-plugins`, `screening-plugins`, `infra-plugins`).

1. Create `plugins/<name>/.claude-plugin/plugin.json`
2. Add component directories (`skills/`, `agents/`, `hooks/`)
3. Register the plugin in `.claude-plugin/marketplace.json`
4. Update the "Available Plugins" table above

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to add new components.
