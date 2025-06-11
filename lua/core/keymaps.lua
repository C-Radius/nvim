-- Keybindings
vim.g.mapleader = ","

local keymap = vim.keymap.set
local opts = { silent = true }

-- Config edit/reload
keymap("n", "<leader>ev", ":e $MYVIMRC<CR>", opts)
keymap("n", "<leader>sv", ":so $MYVIMRC<CR>", opts)
keymap("n", "<leader>cd", ":cd %:h<CR>", opts)

-- Insert mode escape
keymap("i", "<C-c>", "<Esc>", {})
keymap("i", "jj", "<Esc>", {})

-- Window navigation (Insert + Normal mode)
keymap("i", "<M-l>", "<C-w>l", {})
keymap("i", "<M-h>", "<C-w>h", {})
keymap("i", "<M-k>", "<C-w>k", {})
keymap("i", "<M-j>", "<C-w>j", {})
keymap("n", "<M-l>", "<C-w>l", {})
keymap("n", "<M-h>", "<C-w>h", {})
keymap("n", "<M-k>", "<C-w>k", {})
keymap("n", "<M-j>", "<C-w>j", {})

-- Terminal window navigation + escape
keymap("t", "<M-l>", [[<C-\><C-n><C-w>l]], opts)
keymap("t", "<M-h>", [[<C-\><C-n><C-w>h]], opts)
keymap("t", "<M-k>", [[<C-\><C-n><C-w>k]], opts)
keymap("t", "<M-j>", [[<C-\><C-n><C-w>j]], opts)
keymap("t", "<Esc>", [[<C-\><C-n>]], opts)

-- Buffer nav
keymap("n", "bn", ":bnext<CR>", {})
keymap("n", "bp", ":bprev<CR>", {})

-- Diagnostics
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics (float)" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open location list with diagnostics" })

-- Keybinding to move inside lsp doc pop up and in general to move to next split
keymap("n", "<leader>w", "<C-w>w", {})
