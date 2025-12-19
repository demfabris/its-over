#!/bin/bash
# cc-notify Stop hook - notifies when Claude finishes responding

# Read stdin with timeout to prevent hanging
INPUT=$(timeout 2 cat 2>/dev/null || echo '{}')

CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
PROJECT=$(basename "$CWD" 2>/dev/null || echo "project")
STOP_REASON=$(echo "$INPUT" | jq -r '.stop_hook_reason // "done"')

# Only notify on meaningful stops (not every single response)
case "$STOP_REASON" in
    end_turn|tool_use)
        # These are normal stops, skip notification
        ;;
    *)
        ~/.config/cc-notify/cc-notify send -t complete "[$PROJECT] Claude finished" &
        ;;
esac

exit 0
