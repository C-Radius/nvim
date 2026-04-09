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

-- Buffer navigation
keymap("n", "bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })
keymap("n", "bp", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })
keymap("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })
keymap("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Diagnostics
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics (float)" })
keymap("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic" })

keymap("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open location list with diagnostics" })

-- Window cycling
keymap("n", "<leader>w", "<C-w>w", {})


--python runner
local python_runner = require("utils.python_runner")

vim.keymap.set("n", "<leader>rr", python_runner.run_in_terminal_split, {
    desc = "Run current Python module in terminal split",
})

vim.keymap.set("n", "<leader>rd", python_runner.run_detached, {
    desc = "Run current Python module detached",
})

vim.keymap.set("n", "<leader>ri", python_runner.show_run_info, {
    desc = "Show Python run info",
})
