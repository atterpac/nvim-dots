-- Leader key must be set before lazy.nvim loads
vim.g.mapleader = " "

-- File explorer (Oil)
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)

-- Move chunks of selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- J move with cursor in the same place
vim.keymap.set("n", "J", "mzJ`z")

-- Half page jumps with cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search keeps cursor centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Preserves copy buffer when pasting over
vim.keymap.set("x", "<leader>p", "\"_dp")
vim.keymap.set("n", "<leader>d", "\"_d") -- Normal
vim.keymap.set("v", "<leader>d", "\"_d") -- Visual

-- Quick Fix Navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Quick Save
vim.keymap.set("n", "<leader>w", ":update<cr>")
vim.keymap.set("i", "<C-s>", "<Esc>:update<cr>")

-- Go to Definition (fallback - LSP overrides this)
vim.keymap.set("n", "<leader>g", "<C-]>")
vim.keymap.set("n", "<leader>r", "<C-o>")
