# Quick Reference: Tmux + Neovim

## 🚀 Start Development Session

```bash
# Attach to dev session (creates if doesn't exist)
~/.tmux-session-manager.sh attach dev

# Or manually
tmux attach -t dev
```

---

## ⌨️ Tmux Essential Keys

**Prefix:** `Ctrl+b` (press together, release, then press command)

### Splits
| Keys | Action |
|------|--------|
| `Ctrl+b \|` | Split vertically (left/right) |
| `Ctrl+b "` | Split horizontally (top/bottom) |
| `Ctrl+b h/j/k/l` | Navigate panes |
| `Ctrl+b z` | Zoom/unzoom pane |

### Windows
| Keys | Action |
|------|--------|
| `Ctrl+b c` | Create new window |
| `Ctrl+b n/p` | Next/previous window |
| `Ctrl+b 0-9` | Select window by number |
| `Ctrl+b w` | List windows |
| `Ctrl+b &` | Kill window |

### Sessions
| Keys | Action |
|------|--------|
| `Ctrl+b d` | Detach (leave running) |
| `Ctrl+b s` | List sessions |
| `Ctrl+b D` | Choose session |

### Copy Mode
| Keys | Action |
|------|--------|
| `Ctrl+b [` | Enter copy mode |
| `v` | Select text |
| `y` or `Enter` | Copy |
| `Ctrl+b ]` | Paste |
| `Ctrl+v` | Paste from system clipboard |

---

## ⌨️ Neovim Essential Keys

**Leader:** `<Space>` (press space, then command)

### Sessions
| Keys | Action |
|------|--------|
| `<Space>qw` | Save session |
| `<Space>ql` | Load last session |
| `<Space>qq` | Save and quit |

### Files & Navigation
| Keys | Action |
|------|--------|
| `<Space>e` | Toggle Neo-tree (file explorer) |
| `<Space>ff` | Find files |
| `<Space>fg` | Find in files (grep) |
| `<Space>fb` | Find buffers |

### Git
| Keys | Action |
|------|--------|
| `<Space>gg` | LazyGit (full TUI) |
| `<Space>gb` | Git blame |
| `<Space>gd` | Git diff |

### Terminal
| Keys | Action |
|------|--------|
| `<Space>ft` | Terminal (bottom) |
| `<Space>fT` | Terminal (right) |
| `<C-\>` | Toggle terminal |

### AI & Notes
| Keys | Action |
|------|--------|
| `<Space>og` | Open OpenCode AI |
| `<Space>oq` | Close OpenCode |
| `<Space>on` | New Obsidian note |
| `<Space>os` | Search Obsidian |

### Code
| Keys | Action |
|------|--------|
| `<Space>db` | Toggle breakpoint |
| `<Space>dc` | Continue debugging |
| `<Space>dr` | Run to cursor |
| `<Space>ca` | Code action |
| `<Space>rr` | Rename symbol |

---

## 🎯 Typical Workflow

### Morning: Start
```bash
# 1. Attach to tmux session
~/.tmux-session-manager.sh attach dev

# 2. Open Neovim
nvim

# 3. Restore layout
<Space>ql

# 4. You're ready!
```

### During Work
```bash
# Open file explorer
<Space>e

# Find file
<Space>ff

# Check git
<Space>gg

# Open terminal
<Space>ft

# Ask AI
<Space>og
```

### End of Day
```bash
# Save Neovim session
<Space>qw

# Quit Neovim
:qa

# Detach tmux (keeps running)
Ctrl+b d
```

---

## 🎨 Layout Example

```
┌────────────┬─────────────┬──────────────┐
│ Neo-tree   │ Program.cs  │ LazyGit      │
│ (left)     │ (top)       │ (right)      │
│            ├─────────────┤              │
│            │ Terminal    │              │
│            │ (bottom)    │              │
└────────────┴─────────────┴──────────────┘
```

**Create this layout:**
```bash
# In tmux:
<Space>e           # Neo-tree
Ctrl+w v           # Vertical split
Ctrl+w s           # Horizontal split
:term zsh          # Terminal
<Space>gg          # LazyGit (in right pane)

# Save it!
<Space>qw
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Colors wrong | `export TERM=screen-256color` |
| Can't paste | Check Accessibility permissions |
| Session not saving | Use `:qa` not `:q` to quit |
| Terminal not restoring | That's normal! Use tmux for terminals |
| LazyGit not opening | Install: `brew install lazygit` |

---

## 📚 Full Guides

- **Tmux Setup:** `~/.config/nvim-lazyvim/TMUX-SETUP.md`
- **Neovim Config:** `~/.config/nvim-lazyvim/README.md`
- **Tmux Config:** `~/.tmux.conf`
- **Session Manager:** `~/.tmux-session-manager.sh`

---

## 🎉 You're Ready!

**Tmux** = Terminal sessions (detach/attach, multiple projects)  
**Neovim** = Editor layout (files, splits, plugins)  
**Both** = Ultimate dev environment! 🚀
