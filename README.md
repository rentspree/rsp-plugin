# rsp-plugin

RentSpree Claude Code Plugin — shared skills, commands, agents, and hooks for the RentSpree engineering team.

## Install

```
/plugin install rsp-plugin@rentspree
```

## Structure

```
rsp-plugin/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata (required)
├── commands/
│   └── example-command.md       # Slash commands (e.g. /morning-brew)
├── skills/
│   └── example-skill/
│       ├── SKILL.md             # Skills with @include support
│       └── CONVENTIONS.md       # Included conventions file
├── agents/
│   └── example-agent.md         # Autonomous agents
├── hooks/
│   └── example-hook.sh          # Lifecycle hook scripts
├── README.md
└── CONTRIBUTING.md
```

## Component Types

| Type | Location | Trigger | Description |
|------|----------|---------|-------------|
| **Command** | `commands/*.md` | User runs `/command-name` | One-shot prompts with tool access |
| **Skill** | `skills/*/SKILL.md` | User runs `/skill-name` or agent invokes | Reusable prompt modules, support `@include` |
| **Agent** | `agents/*.md` | Spawned via `Task` tool | Autonomous sub-agents with scoped tools |
| **Hook** | `hooks/*.sh` | Lifecycle events (e.g. PostToolUse) | Shell scripts that react to Claude Code events |

### How hooks differ

Hooks are **not** invoked by the user or agent directly. They are shell scripts registered in Claude Code settings that run automatically in response to lifecycle events (e.g. after a tool is used). They receive event data as JSON on stdin and can provide warnings or feedback.

## Planned Plugins

| Name | Type | Status | Notion |
|------|------|--------|--------|
| `/cpr` | Skill | Planned | [link](https://www.notion.so/2e23b0bdee3e8005a6afe1cd4b30b59e) |
| `/gen-mds` | Skill | Planned | [link](https://www.notion.so/2e63b0bdee3e8156851ed6f5df824bd1) |
| `/clip` | Skill | Planned | [link](https://www.notion.so/30c3b0bdee3e80fd9cf5c56c9bc02367) |
| `/adr` | Skill | Planned | — |
| `/tic-master` | Skill | Planned | — |
| `morning-brew` | Command | Planned | — |
| `ticket` | Command | Planned | [link](https://www.notion.so/2f13b0bdee3e804ebf52d5c84cf1e8d1) |
| `committer` | Agent | Planned | — |
| `mds-updater` | Agent | Planned | — |
| Auto-Format/Lint | Hook | Planned | [link](https://www.notion.so/30a3b0bdee3e8029b34ac9617218373a) |

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to add new plugins.
