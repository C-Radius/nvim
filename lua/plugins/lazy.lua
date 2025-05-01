-- Plugin setup
require("lazy").setup({
    { "Vigemus/iron.nvim" },
    { "easymotion/vim-easymotion" },
    { "olimorris/onedarkpro.nvim" },
    { "neoclide/coc.nvim", branch = "release" },
    { "nvim-lua/plenary.nvim" },
    { "windwp/nvim-autopairs" },
    { "rcarriga/nvim-notify" },
    {'nvim-telescope/telescope.nvim',tag = "0.1.8" },
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
        "akinsho/toggleterm.nvim", version = "*",
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
            'nvim-telescope/telescope.nvim',tag = "0.1.8" 
        }
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
    },
    {"nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        --{ "3rd/image.nvim", opts = {} },
        "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
        version = "2.*",
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
},
-- Install without configuration
{ 'projekt0n/github-nvim-theme', name = 'github-theme' },

-- Or with configuration
{
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
},
{"github/copilot.vim" },
{
    'rmagatti/auto-session',
    config = function()
    end,    
}
})  

require("plugins.config_coc")
require("plugins.config_copilot")
require("plugins.config_neotree")
require("plugins.config_telescope")
require("plugins.config_treesitter")
require("plugins.config_window_picker")
require("plugins.config_github_nvim_theme")
require("plugins.config_mini_surround")
require("plugins.config_undotree")
require("plugins.config_lualine")
require("plugins.config_toggleterm")
