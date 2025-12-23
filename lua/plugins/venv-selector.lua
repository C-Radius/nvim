return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
    },
    ft = { "python" },
    opts = {
        -- common venv folder names; plugin will search up the tree
        name = { ".venv", "venv" },

        -- keep it simple on Windows
        auto_refresh = true,
    },
    keys = {
        { "<leader>vs", "<cmd>VenvSelect<cr>",       desc = "Select venv" },
        { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select cached venv" },
    },
}
