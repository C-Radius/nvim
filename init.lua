
--   ____      ____           _ _
--  / ___|    |  _ \ __ _  __| (_)_   _ ___
-- | |   _____| |_) / _` |/ _` | | | | / __|
-- | |__|_____|  _ < (_| | (_| | | |_| \__ \
--  \____|    |_| \_\__,_|\__,_|_|\__,_|___/
--
-- Author: C-Radius
-- Last Mod: 30/11/2024

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
    use("windwp/nvim-autopairs")
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            -- Configure nvim-tree after it's loaded
            require("nvim-tree").setup {
                view = {
                    side = "left",
                    width = 30,
                },
            }
        end
    }
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
    })
    -- Tree-sitter setup
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate' -- Update parsers automatically
    }
    -- Optional Tree-sitter plugins
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    if packer_bootstrap then
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
vim.api.nvim_set_keymap("n", "bn", "<cmd>bnext", {})
vim.api.nvim_set_keymap("n", "bp", "<cmd>bprev", {})

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

vim.api.nvim_set_keymap(
"i",
"<C-CR>",
[[coc#pum#visible() ? coc#pum#confirm() : "\<C-CR>"]],
{ noremap = true, silent = true, expr = true }
)

-- Optional: Use <Tab> and <S-Tab> for navigating suggestions
vim.api.nvim_set_keymap(
"i",
"<Tab>",
[[coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"]],
{ noremap = true, silent = true, expr = true }
)
vim.api.nvim_set_keymap(
"i",
"<S-Tab>",
[[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
{ noremap = true, silent = true, expr = true }
)



local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

npairs.setup({ map_bs = false, map_cr = false })

vim.g.coq_settings = { keymap = { recommended = false } }

-- skip it, if you use another global object
_G.MUtils= {}

MUtils.CR = function()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
            return npairs.esc('<c-y>')
        else
            return npairs.esc('<c-e>') .. npairs.autopairs_cr()
        end
    else
        return npairs.autopairs_cr()
    end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
    if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
        return npairs.esc('<c-e>') .. npairs.autopairs_bs()
    else
        return npairs.autopairs_bs()
    end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })



vim.api.nvim_set_keymap("n", "<leader>r", ":RunPython<CR>", { noremap = true, silent = true })

-- Function to detect and activate a Python virtual environment for running code
local function detect_project_venv()
    local function find_venv(start_dir)
        local path_sep = package.config:sub(1, 1) -- Path separator ('/' or '\')
        local dir = start_dir

        while dir do
            local venv_dirs = {
                dir .. path_sep .. "venv",
                dir .. path_sep .. ".venv",
                dir .. path_sep .. "env"
            }

            for _, venv in ipairs(venv_dirs) do
                local python_exec = venv .. path_sep .. "Scripts" .. path_sep .. "python.exe" -- Windows
                if vim.fn.has("win32") == 0 then
                    python_exec = venv .. path_sep .. "bin" .. path_sep .. "python"
                end

                if vim.fn.executable(python_exec) == 1 then
                    return python_exec
                end
            end

            -- Move up to the parent directory
            local parent_dir = vim.fn.fnamemodify(dir, ":h")
            if parent_dir == dir then
                break
            end
            dir = parent_dir
        end
        return nil
    end

    -- Get the directory of the file opened in Neovide or fallback to cwd
    local file_dir = vim.fn.expand("%:p:h")
    if vim.fn.empty(file_dir) == 1 then
        file_dir = vim.loop.cwd()
    end

    -- Find and return the virtual environment Python path
    return find_venv(file_dir)
end

-- Set up the virtual environment for running code
local project_venv = detect_project_venv()
if project_venv then
    vim.g.project_python = project_venv
    print("Project virtual environment detected: " .. project_venv)
else
    vim.g.project_python = "python" -- Fallback to system Python
    print("No project virtual environment found. Using system Python.")
end

-- Define a command to run Python files using the detected virtual environment
vim.api.nvim_create_user_command("RunPython", function()
    local python = vim.g.project_python
    local file = vim.fn.expand("%:p") -- Current file's full path
    vim.cmd("!" .. python .. " " .. file)
end, {})


-- Keybinding to toggle nvim-tree (ensures it respects the "right side" configuration)
vim.keymap.set('n', '<C-n>', function()
    local api = require("nvim-tree.api")
    if api.tree.is_visible() then
        api.tree.close()
    else
        api.tree.open()
    end
end, { noremap = true, silent = true })

-- Tree Sitter obviously can't work with CLANG or GCC.. 
-- so Install zig compiler with the command bellow and set it as the compiler for treesitter
-- winget install --id=zig.zig  -e
require ('nvim-treesitter.install').compilers = { 'zig'}

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
    -- Install specific language parsers or 'all' for all supported languages
    ensure_installed = { "lua", "python", "javascript", "html", "css", "sql", "rust", "c"}, 

    -- Enable highlighting
    highlight = {
        enable = true,              -- Enable Tree-sitter-based syntax highlighting
        additional_vim_regex_highlighting = false,
    },

    -- Optional: Enable incremental selection and text objects
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },

    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },
}


