---
name: diary
description: Generate a daily journal entry from claude-mem observations and write to Obsidian vault
usage: /diary [mode]
examples:
  - /diary
  - /diary today
  - /diary yesterday
  - /diary 2025-12-15
  - /diary since:2025-12-18
  - /diary week
---

You are the diary command handler. Generate a daily journal entry from claude-mem observations and save it to the Obsidian vault.

## Instructions

1. **Determine the query mode**:
   - No argument or "today": All observations from today (all sessions)
   - "yesterday": All observations from yesterday
   - "week": All observations from the last 7 days
   - "since:YYYY-MM-DD": All observations since that date (inclusive) to today
   - "YYYY-MM-DD": All observations from that specific date

   **IMPORTANT**: Always capture ALL sessions, not just the current one. The diary should be a comprehensive record of all work done in the time period.

2. **Fetch observations from claude-mem**:
   Use the `mcp__plugin_claude-mem_mem-search__search` tool with:
   ```
   type: "observations"
   dateStart: [start date based on mode]
   dateEnd: [end date + 1 day]
   limit: 100
   orderBy: "date_asc"
   ```

   If results indicate more observations exist, make additional paginated calls to capture everything.

3. **Fetch full details** for each observation:
   - Extract observation IDs from the search results (the ID number shown in the table)
   - Call `mcp__plugin_claude-mem_mem-search__get_observations` with batches of IDs (can batch up to 30 at a time)
   - Collect the full observation data including facts, narrative, and files_modified

4. **Format the journal note** using this template:

   For single-day entries:
   ```markdown
   ---
   date: {{DATE}}
   tags: [journal, dev-log]
   ---

   # {{DATE}} - Dev Journal
   ```

   For multi-day/range entries (week, since:):
   ```markdown
   ---
   date_start: {{START_DATE}}
   date_end: {{END_DATE}}
   tags: [journal, dev-log, weekly]
   ---

   # {{START_DATE}} to {{END_DATE}} - Dev Journal
   ```

   Then continue with:
   ```markdown
   ## Summary
   {{Brief 2-3 sentence summary of the work done}}

   ## Sessions
   {{Count of unique sessions covered, e.g. "Captured 5 sessions across 3 projects"}}

   ## What I Did

   {{Group observations by project first, then by type within each project}}

   ### 📁 {{project_name}}

   #### 🟣 Features
   - **{{title}}**: {{subtitle}}
     - {{key facts as bullets}}

   #### 🔴 Bug Fixes
   - **{{title}}**: {{subtitle}}

   #### ✅ Changes
   - **{{title}}**: {{subtitle}}

   #### 🔵 Discoveries
   - **{{title}}**: {{subtitle}}

   #### ⚖️ Decisions
   - **{{title}}**: {{subtitle}}

   ## Files Modified
   {{List of unique files modified, grouped by project}}

   ## Learnings
   {{Extract interesting insights from narratives}}

   ## Next Steps
   - [ ] {{Suggested follow-ups based on context}}
   ```

5. **Write the file**:
   - Single day: `~/sync/Personal/Journal/{{YYYY-MM-DD}}.md`
   - Week: `~/sync/Personal/Journal/{{YYYY-MM-DD}}-week.md` (using end date)
   - Range: `~/sync/Personal/Journal/{{START}}-to-{{END}}.md`

   Use the Write tool. If file exists, ask user before overwriting.

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
- **ALWAYS capture all sessions** - the diary is a comprehensive record, not just current session
- Skip empty sections (don't show "#### Features" if no features for that project)
- Skip empty projects (don't show "### 📁 project" if no observations for it)
- Keep bullet points concise
- Preserve code blocks or file paths from narratives
- Group by project first, then by observation type within each project
- Include session count in the Sessions section (extract unique `sdk_session_id` values)
- If no observations found, create a minimal "quiet day" entry
- For multi-day entries, consider adding a day-by-day breakdown if work spans many days
