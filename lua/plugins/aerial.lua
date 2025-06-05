-- plugins/aerial.lua
return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lualine/lualine.nvim"
    },
    event = "VeryLazy",
    opts = {
        layout = {
            default_direction = "prefer_right",
        },
        filter_kind = false, -- show all symbol types
    },
    keys = {
        { "<leader>o",  "<cmd>AerialToggle<CR>",     desc = "Toggle Aerial (Symbol Outline)" },
        { "<leader>fa", "<cmd>Telescope aerial<CR>", desc = "Telescope Symbol outline (Aerial)" },
    },
    config = function(_, opts)
        require("aerial").setup(opts)
        require("telescope").load_extension("aerial") -- 👈 This loads the Telescope extension
    end,
}
