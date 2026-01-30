# Ping Principal (Agent Skill)

An Agent Skill that enables AI agents to ask humans questions through native macOS dialogs. This is a skill-based reimplementation of [ping-principal-mcp](https://github.com/willwillems/ping-principal-mcp).

## What is this?

This is an [Agent Skill](https://agentskills.io) - a folder of instructions and scripts that AI agents can use to extend their capabilities. When installed, agents can show native macOS dialogs to:

- Ask text input questions
- Present multiple choice options
- Get yes/no confirmations
- Display information requiring acknowledgment
- Send system notifications

## Installation

Install via the skills CLI:

```bash
npx skills add willwillems/useuser
```

This will download and configure the skill for use with your AI agent.

## Requirements

- **macOS only** - Uses AppleScript for native dialogs
- A skills-compatible AI agent (Claude Code, Cursor, etc.)

## Dialog Types

### Text Input
```bash
scripts/ask_text.sh "What's the API endpoint?" "https://api.example.com" 300
```

### Multiple Choice
```bash
scripts/ask_choice.sh "Which database?" "PostgreSQL" "MySQL" "SQLite"
```

### Yes/No Confirmation
```bash
scripts/ask_confirm.sh "Delete these files?" "no" 300
```

### Information Display
```bash
scripts/show_info.sh "Operation completed successfully!"
```

### Notification
```bash
scripts/notify.sh "Build complete" "Dev Server" "Ready to test" "yes"
```

## How It Works

1. Agent encounters uncertainty or needs confirmation
2. Agent runs the appropriate dialog script
3. Native macOS dialog appears
4. User responds
5. Agent receives the response and continues

No complex setup, no server processes - just scripts that show dialogs.

## Documentation

See [SKILL.md](./SKILL.md) for complete documentation including:
- Detailed parameter descriptions
- Usage examples
- Error handling patterns
- Best practices

## Original MCP Version

This skill is based on [ping-principal-mcp](https://github.com/willwillems/ping-principal-mcp), which implements the same functionality as an MCP server. Use the MCP version if you need:
- Real-time tool integration via MCP protocol
- Compatibility with MCP-only clients

Use this skill version if you want:
- Simpler installation via `npx skills add`
- No background server process
- Compatibility with skills-enabled agents

## License

MIT - See [LICENSE](./LICENSE)
