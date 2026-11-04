# Your Layout Guide

## 🎨 What You're Seeing vs What You Want

### Current (tmuxinator default):
```
┌─────────────────────────────────────────┐
│ LazyVim (full width)                    │
├─────────────────────────────────────────┤
│ Terminal 1                              │
├─────────────────────────────────────────┤
│ Terminal 2                              │
└─────────────────────────────────────────┘
```

### What You Want:
```
┌──────────────┬─────────────────────────┐
│              │  Code Editor            │
│  Neo-tree    │  (top)                  │
│  (left)      ├─────────────────────────┤
│              │  Terminal               │
│              │  (bottom)               │
└──────────────┴─────────────────────────┘
```

---

## 🚀 Quick Fix: Manual Layout Setup

### Step 1: Start tmuxinator

```bash
tmuxinator dev
```

### Step 2: Inside tmux, reset the layout

```bash
# Close all existing panes (if needed)
# Just keep one Neovim instance

# Open Neo-tree on left
<Space>e

# Make Neo-tree pane 25% width
# (drag border with mouse or use Ctrl+b Ctrl+h)

# Create vertical split for code + terminal
Ctrl+b "

# You now have:
# Left: Neo-tree
# Top-right: Neovim
# Bottom-right: Terminal

# Save this layout
Ctrl+b :set-window-option main-horizontal
```

### Step 3: Save Neovim session

```bash
<Space>qw
```

---

## 📝 Better Approach: Simple Tmuxinator Config

The issue is tmuxinator creates all panes equal by default. Let me create a simpler config:

```yaml
# ~/.tmuxinator/dev.yml
name: dev
root: ~/dev
pre_window: export TERM=screen-256color

windows:
  - main:
      - nvim -c 'Neotree show'  # Left pane
      - nvim                     # Will be top-right
      - zsh                      # Will be bottom-right
```

After it opens, manually adjust once, then tmux will remember!

---

## 🎯 Recommended Workflow

Since tmuxinator layouts can be tricky, here's the best approach:

### Option 1: Start Simple, Adjust Once

```bash
# 1. Start tmuxinator
tmuxinator dev

# 2. Inside tmux, close extra panes
# Keep just one Neovim

# 3. Setup your layout manually
<Space>e              # Open Neo-tree
Ctrl+b "              # Split horizontal (creates bottom pane)
:term zsh             # Terminal in bottom pane

# 4. Adjust Neo-tree width
# Drag the border with your mouse!

# 5. This layout is now saved for this tmux session
```

### Option 2: Use Tmux Only (No Tmuxinator)

```bash
# Create session manually
tmux new -s dev

# Inside tmux:
nvim                  # Open Neovim
<Space>e              # Neo-tree
Ctrl+b "              # Split for terminal
:term zsh             # Terminal

# Detach
Ctrl+b d

# Reattach later
tmux attach -t dev
# Your layout is preserved!
```

### Option 3: Tmuxinator + Manual Save

```bash
# Start with tmuxinator
tmuxinator dev

# Adjust layout manually (drag with mouse)

# Save tmux session
tmux kill-session -t dev
tmuxinator stop dev

# Next time, just attach - layout is saved by tmux!
tmux attach -t dev
```

---

## 🎨 Mouse Mode is Your Friend!

**Your tmux.conf has mouse mode enabled!**

```bash
# Just drag pane borders with your mouse!
# No need for complex keyboard shortcuts

# To resize:
1. Hover over pane border
2. Click and drag
3. Done!
```

---

## ⌨️ Keyboard Layout Adjustment

If you prefer keyboard:

```bash
# After tmuxinator dev opens:

# Focus on left pane (Neo-tree)
Ctrl+b h

# Resize it to 25% (about 40 cells)
Ctrl+b :resize-pane -l 40

# Or resize relative to current
Ctrl+b :resize-pane -L 20    # Make 20 cells wider

# Focus on bottom pane (terminal)
Ctrl+b j

# Resize it to 10 lines
Ctrl+b :resize-pane -l 10
```

---

## ✅ Best Solution: Hybrid Approach

**Use tmuxinator to start, then let tmux save the layout:**

```bash
# 1. First time setup
tmuxinator dev

# 2. Adjust layout (drag with mouse or keyboard)
# - Neo-tree left ~25%
# - Code top ~60%
# - Terminal bottom ~15%

# 3. Save Neovim session
<Space>qw

# 4. Detach (don't kill!)
Ctrl+b d

# 5. Next time, just attach
tmux attach -t dev
# Layout is preserved by tmux!
```

**Why this works better:**
- Tmuxinator starts everything
- Tmux remembers the exact layout
- No complex YAML needed
- Mouse-friendly adjustment

---

## 🎯 Test It Now

```bash
# 1. Start
tmuxinator dev

# 2. Adjust layout (use mouse to drag borders!)
# - Make left pane narrower for Neo-tree
# - Make bottom pane shorter for terminal

# 3. Save Neovim session
<Space>qw

# 4. Detach
Ctrl+b d

# 5. Reattach later
tmux attach -t dev
```

**Your layout will be saved by tmux!** 🎉

---

## 📋 Window Switching Still Works

```bash
# Even with manual layout, windows work:
Ctrl+b w          # Switch windows
Ctrl+b 0          # main
Ctrl+b 1          # notes
Ctrl+b 2          # ai
```

---

**Does this approach work better for you?** 🎨

The key insight: **Let tmux save the layout, not tmuxinator!**
