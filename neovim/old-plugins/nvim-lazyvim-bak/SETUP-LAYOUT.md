# 🎨 Perfect Layout Setup Guide

## ⚠️ Important: Do This In Order

---

## Step 1: Reload Tmux Config

**From your regular terminal (not inside tmux):**

```bash
# Kill all tmux sessions first
tmux kill-server

# Start fresh with new config
tmuxinator dev
```

---

## Step 2: Inside Tmux - Setup Layout

**You should see one Neovim instance. Now:**

```bash
# 1. Open Neo-tree on left
<Space>e

# 2. Create horizontal split (terminal on bottom)
Ctrl+b "

# 3. You now have 3 panes:
#    - Left: Neo-tree
#    - Top-right: Code
#    - Bottom-right: Terminal

# 4. Adjust sizes with mouse:
#    - Drag left border right (make Neo-tree ~25% width)
#    - Drag bottom border up (make terminal ~10 lines)

# OR use keyboard:
Ctrl+b :resize-pane -L 20    # Make Neo-tree wider
Ctrl+b :resize-pane -D 10    # Make terminal shorter
```

---

## Step 3: Save Everything

```bash
# Focus on code pane (top-right)
Ctrl+b k    # or click with mouse

# Save Neovim session
<Space>qw

# Detach tmux
Ctrl+b d
```

---

## Step 4: Reattach Later

```bash
# Your layout is saved by tmux!
tmux attach -t dev
```

---

## 🎯 Alternative: Use the Setup Script

**If manual layout is annoying:**

```bash
# 1. Start tmuxinator
tmuxinator dev

# 2. Kill all panes until you have just one
# (or just start fresh)

# 3. Run the setup script
~/setup-tmux-layout.sh

# 4. Open Neovim in each pane
# Left: nvim -c 'Neotree show'
# Top-right: nvim
# Bottom-right: (already zsh)

# 5. Save
<Space>qw
```

---

## 🎨 What You Should See

```
┌──────────────┬─────────────────────────┐
│              │                         │
│  Neo-tree    │      Program.cs         │
│              │      (code editor)      │
│  (25% width) │                         │
│              ├─────────────────────────┤
│              │                         │
│              │      zsh                │
│              │      (terminal)         │
│              │                         │
└──────────────┴─────────────────────────┘
```

---

## 🐛 Troubleshooting

### "no current client" warning

**Cause:** Running tmux commands outside tmux  
**Fix:** Make sure you're inside tmux when running layout commands

### Wrong layout

**Fix:** Kill tmux completely and start fresh:
```bash
# From regular terminal
tmux kill-server
tmuxinator dev

# Inside tmux, setup layout manually
<Space>e          # Neo-tree
Ctrl+b "          # Split for terminal
```

### Can't resize panes

**Fix:** Use mouse mode (it's enabled!):
```
Just drag pane borders with your mouse!
```

### Neo-tree takes full width

**Fix:** It's in a different pane. Close it and reopen:
```bash
# Close Neo-tree
<Space>e

# Make sure focus is on left pane
Ctrl+b h

# Open Neo-tree again
<Space>e
```

---

## ⌨️ Quick Layout Commands

**Inside tmux:**

```bash
# Create layout manually:
<Space>e              # Neo-tree (left)
Ctrl+b |              # Split vertical (if needed)
Ctrl+b "              # Split horizontal (terminal bottom)

# Resize:
Ctrl+b :resize-pane -L 20    # Left pane wider
Ctrl+b :resize-pane -D 10    # Bottom pane shorter

# Or use mouse - just drag borders!
```

---

## ✅ Final Workflow

```bash
# Morning: Start
tmuxinator dev

# Inside tmux:
<Space>e              # Neo-tree
Ctrl+b "              # Terminal split
# Adjust with mouse
<Space>ql             # Load Neovim session

# Evening: Save & Leave
<Space>qw             # Save Neovim
:qa                   # Quit Neovim
Ctrl+b d              # Detach tmux

# Next day:
tmux attach -t dev    # Layout preserved!
```

---

**Does this work for you?** 🎨

The key is: **Setup layout once manually, tmux remembers it forever!**
