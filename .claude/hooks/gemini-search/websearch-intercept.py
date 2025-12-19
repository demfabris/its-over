#!/usr/bin/env python3
"""
PreToolUse hook that intercepts WebSearch and routes to Gemini CLI.
"""
import json
import sys
import subprocess
import os

SEARCH_SCRIPT = os.path.expanduser("~/.claude/scripts/gemini-search.sh")


def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(1)

    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})

    # Only intercept WebSearch
    if tool_name != "WebSearch":
        sys.exit(0)

    query = tool_input.get("query", "")
    if not query:
        sys.exit(0)

    # Run Gemini search
    try:
        result = subprocess.run(
            [SEARCH_SCRIPT, "search", query],
            capture_output=True,
            text=True,
            timeout=120
        )

        if result.returncode == 0 and result.stdout.strip():
            search_results = result.stdout.strip()
            cached = "[Cached]" if "[Cached result]" in result.stderr else "[Fresh]"
        else:
            search_results = f"Search failed: {result.stderr}"
            cached = ""
    except subprocess.TimeoutExpired:
        search_results = "Search timed out after 120 seconds"
        cached = ""
    except Exception as e:
        search_results = f"Search error: {e}"
        cached = ""

    # Return results as denial reason (Claude sees this as the output)
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": f"## Web Search Results {cached}\n\n{search_results}"
        }
    }

    print(json.dumps(output))
    sys.exit(0)


if __name__ == "__main__":
    main()
