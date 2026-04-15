return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",

    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },

    config = function()
        require("chatgpt").setup({
            openai_params = {
                model = "gpt-4o",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_completion_tokens = 1024,
                temperature = 0.2,
                top_p = 1,
                n = 1,
            },
        })

        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }

        map("n", "<leader>ac", "<cmd>ChatGPT<cr>", vim.tbl_extend("force", opts, { desc = "ChatGPT: open chat" }))
        map("v", "<leader>ae", "<cmd>ChatGPTRun edit_with_instructions<cr>",
            vim.tbl_extend("force", opts, { desc = "ChatGPT: edit selection" }))
        map("n", "<leader>as", "<cmd>ChatGPTActAs<cr>", vim.tbl_extend("force", opts, { desc = "ChatGPT: act as" }))
        map("n", "<leader>ax", "<cmd>ChatGPTRun explain_code<cr>",
            vim.tbl_extend("force", opts, { desc = "ChatGPT: explain code" }))
        map("n", "<leader>ad", "<cmd>ChatGPTRun docstring<cr>",
            vim.tbl_extend("force", opts, { desc = "ChatGPT: docstring" }))
        map("n", "<leader>at", "<cmd>ChatGPTRun tests<cr>",
            vim.tbl_extend("force", opts, { desc = "ChatGPT: generate tests" }))
    end,
}
