#!/usr/bin/env bash
#
# claude-status.sh - Monitor Claude Code sessions in tmux
#
# Sets @claude-status window option to:
#   "waiting" - Claude is showing the > prompt (needs input)
#   "busy"    - Claude is running but processing
#   "none"    - No Claude session in this window

POLL_INTERVAL="${CLAUDE_STATUS_POLL_INTERVAL:-2}"

# Ensure only one instance runs per tmux server
LOCK_FILE="/tmp/claude-status-$(tmux display-message -p '#{socket_path}' | tr '/' '_').lock"

cleanup() {
    rm -f "$LOCK_FILE"
    exit 0
}

trap cleanup EXIT INT TERM

if [ -f "$LOCK_FILE" ]; then
    existing_pid=$(cat "$LOCK_FILE" 2>/dev/null)
    if kill -0 "$existing_pid" 2>/dev/null; then
        exit 0
    fi
fi

echo $$ > "$LOCK_FILE"

# Check if a pane is running Claude
is_claude_pane() {
    local pane_id="$1"
    local cmd
    cmd=$(tmux display-message -p -t "$pane_id" '#{pane_current_command}' 2>/dev/null)
    [[ "$cmd" == "claude" ]]
}

# Check if Claude is waiting for input (prompt visible)
is_waiting_for_input() {
    local pane_id="$1"
    local captured

    # Capture last 5 lines of the pane
    captured=$(tmux capture-pane -t "$pane_id" -p -S -5 2>/dev/null)

    # Check for the > prompt at the start of a line
    # Claude Code shows "> " when waiting for input
    if echo "$captured" | grep -qE '^>\s*$'; then
        return 0
    fi

    return 1
}

# Main loop
while true; do
    # Check if tmux server is still running
    if ! tmux list-sessions &>/dev/null; then
        exit 0
    fi

    # Get all windows
    windows=$(tmux list-windows -a -F '#{session_name}:#{window_index}' 2>/dev/null)

    for window in $windows; do
        window_status="none"

        # Get all panes in this window
        panes=$(tmux list-panes -t "$window" -F '#{pane_id}' 2>/dev/null)

        for pane_id in $panes; do
            if is_claude_pane "$pane_id"; then
                if is_waiting_for_input "$pane_id"; then
                    window_status="waiting"
                    break  # Waiting takes priority
                elif [ "$window_status" != "waiting" ]; then
                    window_status="busy"
                fi
            fi
        done

        # Set the window option
        tmux set-option -t "$window" -w @claude-status "$window_status" 2>/dev/null
    done

    sleep "$POLL_INTERVAL"
done
