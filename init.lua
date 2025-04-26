--   ____      ____           _ _
--  / ___|    |  _ \ __ _  __| (_)_   _ ___
-- | |   _____| |_) / _` |/ _` | | | | / __|
-- | |__|_____|  _ < (_| | (_| | | |_| \__ \
--  \____|    |_| \_\__,_|\__,_|_|\__,_|___/
--
-- Author: C-Radius
-- Last Mod: 30/11/2024
-- Bootstrap lazy.nvim

--Set neovide cursor trails
vim.g.neovide_cursor_vfx_mode = "pixiedust"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
    { "Vigemus/iron.nvim" },
    { "easymotion/vim-easymotion" },
    { "olimorris/onedarkpro.nvim" },
    { "neoclide/coc.nvim", branch = "release" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.8" },
    { "windwp/nvim-autopairs" },
    { "rcarriga/nvim-notify" },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "jiaoshijie/undotree",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("undotree").setup()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Automatically update parsers
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "nvim-treesitter/playground" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "dariuscorvus/tree-sitter-language-injection.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    { "jssee/vim-delight" },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 10,
                open_mapping = [[<C-\>]],
                start_in_insert = true,
                direction = "float",
                shell = "powershell.exe",
                float_opts = {
                    border = "curved",
                    width = math.ceil(vim.o.columns * 0.8),
                    height = math.ceil(vim.o.lines * 0.2),
                },
            })
        end,
    },
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup(--[[optional config]])
        end,
    },
    {
        "nvim-telescope/telescope-project.nvim",
        dependecies = {
            'nvim-telescope/telescope.nvim',
        }
    },
    {"nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
        filesystem = {
            filtered_items = {
                visible = true
            }
        }
    },
},
{
    "echasnovski/mini.surround",
    version = "*", -- or a specific version/tag if needed
    config = function()
        require("mini.surround").setup({
            -- Add custom surroundings to be used on top of builtin ones. For more
            -- information with examples, see `:h MiniSurround.config`.
            custom_surroundings = nil,

            -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
            highlight_duration = 500,

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                add = 'sa', -- Add surrounding in Normal and Visual modes
                delete = 'sd', -- Delete surrounding
                find = 'sf', -- Find surrounding (to the right)
                find_left = 'sF', -- Find surrounding (to the left)
                highlight = 'sh', -- Highlight surrounding
                replace = 'sr', -- Replace surrounding
                update_n_lines = 'sn', -- Update `n_lines`

                suffix_last = 'l', -- Suffix to search with "prev" method
                suffix_next = 'n', -- Suffix to search with "next" method
            },

            -- Number of lines within which surrounding is searched
            n_lines = 20,

            -- Whether to respect selection type:
            -- - Place surroundings on separate lines in linewise mode.
            -- - Place surroundings on each line in blockwise mode.
            respect_selection_type = false,

            -- How to search for surrounding (first inside current line, then inside
            -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
            -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
            -- see `:h MiniSurround.config`.
            search_method = 'cover',

            -- Whether to disable showing non-error feedback
            -- This also affects (purely informational) helper messages shown after
            -- idle time if user input is required.
            silent = false,
        })
    end,
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        config = function()
            require'window-picker'.setup()
        end,
    },
    -- Install without configuration
    { 'projekt0n/github-nvim-theme', name = 'github-theme' },

    -- Or with configuration
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                -- ...
            })

            vim.cmd('colorscheme github_dark')
        end,
    }
})

-- Environment variables
vim.g.polyglot_disabled = { "markdown" }
vim.env.NVIM_PYTHON_LOG_FILE = "C:\\nvim.log" -- Set location for NVIM log file.

-- Enable Python Support
if vim.fn.has("win32") == 1 then
    vim.g.python_host_prog = "C:\\Program Files\\python310\\python.exe"
    vim.g.python3_host_prog = "C:\\Program Files\\Python310\\python3.exe"
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
--vim.cmd([[colorscheme onedark_vivid]])
--vim.cmd([[colorscheme github_default]])
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
vim.opt.autochdir = true

-- Keybindings
vim.g.mapleader = ","
vim.api.nvim_set_keymap("n", "<leader>ev", ":e $MYVIMRC<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>sv", ":so $MYVIMRC<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>cd", ":cd %:h", { silent = true })
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
vim.api.nvim_set_keymap("t", "<M-l>", "[[<C-w>l]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<M-h>", "[[<C-w>h]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<M-k>", "[[<C-w>h]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<M-j>", "[[<C-w>j]]", {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "bn", ":bnext<CR>", {})
vim.api.nvim_set_keymap("n", "bp", ":bprev<CR>", {})
vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>', { noremap = true, silent = true })

--coc-actions
vim.api.nvim_set_keymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", {})
vim.api.nvim_set_keymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", {})

vim.api.nvim_set_keymap("x", "<leader>ac", "<Plug>(coc-codeaction-cursor)", {})

-- Telescope Keybindings
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true })

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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



