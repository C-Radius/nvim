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
    require("plugins.config_github_nvim_theme"),
    require("plugins.config_window_picker"),
    require("plugins.config_telescope"),
    require("plugins.config_which_key"),
    require("plugins.config_treesitter"),
    require("plugins.config_nvim_dbee"),
    require("plugins.config_neotree"),
    require("plugins.config_undotree"),
    require("plugins.config_coc"),
    require("plugins.config_toggleterm"),
    require("plugins.config_mini_surround"),
})  

-- In the case that there's configuration between plugins 
-- meaning plugins that need to work together and share settings
-- we use a plugins bridge directory and store a file for each bridging of plugins. 
-- This statment includes all files from the plugins bridge directory.
pcall(function()
  require("utils.loader").require_all_from("plugins.plugin_bridge")
end)
