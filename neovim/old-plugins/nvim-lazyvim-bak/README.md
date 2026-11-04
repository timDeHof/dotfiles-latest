# LazyVim Configuration for Web + .NET Development

A customized LazyVim setup optimized for:
- **JavaScript/TypeScript** web development
- **C#/.NET 10** development
- **AWS/Cloud** serverless architecture
- **AI Agent** development with OpenCode
- **Obsidian** note-taking

## 🚀 Quick Start

### 1. Backup Current Config
```bash
mv ~/.config/nvim ~/.config/nvim-kickstart-backup
```

### 2. Install LazyVim Config
```bash
mv ~/.config/nvim-lazyvim ~/.config/nvim
```

### 3. Start Neovim
```bash
nvim
```

LazyVim will automatically:
- Install all plugins
- Install LSP servers (csharp-ls, dockerls, terraformls, etc.)
- Install formatters (Prettier, stylua)
- Install linters (ESLint)

## 📁 Configuration Structure

```
~/.config/nvim/
├── init.lua              # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Editor options
│   │   └── keymaps.lua   # Custom keybindings
│   └── plugins/
│       ├── opencode.lua  # AI integration
│       ├── obsidian.lua  # Note-taking
│       ├── csharp.lua    # .NET/C# setup
│       ├── javascript.lua # JS/TS tooling
│       ├── cloud-devops.lua # Docker, Terraform, AWS
│       └── ui.lua        # Theme, Neo-tree, Fidget
```

## ⌨️ Key Bindings

### Leader Key: `<Space>`

#### General
- `<Space>sh` - Search help
- `<Space>sk` - Search keymaps
- `<Space>sf` - Find files
- `<Space>sg` - Live grep
- `<Space>sd` - Diagnostics
- `<Space>sn` - Search Neovim config files

#### Git
- `<Space>gg` - Open LazyGit
- `<Space>gh` - Git hunks

#### AI (OpenCode)
- `<Space>aa` - Open AI chat / Send selection

#### Obsidian
- `<Space>on` - New note
- `<Space>os` - Search notes
- `<Space>ob` - Show backlinks
- `<Space>ot` - Show tags

#### C# Debugging
- `<Space>db` - Toggle breakpoint
- `<Space>dc` - Continue debugging
- `<Space>ds` - Step over
- `<Space>di` - Step into
- `<Space>do` - Step out

#### Window Navigation
- `Ctrl+hjkl` - Move between windows

## 🛠️ Installed Tools

### Language Servers
- **csharp-ls** - C# IntelliSense
- **tsserver** - TypeScript/JavaScript
- **dockerls** - Dockerfile support
- **terraformls** - Terraform HCL
- **yamlls** - YAML (SAM, CloudFormation)
- **jsonls** - JSON with schemas
- **bashls** - Bash scripting

### Formatters
- **Prettier** - JS, TS, HTML, CSS, JSON, Markdown
- **stylua** - Lua

### Linters
- **ESLint** - JavaScript/TypeScript (antfu config)

### Debuggers
- **netcoredbg** - .NET debugging

### UI Plugins
- **Neo-tree** - File explorer
- **Heirline** - Statusline
- **Fidget** - LSP progress notifications
- **gitsigns** - Git blame in gutter
- **lazygit** - Git TUI

### Productivity
- **blink.cmp** - Autocompletion
- **friendly-snippets** - Code snippets
- **LuaSnip** - Snippet engine
- **Telescope** - Fuzzy finder
- **Projects.nvim** - Project management

## 📝 First Time Setup

### 1. Install Node.js Tools
```bash
npm install -g prettier eslint
```

### 2. Configure ESLint (antfu)
Create `.eslintrc.js` in your projects:
```javascript
module.exports = {
  extends: ['@antfu'],
}
```

### 3. Verify C# Setup
```bash
# Check .NET SDK
dotnet --version  # Should show 10.x

# Create test project
dotnet new console -n test
cd test
nvim Program.cs
```