--vim.api.nvim_set_keymap("n", "<leader>r", ":RunPython<CR>", { noremap = true, silent = true })

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

-- Autocommands to detect virtual environments
vim.api.nvim_create_autocmd({"DirChanged", "BufReadPost"}, {
    pattern = "*",
    callback = detect_project_venv,
})
-- Define a command to run Python files using the detected virtual environment
vim.api.nvim_create_user_command("RunPython", function()
    local python = vim.g.project_python
    local file = vim.fn.expand("%:p") -- Current file's full path
    vim.cmd("!" .. python .. " " .. file)
end, {})


-- Tree Sitter obviously can't work with CLANG or GCC.. 
-- so Install zig compiler with the command bellow and set it as the compiler for treesitter
-- winget install --id=zig.zig  -e
require ('nvim-treesitter.install').compilers = { 'zig'}

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
    -- Install specific language parsers or 'all' for all supported languages
    ensure_installed = {"query", "lua", "python", "javascript", "html", "css", "sql", "c"}, 

    toggle_injected_languages = 't',
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
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
    },
    move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
        },
        goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
        },
        goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
        },
        goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
        },
    },
    swap = {
        enable = true,
        swap_next = {
            ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
            ['<leader>A'] = '@parameter.inner',
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },

    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
    },
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

require('lualine').setup()

-- Optional: Map <Esc> to exit terminal mode quickly
vim.api.nvim_set_keymap('t', '<C-c>', '<Esc>', { noremap = true, silent = true })



local undotree = require('undotree')

undotree.setup({
    float_diff = true,  -- using float window previews diff, set this `true` will disable layout option
    layout = "left_bottom", -- "left_bottom", "left_left_bottom"
    position = "left", -- "right", "bottom"
    ignore_filetype = { 'undotree', 'undotreeDiff', 'qf', 'TelescopePrompt', 'spectre_panel', 'tsplayground' },
    window = {
        winblend = 30,
    },
    keymaps = {
        ['j'] = "move_next",
        ['k'] = "move_prev",
        ['gj'] = "move2parent",
        ['J'] = "move_change_next",
        ['K'] = "move_change_prev",
        ['<cr>'] = "action_enter",
        ['p'] = "enter_diffbuf",
        ['q'] = "quit",
    },
})

vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })

vim.notify= require('notify')


