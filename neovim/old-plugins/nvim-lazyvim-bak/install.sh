#!/bin/bash
# LazyVim Installation Script
# This script will set up your LazyVim configuration

set -e

echo "🚀 LazyVim Installation Script"
echo "==============================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}❌ Neovim is not installed${NC}"
    echo "Please install Neovim first: https://neovim.io/doc/user/build.html"
    exit 1
fi
echo -e "${GREEN}✓${NC} Neovim is installed"

# Check .NET SDK
if command -v dotnet &> /dev/null; then
    DOTNET_VERSION=$(dotnet --version)
    echo -e "${GREEN}✓${NC} .NET SDK $DOTNET_VERSION is installed"
else
    echo -e "${YELLOW}⚠${NC} .NET SDK not found (optional for C# development)"
fi

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} Node.js $NODE_VERSION is installed"
else
    echo -e "${YELLOW}⚠${NC} Node.js not found (required for Prettier/ESLint)"
fi

# Backup existing config
if [ -d ~/.config/nvim ] && [ ! -d ~/.config/nvim-backup ]; then
    echo ""
    echo -e "${YELLOW}⚠${NC} Found existing Neovim config"
    read -p "Do you want to backup it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv ~/.config/nvim ~/.config/nvim-backup-$(date +%Y%m%d)
        echo -e "${GREEN}✓${NC} Backed up existing config"
    fi
fi

# Install LazyVim config
echo ""
echo "📦 Installing LazyVim configuration..."

if [ -d ~/.config/nvim-lazyvim ]; then
    # Check if already linked
    if [ -L ~/.config/nvim ]; then
        echo -e "${YELLOW}⚠${NC} LazyVim config is already active"
        read -p "Do you want to reinstall? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled"
            exit 0
        fi
        unlink ~/.config/nvim
    fi
    
    ln -s ~/.config/nvim-lazyvim ~/.config/nvim
    echo -e "${GREEN}✓${NC} LazyVim configuration linked"
else
    echo -e "${RED}❌${NC} LazyVim config directory not found"
    echo "Make sure you're running this from the correct location"
    exit 1
fi

# Install global npm packages if Node.js is available
if command -v npm &> /dev/null; then
    echo ""
    echo "📦 Installing global npm packages..."
    npm install -g prettier eslint typescript typescript-language-server 2>/dev/null || {
        echo -e "${YELLOW}⚠${NC} Some npm packages may have failed to install"
    }
    echo -e "${GREEN}✓${NC} npm packages installed"
fi

# First run instructions
echo ""
echo "=================================="
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo "=================================="
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Start Neovim:"
echo "   ${YELLOW}nvim${NC}"
echo ""
echo "2. Wait for plugins to install (first launch takes longer)"
echo ""
echo "3. Check plugin status:"
echo "   ${YELLOW}:Lazy${NC}"
echo ""
echo "4. Check LSP status:"
echo "   ${YELLOW}:LspInfo${NC}"
echo ""
echo "5. Install Mason tools:"
echo "   ${YELLOW}:Mason${NC}"
echo ""
echo "📚 Key bindings to remember:"
echo "   ${YELLOW}<Space>sk${NC}  - View all keymaps"
echo "   ${YELLOW}<Space>gg${NC}  - Open LazyGit"
echo "   ${YELLOW}<Space>aa${NC}  - OpenCode AI chat"
echo "   ${YELLOW}<Space>on${NC}  - New Obsidian note"
echo "   ${YELLOW}<Space>sf${NC}  - Find files"
echo ""
echo "📖 Documentation: ~/.config/nvim/README.md"
echo ""
echo "Happy coding! 🎉"
