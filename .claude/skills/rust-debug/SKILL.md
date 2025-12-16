---
name: rust-debug
description: Debug Rust issues by investigating logs, state, and git history. Use when: (1) Rust compilation errors, (2) Runtime panics or unexpected behavior, (3) Test failures, (4) Performance issues, (5) Borrow checker battles, (6) Async/tokio issues. Trigger phrases include "debug this", "why is this failing", "help me fix", "what's wrong with".
---

# Rust Debug

Read-only investigation tool for Rust development issues.

## Quick Diagnosis

```bash
# Compilation check
cargo check 2>&1 | head -50

# Run tests
cargo test 2>&1 | tail -30

# Clippy warnings
cargo clippy 2>&1 | head -30

# Git state
git status && git log --oneline -5
```

## Investigation Workflow

### 1. Understand the Problem
- What's the symptom?
- When did it last work?
- What changed recently? (`git diff`, `git log`)

### 2. Parallel Investigation

Spawn parallel tasks:

| Task | Focus |
|------|-------|
| Logs | Find errors, stack traces, patterns |
| State | Verify files exist, check configs |
| Git | Recent commits, uncommitted changes |

### 3. Report Format

```markdown
## Debug Report

### What's Wrong
[Clear statement based on evidence]

### Evidence Found
**From Logs**: [errors/warnings]
**From Git**: [recent changes]

### Root Cause
[Most likely explanation]

### Next Steps
1. **Try First**: `command here`
2. **If That Fails**: alternative approach
```

## Common Rust Errors

See [references/common-errors.md](references/common-errors.md) for:
- Borrow checker errors with solutions
- Lifetime annotation patterns
- Async/tokio gotchas
- Serde troubleshooting

## Debugging Patterns

### Borrow Checker
```rust
// Clone to escape borrowing (quick fix)
let owned = borrowed.clone();

// Use references properly
fn process(data: &Data) -> Result<()>  // prefer &
fn mutate(data: &mut Data)              // only when needed
```

### Async Issues
```rust
// Missing .await
async fn fetch() -> Data { ... }
let data = fetch().await;  // Don't forget!

// Blocking in async context
tokio::task::spawn_blocking(|| {
    // CPU-intensive or blocking I/O here
}).await
```

### Option/Result Handling
```rust
// Quick debug - see what's None/Err
dbg!(&maybe_value);

// Pattern match for clarity
match result {
    Ok(v) => println!("Got: {v:?}"),
    Err(e) => eprintln!("Error: {e:?}"),
}
```

## Cargo Commands Cheatsheet

| Command | Purpose |
|---------|---------|
| `cargo check` | Fast type checking |
| `cargo build` | Full build |
| `cargo test` | Run tests |
| `cargo test -- --nocapture` | See println! output |
| `cargo clippy` | Lints and suggestions |
| `cargo expand` | See macro expansions |
| `RUST_BACKTRACE=1 cargo run` | Full stack traces |
