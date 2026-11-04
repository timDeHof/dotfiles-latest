# Tmux + Neovim Session Management Guide

## 🎯 Why Both?

**Tmux** handles:
- Terminal multiplexing (multiple terminals in one window)
- Detach/attach (keep sessions running in background)
- Multiple projects simultaneously
- SSH-friendly remote development

**Neovim Sessions** handle:
- File layout within Neovim
- Window splits (Neo-tree, code, terminal)
- Plugin state (open buffers, cursor positions)
- Working directory

**Together** = Perfect development environment! 🎉

---

## 🚀 Quick Start

### 1. Install Tmux (if not already installed)

```bash
# macOS with Homebrew
brew install tmux

# Verify installation
tmux -V
```

### 2. Install Tmux Plugin Manager (TPM)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 3. Restart Tmux

```bash
# If already in tmux, exit first
exit

# Start fresh tmux session
tmux
```

### 4. Install Tmux Plugins

Inside tmux, press:
```
Ctrl+b I  (capital I, installs TPM plugins)
```

---

## 📋 Using the Session Manager

### Create New Development Session

```bash
# Using the helper script
~/.tmux-session-manager.sh new myproject ~/dev/myproject

# Or manually
tmux new -s myproject
```

### Attach to Session

```bash
# Using the helper script (creates if doesn't exist)
~/.tmux-session-manager.sh attach myproject

# Or manually
tmux attach -t myproject
```

### List All Sessions

```bash
~/.tmux-session-manager.sh list
# or
tmux list-sessions
```

### Kill Session

```bash
~/.tmux-session-manager.sh kill myproject
# or
tmux kill-session -t myproject
```

---

## 🎮 Tmux Keybindings

### Window Management

| Keybinding | Action |
|------------|--------|
| `Ctrl+b c` | Create new window |
| `Ctrl+b &` | Kill current window |
| `Ctrl+b n` | Next window |
| `Ctrl+b p` | Previous window |
| `Ctrl+b 0-9` | Select window by number |
| `Ctrl+b w` | List windows |
| `Ctrl+b ,` | Rename window |

### Pane Splits

| Keybinding | Action |
|------------|--------|
| `Ctrl+b \|` | Vertical split (left/right) |
| `Ctrl+b "` | Horizontal split (top/bottom) |
| `Ctrl+b h` | Move to left pane |
| `Ctrl+b j` | Move to bottom pane |
| `Ctrl+b k` | Move to top pane |
| `Ctrl+b l` | Move to right pane |
| `Ctrl+b z` | Zoom/unzoom current pane |

### Resize Panes

Hold `Ctrl+b` then press repeatedly:

| Key | Action |
|-----|--------|
| `H` | Resize left |
| `J` | Resize down |
| `K` | Resize up |
| `L` | Resize right |

### Copy Mode (Vim-style)

| Keybinding | Action |
|------------|--------|
| `Ctrl+b [` | Enter copy mode |
| `v` | Start selection |
| `y` or `Enter` | Copy selection |
| `Ctrl+b ]` | Paste selection |
| `Ctrl+v` | Paste from system clipboard |

### Session Management

| Keybinding | Action |
|------------|--------|
| `Ctrl+b d` | Detach from session |
| `Ctrl+b s` | List sessions |
| `Ctrl+b D` | Choose session to detach |

---

## 📝 Neovim Sessions Inside Tmux

### Inside a tmux pane, run Neovim:

```bash
tmux attach -t myproject
nvim /path/to/project
```

### Neovim Session Commands

| Keybinding | Action |
|------------|--------|
| `<Space>qw` | Save Neovim session |
| `<Space>ql` | Load last Neovim session |
| `<Space>qs` | Choose session to load |
| `<Space>qq` | Save session and quit |
| `<Space>qd` | Don't save current session |

### Recommended Workflow

1. **Start tmux session:**
   ```bash
   ~/.tmux-session-manager.sh attach dev
   ```

2. **Open Neovim in a pane:**
   ```bash
   nvim ~/dev/myproject/src/Program.cs
   ```

3. **Setup layout inside Neovim:**
   ```
   <Space>e          # Neo-tree left
   Ctrl+w v          # Vertical split
   Ctrl+w s          # Horizontal split
   :term zsh         # Terminal
   ```

4. **Save Neovim session:**
   ```
   <Space>qw
   ```

5. **Detach from tmux:**
   ```
   Ctrl+b d
   ```

6. **Later, reattach:**
   ```bash
   ~/.tmux-session-manager.sh attach dev
   # Neovim is still running with all buffers!
   # Load session to restore layout:
   <Space>ql
   ```

---

## 🎨 Custom Layouts

### Quick Development Layout

Inside tmux:
```bash
# Create layout: Neo-tree | code | terminal
tmux split-window -h -l 25   # Neo-tree left
tmux select-pane -t 0
tmux send-keys "nvim -c 'Neotree show'" Enter

tmux select-pane -t 1
tmux split-window -v -l 10   # Terminal bottom
tmux send-keys "zsh" Enter
```

### Using the Helper Command

Inside Neovim:
```vim
:TmuxLayout    # Setup tmux-friendly layout
:LazyGitSplit  # Open LazyGit in vertical split
```

---

## 🔧 Tmux Configuration

Your config is at `~/.tmux.conf`

### Key Features:
- ✅ Vim-style pane navigation (`hjkl`)
- ✅ Vim-style copy mode
- ✅ macOS clipboard integration
- ✅ 24-bit color support
- ✅ Mouse support
- ✅ Status bar with session info
- ✅ Plugin support via TPM

### Reload Config

```bash
# Inside tmux
tmux source-file ~/.tmux.conf
```

---

## 🐛 Troubleshooting

### Terminal colors look wrong

```bash
# Set correct terminal type
export TERM=screen-256color
```

### Neovim sessions not restoring terminals

This is normal! Use tmux for terminal persistence, Neovim sessions for file layout.

### Can't copy/paste to system clipboard

Make sure tmux has accessibility permissions on macOS:
- System Preferences → Security & Privacy → Privacy → Accessibility
- Add terminal app (iTerm2, Terminal.app)

### Tmux plugins not loading

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins
# Inside tmux: Ctrl+b I
```

---

## 🎯 Example Daily Workflow

### Morning: Start Working

```bash
# Attach to dev session (or create if doesn't exist)
~/.tmux-session-manager.sh attach dev

# Inside tmux, navigate to project
cd ~/dev/myproject

# Open Neovim
nvim

# Restore Neovim session
<Space>ql

# You're ready! All files, splits, and terminals restored!
```

### During Work

```bash
# Need a new terminal?
Ctrl+b "        # Horizontal split
:term zsh       # New terminal

# Need to check git?
<Space>gg       # LazyGit

# Working on multiple features?
Ctrl+b c        # New window
Ctrl+b 1        # Switch to window 1
Ctrl+b 2        # Switch to window 2
```

### End of Day: Save & Leave

```bash
# Inside Neovim
<Space>qw       # Save Neovim session

# Exit Neovim
:qa

# Detach from tmux (keeps everything running)
Ctrl+b d

# Or kill the session if done
~/.tmux-session-manager.sh kill dev
```

---

## 📚 Additional Resources

- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Neovim Persistence Documentation](https://github.com/folke/persistence.nvim)
- [Tmux TPM Plugins](https://github.com/tmux-plugins/tpm)

---

## 🎉 You're All Set!

**Tmux** manages your terminal sessions  
**Neovim** manages your editor layout  
**Together** = Ultimate development environment! 🚀
