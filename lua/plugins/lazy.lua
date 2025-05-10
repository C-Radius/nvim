-- Plugin setup
require("lazy").setup({
    -- Plain plugins
    { "Vigemus/iron.nvim" },
    { "easymotion/vim-easymotion" },
    { "olimorris/onedarkpro.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "windwp/nvim-autopairs" },
    { "rcarriga/nvim-notify" },
    { "jssee/vim-delight" },
    { "github/copilot.vim" },

    -- Configured plugins
    require("plugins.github-nvim-theme"),
    require("plugins.window-picker"),
    require("plugins.telescope"),
    require("plugins.which-key"),
    require("plugins.treesitter"),
    require("plugins.nvim-dbee"),
    require("plugins.neotree"),
    require("plugins.undotree"),
    require("plugins.coc"),
    require("plugins.toggleterm"),
    require("plugins.mini-surround"),
    require("plugins.lualine"),
    require("plugins.dashboard-nvim"),
})  

-- In the case that there's configuration between plugins 
-- meaning plugins that need to work together and share settings
-- we use a plugins bridge directory and store a file for each bridging of plugins. 
-- This statment includes all files from the plugins bridge directory.
pcall(function()
  require("utils.loader").require_all_from("plugins.plugin-bridge")
end)
