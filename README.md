# Neovim Config

Personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.

## Requirements

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)

## Installation

1. Backup existing config (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/atterpac/nvim-dots.git ~/.config/nvim
   ```

3. Create undo directory:
   ```bash
   mkdir -p ~/.vim/undodir
   ```

4. Open Neovim - plugins will install automatically on first launch:
   ```bash
   nvim
   ```

## Plugins

| Plugin | Purpose |
|--------|---------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Utilities |
| [leap.nvim](https://github.com/ggandor/leap.nvim) | Motion |
| [copilot.vim](https://github.com/github/copilot.vim) | AI completion |
| [octo.nvim](https://github.com/pwntester/octo.nvim) | GitHub integration |

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Neovim options
│   │   └── keymaps.lua   # Key mappings
│   └── plugins/          # Plugin configurations
```