require 'window-picker'.setup({
    -- type of hints you want to get
    -- following types are supported
    -- 'statusline-winbar' | 'floating-big-letter' | 'floating-letter'
    -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
    -- 'floating-big-letter' draw big letter on a floating window
    -- 'floating-letter' draw letter on a floating window
    -- used
    hint = 'statusline-winbar',

    -- when you go to window selection mode, status bar will show one of
    -- following letters on them so you can use that letter to select the window
    selection_chars = 'FJDKSLA;CMRUEIWOQP',

    -- This section contains picker specific configurations
    picker_config = {
        -- whether should select window by clicking left mouse button on it
        handle_mouse_click = false,
        statusline_winbar_picker = {
            -- You can change the display string in status bar.
            -- It supports '%' printf style. Such as `return char .. ': %f'` to display
            -- buffer file path. See :h 'stl' for details.
            selection_display = function(char, windowid)
                return '%=' .. char .. '%='
            end,

            -- whether you want to use winbar instead of the statusline
            -- "always" means to always use winbar,
            -- "never" means to never use winbar
            -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
            use_winbar = 'never', -- "always" | "never" | "smart"
        },

        floating_big_letter = {
            -- window picker plugin provides bunch of big letter fonts
            -- fonts will be lazy loaded as they are being requested
            -- additionally, user can pass in a table of fonts in to font
            -- property to use instead

            font = 'ansi-shadow', -- ansi-shadow |
        },
    },

    -- whether to show 'Pick window:' prompt
    show_prompt = true,

    -- prompt message to show to get the user input
    prompt_message = 'Pick window: ',

    -- if you want to manually filter out the windows, pass in a function that
    -- takes two parameters. You should return window ids that should be
    -- included in the selection
    -- EX:-
    -- function(window_ids, filters)
        --    -- folder the window_ids
        --    -- return only the ones you want to include
        --    return {1000, 1001}
        -- end
        filter_func = nil,

        -- following filters are only applied when you are using the default filter
        -- defined by this plugin. If you pass in a function to "filter_func"
        -- property, you are on your own
        filter_rules = {
            -- when there is only one window available to pick from, use that window
            -- without prompting the user to select
            autoselect_one = true,

            -- whether you want to include the window you are currently on to window
            -- selection or not
            include_current_win = false,

            -- whether to include windows marked as unfocusable
            include_unfocusable_windows = false,

            -- filter using buffer options
            bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'NvimTree', 'neo-tree', 'notify', 'snacks_notif' },

                -- if the file type is one of following, the window will be ignored
                buftype = { 'terminal' },
            },

            -- filter using window options
            wo = {},

            -- if the file path contains one of following names, the window
            -- will be ignored
            file_path_contains = {},

            -- if the file name contains one of following names, the window will be
            -- ignored
            file_name_contains = {},
        },

        -- You can pass in the highlight name or a table of content to set as
        -- highlight
        highlights = {
            enabled = true,
            statusline = {
                focused = {
                    fg = '#ededed',
                    bg = '#e35e4f',
                    bold = true,
                },
                unfocused = {
                    fg = '#ededed',
                    bg = '#44cc41',
                    bold = true,
                },
            },
            winbar = {
                focused = {
                    fg = '#ededed',
                    bg = '#e35e4f',
                    bold = true,
                },
                unfocused = {
                    fg = '#ededed',
                    bg = '#44cc41',
                    bold = true,
                },
            },
        },
    })
    require('window-picker').pick_window({
        hint = 'floating-big-letter'
    })


    local project_actions = require("telescope._extensions.project.actions")

    require('telescope').setup {
        extensions = {
            project = {
                base_dirs = {
                    '~/dev/src',
                    {'~/dev/src2'},
                    {'~/dev/src3', max_depth = 4},
                    {path = '~/dev/src4'},
                    {path = '~/dev/src5', max_depth = 2},
                },
                ignore_missing_dirs = true,
                hidden_files = true,
                theme = "dropdown",
                order_by = "asc",
                search_by = "title",
                sync_with_nvim_tree = true,
                on_project_selected = function(prompt_bufnr)
                    project_actions.change_working_directory(prompt_bufnr, false)
                    on_project_selected = function(prompt_bufnr)
                        project_actions.change_working_directory(prompt_bufnr, false)
                    end
                end,
                mappings = {
                    n = {
                        ['d'] = project_actions.delete_project,
                        ['r'] = project_actions.rename_project,
                        ['c'] = project_actions.add_project,
                        ['C'] = project_actions.add_project_cwd,
                        ['f'] = project_actions.find_project_files,
                        ['b'] = project_actions.browse_project_files,
                        ['s'] = project_actions.search_in_project_files,
                        ['R'] = project_actions.recent_project_files,
                        ['w'] = project_actions.change_working_directory,
                        ['o'] = project_actions.next_cd_scope,
                    },
                    i = {
                        ['<c-d>'] = project_actions.delete_project,
                        ['<c-v>'] = project_actions.rename_project,
                        ['<c-a>'] = project_actions.add_project,
                        ['<c-A>'] = project_actions.add_project_cwd,
                        ['<c-f>'] = project_actions.find_project_files,
                        ['<c-b>'] = project_actions.browse_project_files,
                        ['<c-s>'] = project_actions.search_in_project_files,
                        ['<c-r>'] = project_actions.recent_project_files,
                        ['<c-l>'] = project_actions.change_working_directory,
                        ['<c-o>'] = project_actions.next_cd_scope,
                    }
                }
            }
        }
    }

    require('telescope').load_extension('project')
    vim.keymap.set('n', '<leader>p', function()
        require('telescope').extensions.project.project{}
    end, { desc = 'Telescope Project' })

------------------------------------------------------------
--  Completion + Snippet Jump Setup (Coc + coc-snippets)
------------------------------------------------------------

-- Safely remove old mappings first
pcall(vim.keymap.del, 'i', '<Tab>')
pcall(vim.keymap.del, 'i', '<S-Tab>')
pcall(vim.keymap.del, 'i', '<C-CR>')
pcall(vim.keymap.del, 'i', '<CR>')

-- Create easier alias
local map, opts = vim.keymap.set, { silent = true, expr = true }

-- Completion navigation (move inside popup menu)
map('i', '<C-n>', 'coc#pum#visible() ? coc#pum#next(1) : "\\<C-n>"', opts)
map('i', '<C-p>', 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-p>"', opts)

-- Accept completion (or normal Enter)
map('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "\\<CR>"', opts)

-- Snippet jump forward
map('i', '<Tab>',
  'coc#pum#visible() ? coc#pum#next(1) : coc#expandableOrJumpable() ? "\\<C-r>=coc#rpc#request(\'snippetNext\', [])<CR>" : "\\<Tab>"',
opts)
map('s', '<Tab>',
  'coc#expandableOrJumpable() ? "\\<C-r>=coc#rpc#request(\'snippetNext\', [])<CR>" : "\\<Tab>"',
opts)

-- Snippet jump backward
map('i', '<S-Tab>',
  'coc#pum#visible() ? coc#pum#prev(1) : coc#jumpable(-1) ? "\\<C-r>=coc#rpc#request(\'snippetPrev\', [])<CR>" : "\\<S-Tab>"',
opts)
map('s', '<S-Tab>',
  'coc#jumpable(-1) ? "\\<C-r>=coc#rpc#request(\'snippetPrev\', [])<CR>" : "\\<S-Tab>"',
opts)
-----------------------------------------------------------------
--  SNIPPET ENGINE  (one-time command, not Lua code)           --
-----------------------------------------------------------------
-- :CocInstall coc-snippets

