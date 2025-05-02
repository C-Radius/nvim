
-- Keybindings
vim.g.mapleader = ","
vim.api.nvim_set_keymap("n", "<leader>ev", ":e $MYVIMRC<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>sv", ":so $MYVIMRC<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>cd", ":cd %:h", { silent = true })
vim.api.nvim_set_keymap("i", "<C-c>", "<Esc>", {})
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {})
vim.api.nvim_set_keymap("i", "<M-l>", "<C-w>l", {})
vim.api.nvim_set_keymap("i", "<M-h>", "<C-w>h", {})
vim.api.nvim_set_keymap("i", "<M-k>", "<C-w>k", {})
vim.api.nvim_set_keymap("i", "<M-j>", "<C-w>j", {})
vim.api.nvim_set_keymap("n", "<M-l>", "<C-w>l", {})
vim.api.nvim_set_keymap("n", "<M-h>", "<C-w>h", {})
vim.api.nvim_set_keymap("n", "<M-k>", "<C-w>k", {})
vim.api.nvim_set_keymap("n", "<M-j>", "<C-w>j", {})
vim.api.nvim_set_keymap("t", "<M-l>", "[[<C-w>l]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<M-h>", "[[<C-w>h]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<M-k>", "[[<C-w>k]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<M-j>", "[[<C-w>j]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "bn", ":bnext<CR>", {})
vim.api.nvim_set_keymap("n", "bp", ":bprev<CR>", {})




