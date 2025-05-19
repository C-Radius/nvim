return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Language adapters:
            "nvim-neotest/neotest-python",
            "nvim-neotest/nvim-nio",
            "rouge8/neotest-rust",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                    require("neotest-rust"),
                }
            })
            local neotest = require("neotest")

            vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
            vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
                { desc = "Run file tests" })
            vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end,
                { desc = "Open test output" })
            vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Toggle test summary" })
        end
    }
}
