---
name: diary
description: Generate a daily journal entry from claude-mem observations and write to Obsidian vault
usage: /diary [date]
examples:
  - /diary
  - /diary 2025-12-15
  - /diary yesterday
---

You are the diary command handler. Generate a daily journal entry from claude-mem observations and save it to the Obsidian vault.

## Instructions

1. **Determine the date**:
   - If no argument provided, use today's date
   - If "yesterday" provided, use yesterday's date
   - Otherwise parse the provided date (YYYY-MM-DD format)

2. **Fetch observations from claude-mem**:
   Use the `mcp__plugin_claude-mem_claude-mem-search__search` tool with:
   ```
   type: "observations"
   dateStart: [target date]
   dateEnd: [target date + 1 day]
   limit: 50
   orderBy: "date_asc"
   ```

3. **Fetch full details** for each observation:
   - Extract observation IDs from the search results (the number after `observation/` in the source URL)
   - Call `mcp__plugin_claude-mem_claude-mem-search__get_observation` for each ID (can be done in parallel)
   - Collect the full observation data including facts, narrative, and files_modified

4. **Format the daily note** using this template:

```markdown
---
date: {{DATE}}
tags: [journal, dev-log]
---

# {{DATE}} - Dev Journal

## Summary
{{Brief 2-3 sentence summary of the day's work}}

## What I Did

{{For each observation, grouped by type:}}

### 🟣 Features
- **{{title}}**: {{subtitle}}
  - {{key facts as bullets}}

### 🔴 Bug Fixes
- **{{title}}**: {{subtitle}}

### ✅ Changes
- **{{title}}**: {{subtitle}}

### 🔵 Discoveries
- **{{title}}**: {{subtitle}}

### ⚖️ Decisions
- **{{title}}**: {{subtitle}}

## Files Modified
{{List of unique files modified today}}

## Learnings
{{Extract interesting insights from narratives}}

## Tomorrow
- [ ] {{Suggested follow-ups based on context}}
```

5. **Write the file** to: `~/sync/Personal/Journal/{{YYYY-MM-DD}}.md`
   - Use the Write tool
   - If file exists, ask user before overwriting

6. **Confirm** with the user:
   - Show a summary of what was captured
   - Display the file path
   - Mention any sections that were empty

## Type Emoji Legend
- 🟣 feature
- 🔴 bugfix
- 🔄 refactor
- ✅ change
- 🔵 discovery
- ⚖️ decision
- 🎯 session-request

## Notes
- Skip empty sections (don't show "### Features" if no features)
- Keep bullet points concise
- Preserve code blocks or file paths from narratives
- If no observations found, create a minimal "quiet day" entry
