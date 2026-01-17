# tmux-claude-status Design

**Date:** 2025-01-17

## Problem

When running multiple Claude Code sessions across tmux windows, it's hard to tell which sessions are waiting for input vs. actively processing. This leads to unnecessary context-switching to check on sessions.

## Solution

A tmux status line indicator that shows per-window whether Claude is:
- **Waiting for input** — the `>` prompt is visible
- **Busy** — Claude is processing/generating output
- **Not present** — no Claude session in this window

## File Structure

```
~/dotfiles/tmux/
├── tmux-claude/
│   ├── claude-status.sh    # Polling script
│   ├── claude-status.conf  # Tmux config
│   └── README.md           # Usage instructions
~/.tmux → ~/dotfiles/tmux/  # Symlink
```

## Detection Logic

The polling script (`claude-status.sh`):

1. Loops through all tmux panes
2. Identifies Claude panes by checking if `pane_current_command` contains `claude`
3. For each Claude pane, captures the last lines with `tmux capture-pane`
4. Checks for the `>` prompt pattern at the bottom of the pane
5. Sets a window user option `@claude-status` to `waiting`, `busy`, or `none`
6. Runs every 1-2 seconds as a background process

## Visual Indicators

**Waiting (needs input):**
- Symbol: `●` (filled dot)
- Foreground: bright white or magenta (configurable)
- Background: black/dark (inverted from default green status line)

**Busy:**
- Symbol: `○` (hollow dot)
- Foreground: dim grey
- Background: default (no change)

**No Claude:**
- No indicator

### Example

```
1:api  2:frontend●  3:docs○  4:logs
        ^waiting    ^busy    ^no claude
```

## Configuration

The tmux config (`claude-status.conf`):

1. Overrides `window-status-format` and `window-status-current-format` to include Claude status
2. Checks `@claude-status` window option with tmux conditionals
3. Launches polling script on tmux server start (with duplicate prevention)
4. Provides `@claude-status-style` option to toggle between `white` and `magenta` themes

## Usage

Add to `.tmux.conf`:
```tmux
source-file ~/.tmux/tmux-claude/claude-status.conf
```

## Future Enhancements

- Claude Code hooks integration for instant updates (no polling delay)
- Configurable poll interval
- Support for other AI CLI tools
