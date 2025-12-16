# Cross-Platform Patterns

## Clipboard Abstraction

```zsh
# Universal clipboard
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias clip='pbcopy'
    alias paste='pbpaste'
elif command -v wl-copy &>/dev/null; then
    alias clip='wl-copy'
    alias paste='wl-paste'
else
    alias clip='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
fi
```

## Path Handling

```zsh
# Homebrew paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi

# XDG compliance
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
```

## GNU vs BSD Compatibility

```zsh
# Use GNU coreutils on macOS if available
if [[ "$OSTYPE" == "darwin"* ]] && command -v gls &>/dev/null; then
    alias ls='gls --color=auto'
    alias sed='gsed'
    alias awk='gawk'
fi
```

## Open Command

```zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS has 'open' built-in
elif command -v xdg-open &>/dev/null; then
    alias open='xdg-open'
fi
```

## Notifications

```zsh
notify() {
    local title="$1" msg="$2"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"$msg\" with title \"$title\""
    elif command -v notify-send &>/dev/null; then
        notify-send "$title" "$msg"
    fi
}
```

## Install Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "Linked: $dst -> $src"
}

# Shell
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"

# XDG configs
link "$DOTFILES_DIR/nvim" "$XDG_CONFIG_HOME/nvim"
link "$DOTFILES_DIR/yazi" "$XDG_CONFIG_HOME/yazi"

# tmux
link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "Dotfiles linked!"
```
