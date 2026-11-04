# Your Perfect Layout Guide

## 🎨 Layout Design

**Key Requirements:**
- ✅ Neo-tree always visible on the left
- ✅ Terminal below code (not to the right)
- ✅ Multiple windows for notes and OpenCode

---

## 📊 Window Structure

### Window 1: **main** (Development)

```
┌─────────────────────────────────────────────────────┐
│ Window: main                                        │
├──────────────┬──────────────────────────────────────┤
│              │                                      │
│  Neo-tree    │           Code Editor                │
│   (left)     │             (top)                    │
│              │           Program.cs                 │
│   25%        ├──────────────────────────────────────┤
│              │                                      │
│              │              Terminal                │
│              │            (bottom)                  │
│              │               zsh                    │
│              │                                      │
└──────────────┴──────────────────────────────────────┘
```

**Layout:** `main-horizontal`
- **Left pane (25%):** Neo-tree file explorer
- **Right-top (50%):** Neovim code editor
- **Right-bottom (25%):** Terminal

---

### Window 2: **notes** (Obsidian)

```
┌─────────────────────────────────────────────────────┐
│ Window: notes                                       │
├─────────────────────────┬───────────────────────────┤
│                         │                           │
│    Obsidian Vault       │        Terminal           │
│      (left 60%)         │       (right 40%)         │
│                         │                           │
│   Daily notes           │   Git commands            │
│   Project notes         │   Quick scripts           │
│                         │                           │
└─────────────────────────┴───────────────────────────┘
```

**Layout:** `main-vertical`
- **Left pane (60%):** Neovim in Obsidian vault
- **Right pane (40%):** Terminal for git/commands

---

### Window 3: **ai** (OpenCode)

```
┌─────────────────────────────────────────────────────┐
│ Window: ai                                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│              Neovim (OpenCode)                      │
│                (top 70%)                            │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│                 Terminal                            │
│               (bottom 30%)                          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Layout:** `main-vertical`
- **Top pane (70%):** Neovim for OpenCode AI chat
- **Bottom pane (30%):** Terminal for running code

---

## 🎮 Navigation

### Switch Windows

```bash
# From inside tmux
Ctrl+b w          # List windows (visual selector)
Ctrl+b 0          # Window 0 (main)
Ctrl+b 1          # Window 1 (notes)
Ctrl+b 2          # Window 2 (ai)

# Or by name
Ctrl+b :select-window -t notes
Ctrl+b :select-window -t ai
Ctrl+b :select-window -t main
```

### Navigate Panes

```bash
# Vim-style pane navigation
Ctrl+b h          # Move to left pane
Ctrl+b j          # Move to bottom pane
Ctrl+b k          # Move to top pane
Ctrl+b l          # Move to right pane
```

### Resize Panes

```bash
# Hold Ctrl+b and press repeatedly
Ctrl+b Ctrl+h     # Resize left
Ctrl+b Ctrl+j     # Resize down
Ctrl+b Ctrl+k     # Resize up
Ctrl+b Ctrl+l     # Resize right

# Or use commands
Ctrl+b :resize-pane -L 10    # Resize left 10 cells
Ctrl+b :resize-pane -R 10    # Resize right 10 cells
Ctrl+b :resize-pane -U 10    # Resize up 10 cells
Ctrl+b :resize-pane -D 10    # Resize down 10 cells
```

---

## 🚀 Start Your Session

### From Regular Terminal (not inside tmux)

```bash
# Start development session
tmuxinator dev
```

**Result:**
```
✅ Tmux session "dev" created
✅ Window "main" opens with your layout:
   - Left: Neo-tree file explorer
   - Top-right: Neovim code editor
   - Bottom-right: Terminal

✅ Windows "notes" and "ai" are ready:
   - Ctrl+b w to switch
   - Or Ctrl+b 1, Ctrl+b 2
```

---

## 🎯 Typical Workflow

### Morning: Start Work

```bash
# Start session
tmuxinator dev

