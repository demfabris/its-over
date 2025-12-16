# Bootstrap Claude Code Environment

You are bootstrapping Claude Code on a fresh machine. The user has cloned their dotfiles repo which contains settings, skills, hooks, and commands - but plugins and services need to be installed.

## Context
- Mac Studio device ID for Syncthing: `I5LLUO3-KZV3BVH-BBTXOYK-JJ3PFYP-XYTS2IS-2EET2GV-3W4MAWS-M2XYGQQ`
- Required env var: `GITHUB_PERSONAL_ACCESS_TOKEN`

## Bootstrap Phases

Execute these phases IN ORDER. Check status before each step. Ask user for input when needed.

### Phase 1: Prerequisites

Check and install if missing:

```bash
# Check what's installed
which brew && echo "Homebrew: OK" || echo "Homebrew: MISSING"
which docker && echo "Docker: OK" || echo "Docker: MISSING"
which syncthing && echo "Syncthing: OK" || echo "Syncthing: MISSING"
which claude && echo "Claude CLI: OK" || echo "Claude CLI: MISSING"
```

Install missing prerequisites:
- **Homebrew** (macOS): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- **Docker**: `brew install --cask docker` (then open Docker.app)
- **Syncthing**: `brew install syncthing`
- **Claude CLI**: `npm install -g @anthropic-ai/claude-code`

### Phase 2: Plugin Marketplaces

Register these plugin sources first:

```bash
# Official Anthropic plugins
claude /add-marketplace anthropics/claude-plugins-official

# Official Anthropic skills
claude /add-marketplace anthropics/skills

# claude-mem (memory persistence)
claude /add-marketplace thedotmack/claude-mem

# dev-browser (browser automation)
claude /add-marketplace sawyerhood/dev-browser
```

### Phase 3: Claude Plugins

Install these plugins from the registered marketplaces:

1. `claude-mem@thedotmack` - Memory/context persistence
2. `context7@claude-plugins-official` - Library documentation lookup
3. `dev-browser@dev-browser-marketplace` - Browser automation
4. `learning-output-style@claude-plugins-official` - Educational output mode
5. `frontend-design@claude-plugins-official` - Frontend design skills
6. `example-skills@anthropic-agent-skills` - Example skill collection
7. `figma-mcp@claude-plugins-official` - Figma integration

Use: `claude /install-plugin <plugin-name>` for each

### Phase 4: MCP Server Setup

Pull GitHub MCP server Docker image:
```bash
docker pull ghcr.io/github/github-mcp-server
```

Verify ~/.mcp.json exists and contains GitHub server config (should be from git clone).

### Phase 5: Environment Variables

Check if GITHUB_PERSONAL_ACCESS_TOKEN is set:
```bash
echo $GITHUB_PERSONAL_ACCESS_TOKEN | head -c 4
```

If not set, ask user to:
1. Generate a token at https://github.com/settings/tokens (classic, with repo scope)
2. Add to ~/.zshrc: `export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_..."`
3. Reload shell: `source ~/.zshrc`

### Phase 6: Syncthing Setup

1. Start syncthing service:
   ```bash
   brew services start syncthing
   ```

2. Open web UI: http://localhost:8384

3. Add Mac Studio as remote device using ID:
   `I5LLUO3-KZV3BVH-BBTXOYK-JJ3PFYP-XYTS2IS-2EET2GV-3W4MAWS-M2XYGQQ`

4. Accept the `claude-mem` folder share when it appears

5. Create ~/.claude-mem directory if it doesn't exist (Syncthing will populate it)

### Phase 7: Verification

Run these checks to verify everything works:

```bash
# Claude CLI
claude --version

# Plugins
claude /plugins

# Docker
docker run --rm ghcr.io/github/github-mcp-server --help

# Syncthing
curl -s http://localhost:8384/rest/system/status | jq '.myID'

# Memory DB (after sync completes)
ls -la ~/.claude-mem/claude-mem.db
```

### Phase 8: First Run

Start a new Claude session to verify:
1. Memory plugin loads (you should see recent context)
2. MCP tools are available
3. Skills and commands are recognized

## Success Criteria

- [ ] All prerequisites installed
- [ ] All 7 plugins installed
- [ ] GitHub MCP server docker image pulled
- [ ] GITHUB_PERSONAL_ACCESS_TOKEN set
- [ ] Syncthing running and connected to Mac Studio
- [ ] claude-mem folder syncing
- [ ] Claude session starts with full context

## Troubleshooting

- **Plugin install fails**: Check npm/node version, try `npm cache clean --force`
- **Docker not found**: Make sure Docker.app is running
- **Syncthing won't connect**: Check Tailscale is running, devices are on same tailnet
- **Memory not loading**: Wait for initial sync to complete, check ~/.claude-mem/claude-mem.db exists
