---
name: git-workflow
description: Git commit and PR workflow automation. Use when: (1) Creating commits from session changes, (2) Writing PR descriptions, (3) Reviewing changes before commit, (4) Need commit message suggestions. Trigger phrases include "commit this", "create a commit", "describe this PR", "write PR description".
---

# Git Workflow

Streamlined git operations: commits and PR descriptions.

## Commit Workflow

### 1. Review Changes
```bash
git status           # What's changed?
git diff             # Staged + unstaged
git log --oneline -5 # Recent commit style
```

### 2. Plan Commits
- Group related changes together
- Keep commits atomic and focused
- Use imperative mood: "Add feature" not "Added feature"

### 3. Present Plan
```markdown
I plan to create [N] commit(s):

**Commit 1**: `path/to/file.rs`, `another/file.rs`
Message: "Add user authentication endpoint"

**Commit 2**: `tests/auth_test.rs`
Message: "Add tests for auth endpoint"

Proceed?
```

### 4. Execute
```bash
git add path/to/specific/files
git commit -m "Message here"
git log --oneline -n 2  # Verify
```

## Commit Message Guidelines

```
<type>: <description>

[optional body explaining why]
```

### Types
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code restructuring
- `docs` - Documentation only
- `test` - Adding/fixing tests
- `chore` - Maintenance tasks

### Good Examples
```
feat: add pagination to user list endpoint
fix: prevent null pointer in webhook handler
refactor: extract validation logic to separate module
```

## PR Description Workflow

### 1. Gather Information
```bash
gh pr view --json url,number,title,state 2>/dev/null
gh pr diff {number}
gh pr view {number} --json commits
```

### 2. Analyze Changes
- Read entire diff
- Identify user-facing vs internal changes
- Note breaking changes

### 3. Run Verification
```bash
cargo check && cargo test && cargo clippy
```

### 4. Generate Description

```markdown
## Summary
- [1-3 bullet points of what this PR does]

## Changes
- [Detailed change 1]
- [Detailed change 2]

## How to Test
- [ ] `cargo test` passes
- [ ] `cargo clippy` has no warnings
- [ ] [Manual test step if needed]

## Breaking Changes
[List any, or "None"]
```

### 5. Update PR
```bash
gh pr edit {number} --body "$(cat description.md)"
```

## Important Rules

- **Never add co-author attribution** - Commits are authored by user
- **Use specific `git add`** - Never use `-A` or `.`
- **Focus on "why"** not just "what"
- **Include breaking changes prominently**
