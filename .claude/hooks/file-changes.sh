#!/bin/bash
# file-changes.sh - Track file modifications
# Hook type: PostToolUse (Edit, Write)

CC_NOTIFY_BIN="${HOME}/.config/cc-notify/cc-notify"

# Session identification - use working directory basename as human-readable name
SESSION_NAME=$(basename "$PWD")

# Read input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Determine operation based on tool
case "$TOOL_NAME" in
    Write)
        OPERATION="created"
        ;;
    Edit)
        OPERATION="modified"
        ;;
    *)
        exit 0  # Only track Edit and Write
        ;;
esac

# Extract file path
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Build payload with session info
PAYLOAD=$(jq -n \
    --arg path "$FILE_PATH" \
    --arg op "$OPERATION" \
    --arg session "$SESSION_NAME" \
    '{
        "type": "file_change",
        "file_path": $path,
        "operation": $op,
        "session_name": $session
    }')

# Human-readable message
FILENAME=$(basename "$FILE_PATH")
MESSAGE="$OPERATION: $FILENAME"

# Send to cc-notify with session flag (fire and forget)
"$CC_NOTIFY_BIN" send -t file_change -s "$SESSION_NAME" --payload "$PAYLOAD" "$MESSAGE" &>/dev/null &
