-- Plugin setup
require("lazy").setup({
    -- Plain plugins
    { "easymotion/vim-easymotion" },
    { "olimorris/onedarkpro.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "jssee/vim-delight" },
    { "b0o/schemastore.nvim" },
    { "folke/neodev.nvim" },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },
    -- Configured plugins
    require("plugins.github-nvim-theme"),
    require("plugins.window-picker"),
    require("plugins.which-key"),
    require("plugins.treesitter"),
    require("plugins.neotree"),
    require("plugins.undotree"),
    --require("plugins.coc"),
    require("plugins.toggleterm"),
    require("plugins.mini-surround"),
    require("plugins.dashboard-nvim"),
    require("plugins.notify"),
    require("plugins.fidget"),
    require("plugins.flash"),
    require("plugins.dressing"),
    require("plugins.nvim-lspconfig"),
    require("plugins.conform"),
    require("plugins.nvim-cmp"),
    require("plugins.nvim-ufo"),
    require("plugins.telescope"),
    require("plugins.nvim-autopairs"),
    require("plugins.aerial"),
    require("plugins.neotest"), -- For running tests
    require("plugins.iron-nvim"),
    require("plugins.lualine"), -- Keep this last to ensure everything is loaded before trying to show info about it.
    require("plugins.bufferline")
})
