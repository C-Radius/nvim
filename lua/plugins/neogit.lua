return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
        {
            "<leader>gg",
            function()
                require("neogit").open()
            end,
            desc = "Open Neogit",
        },
    },
    opts = {
        graph_style = "unicode",
        integrations = {
            telescope = true,
            diffview = true,
        },
        kind = "tab",
        commit_editor = {
            kind = "tab",
        },
        popup = {
            kind = "split",
        },
    },
}
