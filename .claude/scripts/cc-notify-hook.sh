#!/bin/bash
# cc-notify hook for Claude Code
# Sends notifications via Telegram when Claude needs attention

# Read stdin with timeout to prevent hanging
INPUT=$(timeout 2 cat 2>/dev/null || echo '{}')

NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
MESSAGE=$(echo "$INPUT" | jq -r '.message // ""')

# Extract project name from cwd
PROJECT=$(basename "$CWD" 2>/dev/null || echo "unknown")

# Extract AskUserQuestion details from transcript (questions + options)
get_ask_user_question() {
    if [[ -z "$TRANSCRIPT" || ! -f "$TRANSCRIPT" ]]; then
        return
    fi

    # Find the last AskUserQuestion tool use in transcript
    # The transcript is JSONL format - one JSON object per line
    local ask_json
    ask_json=$(tac "$TRANSCRIPT" 2>/dev/null | while read -r line; do
        # Check if this line contains AskUserQuestion
        if echo "$line" | jq -e '.message.content[]? | select(.type == "tool_use" and .name == "AskUserQuestion")' >/dev/null 2>&1; then
            echo "$line" | jq -r '.message.content[] | select(.type == "tool_use" and .name == "AskUserQuestion") | .input'
            break
        fi
    done)

    if [[ -z "$ask_json" ]]; then
        return
    fi

    # Format the questions and options
    echo "$ask_json" | jq -r '
        .questions[]? |
        "❓ " + .question + "\n" +
        ([.options[]? | "  • " + .label + (if .description then " - " + .description else "" end)] | join("\n"))
    ' 2>/dev/null
}

# Get last assistant message for general context
get_last_message() {
    if [[ -z "$TRANSCRIPT" || ! -f "$TRANSCRIPT" ]]; then
        return
    fi

    # Get last text content from assistant
    tac "$TRANSCRIPT" 2>/dev/null | while read -r line; do
        local text
        text=$(echo "$line" | jq -r '
            select(.type == "assistant") |
            .message.content[]? |
            select(.type == "text") |
            .text' 2>/dev/null | head -1)
        if [[ -n "$text" ]]; then
            # Truncate to 500 chars for readability
            echo "${text:0:500}"
            break
        fi
    done
}

case "$NOTIFICATION_TYPE" in
    idle_prompt)
        # Check if this is an AskUserQuestion waiting for response
        ASK_CONTENT=$(get_ask_user_question)

        if [[ -n "$ASK_CONTENT" ]]; then
            # Multi-choice question - send formatted question with options
            MSG="[$PROJECT] Claude asks:\n\n$ASK_CONTENT"
        else
            # Regular idle - send last assistant message as context
            LAST_MSG=$(get_last_message)
            if [[ -n "$LAST_MSG" ]]; then
                MSG="[$PROJECT] Waiting for input:\n\n${LAST_MSG}..."
            else
                MSG="[$PROJECT] Claude is waiting for your input"
            fi
        fi
        ~/.config/cc-notify/cc-notify send -t question "$MSG" &
        ;;

    permission_prompt)
        # Use the actual message from Claude Code
        if [[ -n "$MESSAGE" ]]; then
            MSG="[$PROJECT] $MESSAGE"
        else
            MSG="[$PROJECT] Permission needed"
        fi
        ~/.config/cc-notify/cc-notify send -t approval "$MSG" &
        ;;
esac

exit 0
