# Common Aliases

## Navigation

```zsh
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
```

## Modern CLI Replacements

```zsh
# eza (better ls)
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -la --icons --git'
    alias lt='eza --tree --level=2 --icons'
    alias la='eza -a --icons'
fi

# bat (better cat)
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'  # with paging
fi

# fd (better find)
# Usually just use 'fd' directly

# rg (better grep)
# Usually just use 'rg' directly
```

## Git Shortcuts

```zsh
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate -20'
```

## Safety Nets

```zsh
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
```

## Quick Edits

```zsh
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias vimrc='${EDITOR:-nvim} ~/.config/nvim/init.lua'
alias tmuxrc='${EDITOR:-nvim} ~/.tmux.conf'
```

## Misc Productivity

```zsh
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo $PATH | tr ":" "\n"'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# Quick server
alias serve='python3 -m http.server 8000'

# IP addresses
alias myip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0 2>/dev/null || hostname -I | awk "{print \$1}"'
```

## Rust Development

```zsh
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'
alias cc='cargo check'
alias cw='cargo watch -x check'
alias clippy='cargo clippy -- -W clippy::all'
```

## Directory Bookmarks (with zoxide)

```zsh
# zoxide handles this automatically with 'z'
# But you can add static bookmarks:
alias proj='cd ~/projects'
alias dots='cd ~/.dotfiles'
```