### 4. Configure Obsidian
Your vault is set to: `~/dev/vaults`

Make sure this path exists or update it in `lua/plugins/obsidian.lua`

## 🎨 Theme

**Tokyonight Night** - Dark theme with blue-purple tones
- Italics disabled in comments (per your preference)
- Custom highlight overrides for TODOs

## 🤖 AI Integration

### OpenCode
- Chat interface inside Neovim
- Auto-includes current file context
- Send selections with visual mode

Usage:
1. Open a file
2. Press `<Space>aa` to open chat
3. Ask questions about your code
4. Select text + `<Space>aa` to send context

## 📚 Learning Resources

### LazyVim
- [Official Docs](https://www.lazyvim.org/)
- [Keybindings](https://www.lazyvim.org/configuration/keymaps)
- [Plugins](https://www.lazyvim.org/plugins)

### C# in Neovim
- `:help lspconfig-setup` - LSP configuration
- `:LspInfo` - Check LSP status
- `:DapInfo` - Check debugger status

### LazyGit
- Press `?` inside LazyGit for help
- [LazyGit Tutorial](https://github.com/jesseduffield/lazygit#tutorial)

## 🔧 Troubleshooting

### LSP Not Working
```vim
:LspInfo          " Check LSP status
:LspRestart       " Restart LSP
:Mason            " Check installed servers
```

### Debugger Issues
```vim
:DapInfo          " Check debugger status
:Mason            " Ensure netcoredbg installed
```

### Plugin Errors
```vim
:Lazy             " Open Lazy plugin manager
:Lazy check       " Check for issues
:Lazy sync        " Update all plugins
```

### Clear Cache
```bash
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/state/nvim/lazy
```

## 🎯 Next Steps

1. **Learn LazyVim basics** - Press `<Space>sk` to see all keymaps
2. **Try LazyGit** - `<Space>gg`, press `?` for help
3. **Test C# setup** - Create a new .NET project
4. **Configure Obsidian** - Create your first note
5. **Try OpenCode** - Ask AI about your code

## 🪟 Tmux + Session Management

### Why Both?
- **Tmux** = Terminal multiplexing (detach/attach, multiple projects)
- **Neovim Sessions** = Editor layout (files, splits, plugin state)
- **Tmuxinator** = Automated session layouts (YAML configs)
- **Together** = Ultimate development environment!

### Quick Start

```bash
# Install tmux (if not already)
brew install tmux

# Install tmuxinator
brew install tmuxinator

# Start a predefined session
tmuxinator dev          # General development
tmuxinator csharp       # C#/.NET development
tmuxinator web          # Web/JavaScript development
```

### Essential Keys

**Tmux (Prefix: `Ctrl+b`):**
- `Ctrl+b \|` - Vertical split
- `Ctrl+b "` - Horizontal split
- `Ctrl+b h/j/k/l` - Navigate panes
- `Ctrl+b z` - Zoom pane
- `Ctrl+b d` - Detach (leave running)
- `Ctrl+b [` - Copy mode
- `Ctrl+b c` - New window
- `Ctrl+b w` - List windows

**Neovim Sessions:**
- `<Space>qw` - Save session
- `<Space>ql` - Load last session
- `<Space>qq` - Save and quit

### Tmuxinator Commands

```bash
tmuxinator dev          # Start dev session
tmuxinator edit dev     # Edit config
tmuxinator stop dev     # Stop session
tmuxinator list         # List all configs
```

### Full Guides
- **Tmuxinator:** [`TMUXINATOR-GUIDE.md`](./TMUXINATOR-GUIDE.md)
- **Tmux Setup:** [`TMUX-SETUP.md`](./TMUX-SETUP.md)
- **Quick Reference:** [`QUICK-REFERENCE.md`](./QUICK-REFERENCE.md)

Enjoy your new setup! 🚀
