# Tmuxinator Guide - Define & Automate Tmux Sessions

## 🎯 What is Tmuxinator?

Tmuxinator lets you define tmux sessions in YAML files, so you can:
- **Recreate exact layouts** with one command
- **Define windows and panes** with specific commands
- **Automate your workflow** (open files, run servers, start logs)
- **Version control** your dev environment configs

---

## 🚀 Quick Start

### Start a Session

```bash
# General development
tmuxinator dev

# C#/.NET development
tmuxinator csharp

# Web development (JS/TS)
tmuxinator web

# Custom project
tmuxinator project
```

**Note:** Run `tmuxinator dev` from your regular terminal (not inside tmux) for best results.

### Edit a Session Config

```bash
# Edit existing config
tmuxinator edit dev

# Or manually edit
nvim ~/.tmuxinator/dev.yml
```

### Stop a Session

```bash
# Kill the session
tmuxinator stop dev

# Or from inside tmux
Ctrl+b &  # Kill window
Ctrl+b :kill-session  # Kill session
```

---

## 📋 Pre-configured Sessions

### 1. `dev` - General Development

**Layout:**
```
┌────────────┬─────────────┬──────────────┐
│ Neo-tree   │ Neovim      │ zsh          │
│ (left)     │ (center)    │ (right)      │
│            ├─────────────┤              │
│            │ zsh         │ zsh          │
│            │ (bottom)    │ (bottom)     │
└────────────┴─────────────┴──────────────┘
```

**Usage:**
```bash
tmuxinator dev
```

**Config:** `~/.tmuxinator/dev.yml`

---

### 2. `csharp` - C#/.NET Development

**Windows:**
1. **main** - Neo-tree | Code | Terminal/Tools
2. **docs** - Obsidian vault | Terminal
3. **ai** - OpenCode AI | Terminal

**Usage:**
```bash
tmuxinator csharp
```

**Config:** `~/.tmuxinator/csharp.yml`

---

### 3. `web` - JavaScript/TypeScript Development

**Windows:**
1. **main** - Editor | Dev Server | Tools
2. **test** - Code | Test runner
3. **docs** - Obsidian | Terminal
4. **database** - DB CLI | API testing

**Usage:**
```bash
tmuxinator web
```

**Config:** `~/.tmuxinator/web.yml`

---

### 4. `project` - Generic Project Template

**Template for custom projects** - edit `root` path for each project.

**Usage:**
```bash
# Edit the config first
tmuxinator edit project

# Then start
tmuxinator project
```

**Config:** `~/.tmuxinator/project.yml`

---

## 📝 Tmuxinator YAML Syntax

### Basic Structure

```yaml
# ~/.tmuxinator/myproject.yml
name: myproject          # Session name
root: ~/dev/myproject    # Working directory

# Run before creating session
on_project_start: |
  echo "Starting session"
  # Any setup commands

# Run when exiting session
on_project_exit: |
  echo "Cleaning up"

# Run in each pane before creating panes/windows
pre_window: export TERM=screen-256color

# Define panes (simple layout)
panes:
  - nvim
  - zsh
  - zsh

# OR define windows (complex layout)
windows:
  - main:
      layout: main-horizontal
      panes:
        - nvim
        - zsh
        - zsh

  - docs:
      layout: main-vertical
      panes:
        - nvim ~/dev/vaults
        - zsh
```

### Layout Options

| Layout | Description |
|--------|-------------|
| `even-horizontal` | Equal-width panes side by side |
| `even-vertical` | Equal-height panes stacked |
| `main-horizontal` | Large left pane, smaller right panes |
| `main-vertical` | Large top pane, smaller bottom panes |
| `tiled` | Grid layout |
| `custom` | Custom layout (advanced) |

### Pane Commands

Each pane can run commands:

```yaml
panes:
  - nvim                    # Just open nvim
  -                         # Empty pane
  - zsh                     # Just open zsh
  -                         # Run commands
    - cd ~/dev
    - npm run dev
    - zsh                   # Keep shell open
  -                         # Open file in nvim
    - nvim ~/dev/README.md
```

### Windows

Multiple windows for different contexts:

```yaml
windows:
  - editor: nvim           # Simple window
  - server: npm run dev    # Run dev server
  - logs: tail -f logs/app.log
  - test:
      layout: main-vertical
      panes:
        - nvim
        - npm test
```

---

## 🎮 Common Commands

### Session Management

```bash
# List all configs
tmuxinator list

# Start session
tmuxinator <name>

# Stop session
tmuxinator stop <name>

# Copy config
tmuxinator copy old new

# Delete config
tmuxinator delete <name>

# Edit config
tmuxinator edit <name>

# Open config in editor
tmuxinator open <name>
```

### Inside Tmux

```bash
# List windows
Ctrl+b w

# Switch windows
Ctrl+b n    # Next
Ctrl+b p    # Previous
Ctrl+b 0-9  # By number

# Kill window
Ctrl+b &

# Detach
Ctrl+b d
```

---

## 🔧 Customizing Your Sessions

### Example: Add a New Project

