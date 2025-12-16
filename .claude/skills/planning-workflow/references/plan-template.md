# Plan Template

Use this template for `docs/plans/YYYY-MM-DD-description.md`:

```markdown
# [Feature Name] Implementation Plan

## Overview
[Brief description of what we're implementing and why]

## Current State Analysis
[What exists now, what's missing, constraints discovered]

### Key Discoveries
- [Important finding] (`file.rs:line`)
- [Pattern to follow] (`another.rs:line`)

## Desired End State
[Specification of what "done" looks like and how to verify]

## What We're NOT Doing
- [Explicitly out-of-scope item 1]
- [Out-of-scope item 2]

## Implementation Approach
[High-level strategy and reasoning for chosen approach]

---

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required

#### 1. [Component/File]
**File**: `path/to/file.rs`
**Changes**: [Summary of changes]

```rust
// Specific code to add/modify
pub fn new_function() -> Result<()> {
    // implementation
}
```

#### 2. [Another Component]
**File**: `path/to/another.rs`
**Changes**: [Summary]

### Success Criteria

#### Automated Verification
- [ ] `cargo check` passes
- [ ] `cargo test` passes
- [ ] `cargo clippy` has no warnings

#### Manual Verification
- [ ] Feature works as expected when tested
- [ ] No regressions in related features

---

## Phase 2: [Descriptive Name]
[Same structure as Phase 1...]

---

## Testing Strategy

### Unit Tests
- [ ] Test case 1: [description]
- [ ] Test case 2: [description]
- [ ] Edge case: [description]

### Integration Tests
- [ ] End-to-end scenario 1
- [ ] End-to-end scenario 2

## References
- `path/to/relevant/file.rs:line` - [what it does]
- `another/reference.rs:line` - [why it matters]
```

## Tips

1. **Be specific** - Include exact file paths and line numbers
2. **Show code** - Include actual code snippets, not just descriptions
3. **Verify incrementally** - Each phase should be independently verifiable
4. **Track progress** - Use checkboxes that can be marked during implementation
5. **Anticipate issues** - Note potential complications in each phase
