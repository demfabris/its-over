---
name: dotfiles-curator
description: Cross-platform dotfiles management for macOS and Linux. Use when: (1) Adding new tool configs to dotfiles repo, (2) Setting up a fresh machine, (3) Debugging config portability issues, (4) Reviewing dotfile structure, (5) Creating symlink strategies, (6) Ensuring macOS/Linux compatibility. Trigger phrases include "add to dotfiles", "dotfiles setup", "config not working on linux/mac", "symlink my configs".
---

# Dotfiles Curator

Elite dotfiles architect for cross-platform configuration management.

## Core Philosophy

- **Minimal configs** - No bloat. If unused, delete it
- **Portable by default** - Work on both platforms unless impossible
- **XDG compliance** - Respect `$XDG_CONFIG_HOME` (~/.config)
- **Symlink over copy** - Link from repo to expected locations
- **No secrets in repo** - API keys go in gitignored `.env` files

## OS Detection Pattern

```zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
fi
```

## Cross-Platform Gotchas

| Feature | macOS | Linux |
|---------|-------|-------|
| Clipboard | `pbcopy`/`pbpaste` | `xclip`/`wl-copy` |
| Package mgr | `brew` | `pacman`/`yay` |
| Paths | `/opt/homebrew` | standard |
| Coreutils | BSD (different flags!) | GNU |

## Repository Structure

```
~/.dotfiles/
├── zsh/           # Shell configs
├── nvim/          # Editor
├── tmux/          # Multiplexer
├── yazi/          # File manager
├── claude/        # AI tools
├── git/           # Git config
├── install.sh     # Cross-platform symlinker
└── README.md
```

## Workflow

1. **Detect OS** before any operation
2. **Check canonical config locations** on both platforms
3. **Create config** with OS-conditional blocks if needed
4. **Update install script** for symlinking
5. **Verify portability** mentally on both platforms

## Quality Checklist

- [ ] Works with Homebrew paths on macOS?
- [ ] Works on Arch Linux?
- [ ] Hardcoded paths converted to variables?
- [ ] Clipboard handling platform-aware?
- [ ] GNU vs BSD command differences handled?

## References

- [cross-platform-patterns.md](references/cross-platform-patterns.md) - Clipboard, paths, GNU/BSD shims
- [common-aliases.md](references/common-aliases.md) - Battle-tested aliases
