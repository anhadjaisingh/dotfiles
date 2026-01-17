# tmux-claude-status

A tmux plugin that shows per-window indicators when [Claude Code](https://claude.ai/claude-code) is waiting for your input.

## The Problem

When running multiple Claude Code sessions across tmux windows, it's hard to tell which sessions need your attention vs. which are still processing.

## The Solution

A simple status line indicator:
- `●` (bright, highlighted) — Claude is waiting for input
- `○` (dim) — Claude is busy processing
- No indicator — No Claude session in that window

```
1:api  2:frontend●  3:docs○  4:logs
        ^waiting    ^busy
```

## Installation

1. Clone or copy the `tmux-claude` directory to `~/.tmux/tmux-claude/`:

```bash
mkdir -p ~/.tmux
cp -r tmux-claude ~/.tmux/
chmod +x ~/.tmux/tmux-claude/claude-status.sh
```

2. Add to your `~/.tmux.conf`:

```tmux
source-file ~/.tmux/tmux-claude/claude-status.conf
```

3. Reload tmux config:

```bash
tmux source-file ~/.tmux.conf
```

## Configuration

### Style Toggle

The waiting indicator can be white or magenta. Toggle with:
- `prefix` + `Ctrl-c`

Or set directly in your `.tmux.conf`:
```tmux
set-option -g @claude-status-style "magenta"  # or "white"
```

### Poll Interval

By default, the script checks every 2 seconds. To change:

```bash
export CLAUDE_STATUS_POLL_INTERVAL=1  # Check every second
```

### Manual Restart

If the status monitor stops working:
- `prefix` + `Alt-c` — Restart the monitor

## How It Works

A background shell script polls all tmux panes every 2 seconds:
1. Identifies panes running `claude` (by process name)
2. Captures the pane content to check for the `>` input prompt
3. Sets a `@claude-status` window option (`waiting`, `busy`, or `none`)
4. The tmux status format reads this option to display indicators

## Requirements

- tmux 3.0+ (for format conditionals)
- bash
- Claude Code CLI

## License

MIT
