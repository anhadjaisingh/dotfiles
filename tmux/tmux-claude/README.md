# tmux-claude-status

A tmux plugin that shows per-window indicators when [Claude Code](https://claude.ai/claude-code) is waiting for your input.

## The Problem

When running multiple Claude Code sessions across tmux windows, it's hard to tell which sessions need your attention vs. which are still processing.

## The Solution

Uses Claude Code hooks to set tmux window status instantly:
- **Waiting for input**: Bold bright white text + `▲`
- **Busy processing**: Orange text + `✽`
- **No Claude**: Normal window style
- **Current window**: Underlined

Windows needing your attention stand out with bold bright text and prominent symbols.

## Installation

### Quick Install

```bash
# 1. Clone or download this directory to ~/.tmux/tmux-claude/
git clone https://github.com/anhadjaisingh/dotfiles.git /tmp/dotfiles
mkdir -p ~/.tmux
cp -r /tmp/dotfiles/tmux/tmux-claude ~/.tmux/

# 2. Add to your ~/.tmux.conf
echo 'source-file ~/.tmux/tmux-claude/claude-status.conf' >> ~/.tmux.conf

# 3. Reload tmux config
tmux source-file ~/.tmux.conf
```

### Manual Setup

#### 1. Set up tmux config

Copy the `tmux-claude` directory to `~/.tmux/`:

```bash
mkdir -p ~/.tmux
cp -r tmux-claude ~/.tmux/
```

Add to your `~/.tmux.conf`:

```tmux
source-file ~/.tmux/tmux-claude/claude-status.conf
```

#### 2. Configure Claude Code hooks

Edit `~/.claude/settings.json` and add the following hooks (merge with existing hooks if you have any):

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
    ],
    "SessionEnd": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "tmux set-option -t \"$TMUX_PANE\" -wu @claude-status 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

#### 3. Reload and test

Reload your tmux configuration:

```bash
tmux source-file ~/.tmux.conf
```

**Important**: The hooks only apply to new Claude Code sessions. Exit and restart any running Claude sessions for the indicators to work.

To test: Start a new Claude session in a tmux window, and you should see the `✽` symbol appear when Claude is processing, and `▲` when it's waiting for your input.

## Troubleshooting

**Indicators not showing up?**
1. Make sure you've reloaded tmux: `tmux source-file ~/.tmux.conf`
2. Exit and restart your Claude Code session (hooks only apply to new sessions)
3. Check that `~/.claude/settings.json` has the hooks configured correctly
4. Verify you're running Claude inside a tmux session

**Hooks not working in existing Claude sessions?**
- The hooks are configured when Claude starts. You must exit and restart Claude for them to take effect.

**Want to test manually?**
```bash
# Set a window to waiting state
tmux set-option -w @claude-status waiting

# Set a window to busy state
tmux set-option -w @claude-status busy

# Clear the status
tmux set-option -wu @claude-status
```

## How It Works

Claude Code hooks trigger tmux commands:
- `UserPromptSubmit` → sets `@claude-status` to `busy`
- `Notification` → sets `@claude-status` to `waiting`
- `Stop` → sets `@claude-status` to `waiting`
- `SessionEnd` → clears `@claude-status` (removes indicator when Claude exits)

The tmux status format reads `@claude-status` and displays the appropriate indicator with styling.

## Requirements

- tmux 3.0+ (for conditional formatting support)
- Claude Code CLI with hooks support
- A terminal with UTF-8 support (for symbols ▲ and ✽)

## License

MIT