# You're in Window 1 (main) with:
# - Neo-tree on left
# - Neovim code editor top-right
# - Terminal bottom-right

# Load your Neovim session (files, splits)
<Space>ql
```

### During Work

```bash
# Working on code (Window 1: main)
# Neo-tree visible, editing code, terminal ready

# Need to take notes?
Ctrl+b 1        # Switch to Window 2 (notes)
# Now in Obsidian vault with terminal

# Need AI help?
Ctrl+b 2        # Switch to Window 3 (ai)
# Open OpenCode AI with terminal below

# Back to coding?
Ctrl+b 0        # Switch to Window 0 (main)
```

### End of Day

```bash
# Save Neovim session (in current window)
<Space>qw

# Quit Neovim
:qa

# Detach tmux (keeps everything running)
Ctrl+b d

# OR stop completely
tmuxinator stop dev
```

---

## 📝 Customize Layout

### Edit Config

```bash
tmuxinator edit dev
```

### Adjust Pane Sizes

In the YAML, adjust `width` percentages:

```yaml
windows:
  - main:
      layout: main-horizontal
      panes:
        # Make Neo-tree wider
        - width: 30          # Was 25
          shell_command_before: nvim -c 'Neotree show'
        
        - layout: main-vertical
          panes:
            # Make code editor taller
            - nvim
            # Make terminal shorter
            - zsh
```

### Change Window Order

```yaml
windows:
  - ai: ...          # Window 0
  - main: ...        # Window 1
  - notes: ...       # Window 2
```

### Add New Window

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

## 🎨 Layout Options Reference

| Layout Name | Description | Best For |
|------------|-------------|----------|
| `main-horizontal` | Large left pane, right side split horizontally | Your main window |
| `main-vertical` | Large top pane, bottom split vertically | Notes, AI windows |
| `even-horizontal` | Equal-width panes side by side | Side-by-side comparison |
| `even-vertical` | Equal-height panes stacked | Terminal stacks |
| `tiled` | Grid of equal panes | Multiple terminals |
| `custom` | Custom layout string | Advanced users |

---

## 🐛 Troubleshooting

### Neo-tree Not Opening

```bash
# Check if Neo-tree is installed
nvim -c ':Neotree show'

# If error, install Neo-tree
# LazyVim should have it already
```

### Wrong Layout

```bash
# Manual adjustment inside tmux:
Ctrl+b :resize-pane -L 20   # Make left pane wider
Ctrl+b :resize-pane -D 10   # Make bottom pane shorter

# Save layout for next time:
Ctrl+b :list-windows -F "#{window_layout}"
# Copy the layout string and add to config:
# layout: <paste-string-here>
```

### Can't Switch Windows

```bash
# List windows
Ctrl+b w

# Select by number
Ctrl+b 0, Ctrl+b 1, Ctrl+b 2

# Or by name
Ctrl+b :select-window -t main
```

---

## ✅ Success Checklist

- [x] Neo-tree on left (25% width)
- [x] Code editor top-right
- [x] Terminal bottom-right
- [x] Window 1: main (development)
- [x] Window 2: notes (Obsidian)
- [x] Window 3: ai (OpenCode)
- [ ] Test `tmuxinator dev` ← **You are here!**
- [ ] Customize pane sizes to your preference
- [ ] Add any additional windows you need

---

## 🎉 Test It Now!

```bash
# From regular terminal (not inside tmux)
tmuxinator dev
```

**Expected:**
```
┌──────────────┬─────────────────────────┐
│ Neo-tree     │ Code Editor             │
│ (visible!)   │ (top)                   │
│              ├─────────────────────────┤
│              │ Terminal                │
│              │ (bottom)                │
└──────────────┴─────────────────────────┘

Windows: [0:main] 1:notes 2:ai
```

**Switch windows:**
```
Ctrl+b w    # Visual selector
Ctrl+b 1    # Notes window
Ctrl+b 2    # AI window
Ctrl+b 0    # Back to main
```

**Does this match your ideal layout?** 🎨
