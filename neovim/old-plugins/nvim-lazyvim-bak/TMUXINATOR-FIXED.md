# ✅ Tmuxinator Fixed and Ready!

## 🐛 Issue Fixed

**Problem:** Ruby version compatibility bug in tmuxinator 3.3.8  
**Error:** `undefined method 'shellescape' for an instance of Integer`  
**Fix:** Removed `width` parameters from configs (tmuxinator bug workaround)

---

## 🚀 How to Start

### Option 1: Direct Command

```bash
# From your regular terminal (NOT inside tmux)
tmuxinator dev
```

### Option 2: Helper Script

```bash
# From your regular terminal
./start-dev-session.sh
```

---

## 🎨 Your Layout

### Window 0: **main** (Development)
```
┌──────────────┬─────────────────────────┐
│              │  Code Editor            │
│  Neo-tree    │  (top)                  │
│  (left)      ├─────────────────────────┤
│              │  Terminal               │
│              │  (bottom)               │
└──────────────┴─────────────────────────┘
```

**Panes:**
- **Left:** Neo-tree file explorer
- **Top-right:** Neovim code editor
- **Bottom-right:** Terminal (zsh)
- **Far-right:** Additional terminal

---

### Window 1: **notes** (Obsidian)
```
┌──────────────────────┬─────────────────┐
│  Obsidian Vault      │  Terminal       │
│  (left)              │  (right)        │
└──────────────────────┴─────────────────┘
```

**Panes:**
- **Left:** Neovim in `~/dev/vaults`
- **Right:** Terminal for git/commands

---

### Window 2: **ai** (OpenCode)
```
┌─────────────────────────────────────────┐
│  Neovim (OpenCode)                      │
│  (top)                                  │
├─────────────────────────────────────────┤
│  Terminal                               │
│  (bottom)                               │
└─────────────────────────────────────────┘
```

**Panes:**
- **Top:** Neovim for OpenCode AI
- **Bottom:** Terminal for running code

---

## ⌨️ Navigation

### Switch Windows

```bash
# Visual selector (recommended)
Ctrl+b w

# By number
Ctrl+b 0      # main window
Ctrl+b 1      # notes window
Ctrl+b 2      # ai window

# By name
Ctrl+b :select-window -t main
Ctrl+b :select-window -t notes
Ctrl+b :select-window -t ai
```

### Navigate Panes

```bash
# Vim-style
Ctrl+b h      # Left pane
Ctrl+b j      # Bottom pane
Ctrl+b k      # Top pane
Ctrl+b l      # Right pane
```

### Resize Panes

```bash
# Mouse mode is enabled!
# Just drag pane borders with your mouse

# Or use keyboard:
Ctrl+b Ctrl+h     # Resize left
Ctrl+b Ctrl+j     # Resize down
Ctrl+b Ctrl+k     # Resize up
Ctrl+b Ctrl+l     # Resize right
```

---

## 🎯 Complete Workflow

### Morning: Start Work

```bash
# From iTerm2 or Terminal.app (not inside tmux)
tmuxinator dev

# You're now in Window 0 (main) with:
# - Neo-tree on left
# - Neovim code editor top-right
# - Terminal bottom-right

# Load your Neovim session to restore files/splits
<Space>ql
```

### During Work

```bash
# Coding in main window...

# Need to take notes?
Ctrl+b 1        # Switch to notes window
# Now in Obsidian vault

# Need AI help?
Ctrl+b 2        # Switch to ai window
# Open OpenCode with <Space>og

# Back to coding?
Ctrl+b 0        # Switch to main window
```

### End of Day

```bash
# Save Neovim session (in current window)
<Space>qw

# Quit Neovim
:qa

# Detach tmux (keeps everything running!)
Ctrl+b d

# OR stop completely
tmuxinator stop dev
```

### Reattach Later

```bash
# Attach to existing session
tmux attach -t dev

# Or use tmuxinator
tmuxinator dev
```

---

## 📝 Customize Layout

### Edit Config

```bash
tmuxinator edit dev
```

### Adjust Pane Sizes

**Manual (inside tmux):**
```bash
# Drag with mouse (mouse is enabled!)
# Or use keyboard:

Ctrl+b :resize-pane -L 10    # Make left pane 10 cells wider
Ctrl+b :resize-pane -R 10    # Make right pane 10 cells wider
Ctrl+b :resize-pane -U 10    # Make top pane 10 cells taller
Ctrl+b :resize-pane -D 10    # Make bottom pane 10 cells taller
```

**Save layout for next time:**
```bash
# Get current layout string
Ctrl+b :list-windows -F "#{window_layout}"

# Copy the layout string and add to config:
layout: <paste-string-here>
```

### Add New Window

Edit `~/.tmuxinator/dev.yml`:

```yaml
windows:
  - main: ...
  - notes: ...
  - ai: ...
  
  # Add this:
  - database:
      layout: even-vertical
      panes:
        - psql mydb
        - redis-cli
```

---

## 🐛 Troubleshooting

### "open terminal failed: not a terminal"

**Cause:** Running from a non-interactive terminal (script, cron, etc.)  
**Fix:** Run `tmuxinator dev` directly from your terminal (iTerm2, Terminal.app)

### "undefined method 'shellescape'"

**Already fixed!** Removed `width` parameters from configs.

### Neo-tree Not Opening

```bash
# Test Neo-tree manually
nvim -c 'Neotree show'

# If error, LazyVim might not have Neo-tree installed
# Check with:
nvim -c ':Lazy'
```

### Can't Switch Windows

```bash
# List windows
Ctrl+b w

# Make sure you're pressing Ctrl+b, then release, then press the number
# Not all at once!
```

### Layout Looks Wrong

```bash
# Mouse mode is enabled - just drag pane borders!

# Or manually resize:
Ctrl+b :resize-pane -L 20   # Make left wider
Ctrl+b :resize-pane -D 10   # Make bottom shorter
```

---

## 📚 Documentation

- **Your Layout:** [`YOUR-LAYOUT.md`](./YOUR-LAYOUT.md)
- **Tmuxinator Guide:** [`TMUXINATOR-GUIDE.md`](./TMUXINATOR-GUIDE.md)
- **Session Management:** [`SESSION-MANAGEMENT.md`](./SESSION-MANAGEMENT.md)
- **Quick Reference:** [`QUICK-REFERENCE.md`](./QUICK-REFERENCE.md)

---

## ✅ Config Files

All configs fixed and validated:

- `~/.tmuxinator/dev.yml` - General development ✅
- `~/.tmuxinator/csharp.yml` - C#/.NET development ✅
- `~/.tmuxinator/web.yml` - Web/JavaScript development ✅
- `~/.tmuxinator/project.yml` - Custom project template ✅
- `~/.tmux.conf` - Tmux configuration ✅
- `~/start-dev-session.sh` - Helper script ✅

---

## 🎉 Test It Now!

```bash
# From your regular terminal (iTerm2, Terminal.app)
# NOT from inside tmux!

tmuxinator dev
```

**Expected result:**
```
✅ Tmux session "dev" created
✅ Window "main" opens with layout:
   - Left: Neo-tree file explorer
   - Top-right: Neovim code editor
   - Bottom-right: Terminal
   - Far-right: Additional terminal

✅ Windows ready:
   - 0: main (development)
   - 1: notes (Obsidian)
   - 2: ai (OpenCode)
```

**Switch windows:**
```
Ctrl+b w    # Visual selector
Ctrl+b 1    # Notes
Ctrl+b 2    # AI
Ctrl+b 0    # Back to main
```

**Does it work now?** 🚀
