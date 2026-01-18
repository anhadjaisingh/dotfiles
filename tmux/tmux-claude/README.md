# tmux-claude-status

A tmux plugin that shows per-window indicators when [Claude Code](https://claude.ai/claude-code) is waiting for your input.

## The Problem

When running multiple Claude Code sessions across tmux windows, it's hard to tell which sessions need your attention vs. which are still processing.

## The Solution

Uses Claude Code hooks to set tmux window status instantly:
- **Waiting for input**: Black background + white text + `●`
- **Busy processing**: Orange background + black text + `○`
- **No Claude**: Normal window style

Windows needing your attention stand out with inverted colors.

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
            "command": "tmux set-option -t \"$TMUX_PANE\" -w @claude-status busy 2>/dev/null || true"
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
            "command": "tmux set-option -t \"$TMUX_PANE\" -w @claude-status waiting 2>/dev/null || true"
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
            "command": "tmux set-option -t \"$TMUX_PANE\" -w @claude-status waiting 2>/dev/null || true"
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