```bash
# 1. Copy template
cp ~/.tmuxinator/project.yml ~/.tmuxinator/myapp.yml

# 2. Edit config
tmuxinator edit myapp

# 3. Change name and root
name: myapp
root: ~/dev/myapp

# 4. Start session
tmuxinator myapp
```

### Example: Add Dev Server to C# Session

Edit `~/.tmuxinator/csharp.yml`:

```yaml
windows:
  - main:
      panes:
        - editor:
            panes:
              - nvim -c 'Neotree show'
              - nvim
        - dev-server:
            - cd ~/dev/myapp
            - dotnet watch run
        - tools:
            panes:
              - zsh
              - zsh
```

### Example: Add Git Window

```yaml
windows:
  - main: ...
  - git:
      layout: main-vertical
      panes:
        - lazygit
        - git log --oneline
```

---

## 🎯 Your Pre-configured Sessions

### `dev.yml` - General Purpose

```yaml
name: dev
root: ~/dev
panes:
  - nvim -c 'Neotree show'  # Neo-tree
  - nvim                     # Code
  - zsh                      # Terminal
  - zsh                      # Terminal
```

**Start:** `tmuxinator dev`

---

### `csharp.yml` - .NET Development

```yaml
name: csharp
root: ~/dev
windows:
  - main: Code + Neo-tree + Tools
  - docs: Obsidian notes
  - ai: OpenCode AI
```

**Start:** `tmuxinator csharp`

---

### `web.yml` - Web Development

```yaml
name: web
root: ~/dev
windows:
  - main: Editor + Dev server + Tools
  - test: Testing window
  - docs: Notes
  - database: DB + API
```

**Start:** `tmuxinator web`

---

## 🐛 Troubleshooting

### Session Won't Start

```bash
# Check config syntax
yamllint ~/.tmuxinator/dev.yml

# Try with verbose output
tmuxinator debug dev
```

### Layout Looks Wrong

- Adjust `layout` option (`main-horizontal`, `even-vertical`, etc.)
- Use `pre_window` to set `TERM`
- Manually resize after start, then save as new config

### Commands Not Running

- Make sure each pane ends with `zsh` to keep shell open
- Use `-` for multi-line commands
- Check `on_project_start` syntax

### Can't Edit Config

```bash
# Manual edit
nvim ~/.tmuxinator/dev.yml

# Or use tmuxinator command
tmuxinator edit dev
```

---

## 🎨 Advanced Features

### Project-specific .tmuxinator.yml

Create `.tmuxinator.yml` in your project root:

```yaml
# ~/dev/myapp/.tmuxinator.yml
name: myapp
root: ~/dev/myapp
pre_window: export TERM=screen-256color
windows:
  - main:
      panes:
        - nvim
        - dotnet watch run
        - zsh
```

Then run:
```bash
cd ~/dev/myapp
tmuxinator .
```

### Environment Variables

```yaml
pre_window: |
  export NODE_ENV=development
  export PORT=3000
  export TERM=screen-256color
```

### Run Scripts

```yaml
on_project_start: |
  source ~/.zshrc
  eval "$(direnv hook bash)"
  echo "🚀 Session started at $(date)"
```

---

## 📚 Comparison: Tmuxinator vs Session Manager

| Feature | Tmuxinator | Session Manager Script |
|---------|-----------|----------------------|
| **Layout definition** | ✅ YAML config | ❌ Manual |
| **Multiple windows** | ✅ Yes | ⚠️ Possible |
| **Auto-run commands** | ✅ Yes | ⚠️ Limited |
| **Version control** | ✅ YAML files | ❌ Script only |
| **Flexibility** | ✅ High | ⚠️ Medium |
| **Learning curve** | ⚠️ YAML syntax | ✅ Simple commands |

**Use both:**
- **Tmuxinator** for defined, repeatable layouts
- **Session manager** for quick ad-hoc sessions

---

## 🎉 Quick Reference

### Start Sessions

```bash
tmuxinator dev          # General dev
tmuxinator csharp       # C#/.NET
tmuxinator web          # Web/JS
tmuxinator project      # Custom project
```

### Edit Configs

```bash
tmuxinator edit dev     # Edit dev config
nvim ~/.tmuxinator/dev.yml  # Manual edit
```

### Stop Sessions

```bash
tmuxinator stop dev     # Stop dev session
```

### List Configs

```bash
tmuxinator list         # Show all configs
```

---

## 📚 Resources

- [Tmuxinator GitHub](https://github.com/tmuxinator/tmuxinator)
- [Tmuxinator Examples](https://github.com/tmuxinator/tmuxinator/tree/master/completion/zsh)
- [Your Configs](~/.tmuxinator/)

---

## 🚀 Next Steps

1. **Try the dev session:**
   ```bash
   tmuxinator dev
   ```

2. **Customize for your workflow:**
   ```bash
   tmuxinator edit dev
   ```

3. **Create project-specific config:**
   ```bash
   cp ~/.tmuxinator/project.yml ~/.tmuxinator/myapp.yml
   tmuxinator edit myapp
   ```

4. **Add to your workflow:**
   ```bash
   # Morning: start session
   tmuxinator dev

   # Evening: stop session
   tmuxinator stop dev
   ```

**Enjoy your automated dev environment!** 🎉
