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
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit for the latest features
        config = function()
            require("nvim-surround").setup({})
        end,
    },
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
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = {
                    side = "left",
                    width = 30,
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                }
            })
        end,
    },
    {
        "jiaoshijie/undotree",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("undotree").setup()
        end,
    },
    {
        "coffebar/neovim-project",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope.nvim", tag = "0.1.4", optional = true },
            { "ibhagwan/fzf-lua", optional = true },
            "Shatur/neovim-session-manager",
        },
        config = function()
            vim.opt.sessionoptions:append("globals")
            require("neovim-project").setup({
                projects = { "~/projects/*", "~/.config/*" },
                picker = { type = "telescope" },
            })
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
    vim.api.nvim_set_keymap("n", "bn", ":bnext<CR>", {})
    vim.api.nvim_set_keymap("n", "bp", ":bprev<CR>", {})

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


    -- Keybinding to toggle nvim-tree (ensures it respects the "right side" configuration)
    vim.keymap.set('n', '<Leader>n', function()
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


    local iron = require("iron.core")

    iron.setup {
        config = {
            -- Whether a repl should be discarded or not
            scratch_repl = true,
            -- Your repl definitions come here
            repl_definition = {
                sh = {
                    -- Can be a table or a function that
                    -- returns a table (see below)
                    command = {"powershell.exe"}
                },
                python = {
                    command = { "python" },  -- or { "ipython", "--no-autoindent" }
                    format = require("iron.fts.common").bracketed_paste_python,
                    block_deviders = { "# %%", "#%%" },
                }
            },
            -- How the repl window will be displayed
            -- See below for more information
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
            send_motion = "<space>sc",
            visual_send = "<space>sc",
            send_file = "<space>sf",
            send_line = "<space>sl",
            send_paragraph = "<space>sp",
            send_until_cursor = "<space>su",
            send_mark = "<space>sm",
            send_code_block = "<space>sb",
            send_code_block_and_move = "<space>sn",
            mark_motion = "<space>mc",
            mark_visual = "<space>mc",
            remove_mark = "<space>md",
            cr = "<space>s<cr>",
            interrupt = "<space>s<space>",
            exit = "<space>sq",
            clear = "<space>cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
            italic = false
         },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
    vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
    vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
    vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')


    local view = require("iron.view")

    -- iron.setup {...

    -- One can always use the default commands from vim directly
    --repl_open_cmd = "horizontal botright 80 split"


    -- But iron provides some utility functions to allow you to declare that dynamically,
    -- based on editor size or custom logic, for example.

    -- Vertical 50 columns split
    -- Split has a metatable that allows you to set up the arguments in a "fluent" API
    -- you can write as you would write a vim command.
    -- It accepts:
    --   - vertical
    --   - leftabove/aboveleft
    --   - rightbelow/belowright
    --   - topleft
    --   - botright
    -- They'll return a metatable that allows you to set up the next argument
    -- or call it with a size parameter
    repl_open_cmd = view.split.vertical.botright(50)

    -- If the supplied number is a fraction between 1 and 0,
    -- it will be used as a proportion
    --repl_open_cmd = view.split.vertical.botright(0.61903398875)

    -- The size parameter can be a number, a string or a function.
    -- When it's a *number*, it will be the size in rows/columns
    -- If it's a *string*, it requires a "%" sign at the end and is calculated
    -- as a percentage of the editor size
    -- If it's a *function*, it should return a number for the size of rows/columns

    --repl_open_cmd = view.split("40%")

    -- You can supply custom logic
    -- to determine the size of your
    -- repl's window
    --repl_open_cmd = view.split.topleft(function()
    --    if some_check then
    --        return vim.o.lines * 0.4
    --    end
    --    return 20
    --end)

    -- An optional set of options can be given to the split function if one
    -- wants to configure the window behavior.
    -- Note that, by default `winfixwidth` and `winfixheight` are set
    -- to `true`. If you want to overwrite those values,
    -- you need to specify the keys in the option map as the example below

    --repl_open_cmd = view.split("40%", {
    --    winfixwidth = false,
    --    winfixheight = false,
    --    -- any window-local configuration can be used here
    --    number = true
    --}
    --)
