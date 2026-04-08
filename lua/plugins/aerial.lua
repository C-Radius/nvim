return {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialClose", "AerialNavToggle", "AerialInfo" },
    keys = {
        { "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle Aerial (Symbol Outline)" },
        {
            "<leader>fa",
            function()
                require("telescope").load_extension("aerial")
                require("telescope").extensions.aerial.aerial()
            end,
            desc = "Telescope Symbol outline (Aerial)",
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        layout = {
            default_direction = "prefer_right",
        },
        filter_kind = false,
    },
    config = function(_, opts)
        require("aerial").setup(opts)
    end,
}
