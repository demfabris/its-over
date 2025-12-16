---
name: planning-workflow
description: Create and execute detailed implementation plans through interactive research. Use when: (1) Planning new features or significant changes, (2) Need to understand codebase before implementing, (3) Creating technical design docs, (4) Complex multi-phase implementations, (5) When asked to "plan", "design", or "architect" something. Combines research, planning, and implementation tracking.
---

# Planning Workflow

Comprehensive planning system: research → plan → implement → verify.

## Workflow Decision Tree

```
User Request
    │
    ├─► "Research X" ──────► Research Mode
    │                        └─► Parallel sub-agents
    │                        └─► Synthesize findings
    │
    ├─► "Plan X" ──────────► Planning Mode
    │                        └─► Gather context
    │                        └─► Ask clarifying questions
    │                        └─► Write plan to docs/plans/
    │
    └─► "Implement plan" ──► Implementation Mode
                             └─► Read plan fully
                             └─► Execute phases
                             └─► Verify at each step
```

## Research Mode

Spawn parallel research tasks using specialized agents:

| Agent | Purpose |
|-------|---------|
| `codebase-locator` | Find WHERE files/components live |
| `codebase-analyzer` | Understand HOW code works |
| `codebase-pattern-finder` | Find similar patterns to follow |

### Research Output Format

```markdown
## Research: [Topic]

### Summary
[High-level answer]

### Detailed Findings
- [Discovery] (`file.rs:line`)

### Architecture Notes
[Patterns found]

### Open Questions
[Needs further investigation]
```

## Planning Mode

### Step 1: Context Gathering
- Read all mentioned files **fully** (no limit/offset)
- Spawn parallel research tasks
- Present findings with focused questions

### Step 2: Design Options
```markdown
**Current State:**
- [Key discovery]

**Design Options:**
1. [Option A] - pros/cons
2. [Option B] - pros/cons

Which approach?
```

### Step 3: Write Plan
Write to `docs/plans/YYYY-MM-DD-description.md`

See [references/plan-template.md](references/plan-template.md) for full template.

### Plan Sections
1. Overview
2. Current State Analysis
3. Desired End State
4. What We're NOT Doing
5. Implementation Phases (with code examples)
6. Success Criteria (automated + manual)
7. Testing Strategy

## Implementation Mode

1. Read plan completely, check existing checkmarks
2. Create todo list to track progress
3. Implement each phase fully before next
4. Run verification: `cargo check`, `cargo test`, `cargo clippy`
5. Update checkboxes in plan
6. **Pause for manual verification** between phases

### When Things Don't Match

```markdown
Issue in Phase [N]:
Expected: [plan says]
Found: [actual]
Why this matters: [explanation]

How to proceed?
```

## Guidelines

- **Be Skeptical** - Question vague requirements
- **Be Interactive** - Get buy-in at each step
- **Be Thorough** - Include file:line references
- **Be Practical** - Incremental, testable changes
- **No Open Questions** - Resolve before finalizing
