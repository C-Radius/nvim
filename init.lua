
--   ____      ____           _ _
--  / ___|    |  _ \ __ _  __| (_)_   _ ___
-- | |   _____| |_) / _` |/ _` | | | | / __|
-- | |__|_____|  _ < (_| | (_| | | |_| \__ \
--  \____|    |_| \_\__,_|\__,_|_|\__,_|___/
--
-- Author: C-Radius
-- Last Mod: 22/05/2020

-- Check for packer.nvim and install if missing
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

    if fn.empty(fn.glob(install_path)) > 0 then
        print("Installing packer.nvim...")
        fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Automatically reload and sync packer when this file is saved
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost init.lua source <afile> | PackerSync
augroup END
]])

-- Plugin setup
require("packer").startup(function(use)
    use("wbthomason/packer.nvim") -- Packer manages itself
    use("easymotion/vim-easymotion")
    use("mbbill/undotree")
    use("olimorris/onedarkpro.nvim")
    use({ "neoclide/coc.nvim", branch = "release" })
    use("nvim-lua/plenary.nvim")
    use({ "nvim-telescope/telescope.nvim", tag = "0.1.8" })
    use("kylechui/nvim-surround")
    use({
        "coffebar/neovim-project",
        config = function()
            -- enable saving the state of plugins in the session
            vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
            -- setup neovim-project plugin
            require("neovim-project").setup {
                projects = { -- define project roots
                    "~/projects/*",
                    "~/.config/*",
                },
                picker = {
                    type = "telescope", -- or "fzf-lua"
                }
            }
        end,
        requires = {
            { "nvim-lua/plenary.nvim" },
            -- optional picker
            { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
            -- optional picker
            { "ibhagwan/fzf-lua" },
            { "Shatur/neovim-session-manager" },
        }
    })    if packer_bootstrap then
    require("packer").sync()
end
end)

-- Environment variables
vim.g.polyglot_disabled = { "markdown" }
vim.env.NVIM_PYTHON_LOG_FILE = "C:\\nvim.log" -- Set location for NVIM log file.

-- Enable Python Support
if vim.fn.has("win32") == 1 then
    vim.g.python_host_prog = ""
    vim.g.python3_host_prog = "C:\\Program Files\\Python310\\python.exe"
else
    vim.g.python_host_prog = "/usr/bin/python2"
    vim.g.python3_host_prog = "/usr/bin/python3"
end

-- Set options
vim.opt.compatible = false
vim.opt.path:append("**")
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
vim.cmd([[colorscheme onedark_vivid]])

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.linespace = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.winminheight = 0
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest", "full" }
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"

vim.opt.scrolljump = 5
vim.opt.scrolloff = 3
vim.opt.foldenable = true
vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 1
vim.opt.encoding = "utf-8"
vim.opt.ttimeoutlen = 50
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.keymap = "greek_utf-8"
vim.opt.iminsert = 0
vim.opt.imsearch = -1
vim.opt.guicursor = ""

-- Keybindings
vim.g.mapleader = ","
vim.api.nvim_set_keymap("n", "<leader>ev", ":e $MYVIMRC<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>sv", ":so $MYVIMRC<CR>", { silent = true })
vim.api.nvim_set_keymap("i", "<C-c>", "<Esc>", {})
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {})
vim.api.nvim_set_keymap("i", "<M-l>", "<C-w>l", {})
vim.api.nvim_set_keymap("i", "<M-h>", "<C-w>h", {})
vim.api.nvim_set_keymap("i", "<M-k>", "<C-w>h", {})
vim.api.nvim_set_keymap("i", "<M-j>", "<C-w>j", {})
vim.api.nvim_set_keymap("n", "<M-l>", "<C-w>l", {})
vim.api.nvim_set_keymap("n", "<M-h>", "<C-w>h", {})
vim.api.nvim_set_keymap("n", "<M-k>", "<C-w>h", {})
vim.api.nvim_set_keymap("n", "<M-j>", "<C-w>j", {})

-- Telescope Keybindings
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true })

-- Relativenumber toggle
vim.api.nvim_exec(
[[
augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
]],
false
)

-- Additional settings for Neovide
if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font:h11"
end

