#!/bin/bash
# cc-notify hook for Claude Code
# Sends notifications via Telegram when Claude needs attention

# Read the JSON input from stdin
INPUT=$(cat)

# Extract relevant fields
EVENT_TYPE=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude needs your attention"')
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')

# Only notify for idle_prompt (Claude waiting for input)
if [ "$NOTIFICATION_TYPE" = "idle_prompt" ]; then
    cc-notify send -t question "Yo, answer me: $MESSAGE" &
fi

if [ "$NOTIFICATION_TYPE" = "permission_prompt" ]; then
    cc-notify send -t question "Approve pls: $MESSAGE" &
fi

exit 0
