return {
    "nvchad/ui",
    branch = "v3.0",
    lazy = false,
    priority = 1000,
    dependencies = {
        {
            "nvchad/base46",
            branch = "v3.0",
            build = function()
                require("base46").load_all_highlights()
            end,
        },
        { "nvzone/volt", lazy = true },
        { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    config = function()
        require("nvchad")

        vim.keymap.set("n", "<leader>ut", function()
            require("nvchad.themes").open({ style = "bordered" })
        end, { desc = "UI: choose theme" })

        vim.keymap.set("n", "<leader>uc", "<cmd>NvCheatsheet<CR>", {
            desc = "UI: keymap cheatsheet",
        })

        vim.keymap.set("n", "<leader>ud", "<cmd>Nvdash<CR>", {
            desc = "UI: dashboard",
        })
    end,
}
