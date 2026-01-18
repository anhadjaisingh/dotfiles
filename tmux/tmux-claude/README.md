# tmux-claude-status

A tmux plugin that shows per-window indicators when [Claude Code](https://claude.ai/claude-code) is waiting for your input.

## The Problem

When running multiple Claude Code sessions across tmux windows, it's hard to tell which sessions need your attention vs. which are still processing.

## The Solution

Uses Claude Code hooks to set tmux window status instantly:
- `●` (bright, highlighted) — Claude is waiting for input
- `○` (dim) — Claude is busy processing
- No indicator — No Claude session in that window

```
1:api  2:frontend●  3:docs○  4:logs
        ^waiting    ^busy
```

## Installation

### 1. Set up tmux config

Copy or symlink `tmux-claude` to `~/.tmux/tmux-claude/`:

```bash
mkdir -p ~/.tmux
cp -r tmux-claude ~/.tmux/
```

Add to your `~/.tmux.conf`:

```tmux
source-file ~/.tmux/tmux-claude/claude-status.conf
```

### 2. Configure Claude Code hooks

Add these hooks to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "tmux set-option -w @claude-status busy 2>/dev/null || true"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "tmux set-option -w @claude-status waiting 2>/dev/null || true"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "tmux set-option -w @claude-status waiting 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### 3. Reload

```bash
tmux source-file ~/.tmux.conf
```

New Claude sessions will show indicators automatically.

## Configuration

### Style Toggle

The waiting indicator can be white or magenta. Run in tmux command mode (`prefix` + `:`):

| Command | Description |
|---------|-------------|
| `claude-style-white` | Use white indicator |
| `claude-style-magenta` | Use magenta indicator |

Or set in your `.tmux.conf` before sourcing the plugin:

```tmux
set-option -g @claude-status-style "magenta"
```

## How It Works

Claude Code hooks trigger tmux commands:
- `UserPromptSubmit` → sets `@claude-status` to `busy`
- `Notification` → sets `@claude-status` to `waiting`
- `Stop` → sets `@claude-status` to `waiting`

The tmux status format reads `@claude-status` and displays the appropriate indicator.

## Requirements

- tmux 3.0+
- Claude Code CLI with hooks support

## License

MIT
