return {
    "robitx/gp.nvim",
    event = "VeryLazy",

    config = function()
        require("gp").setup({
            -- Use the API key you already have in your environment.
            openai_api_key = os.getenv("OPENAI_API_KEY"),

            -- Keep the default providers; just set practical defaults for OpenAI use.
            agents = {
                {
                    provider = "openai",
                    name = "ChatGPT-4o",
                    chat = true,
                    command = false,
                    model = { model = "gpt-4o", temperature = 0.2, top_p = 1 },
                    system_prompt = require("gp.defaults").chat_system_prompt,
                },
                {
                    provider = "openai",
                    name = "CodeGPT-4o-mini",
                    chat = false,
                    command = true,
                    model = { model = "gpt-4o-mini", temperature = 0.1, top_p = 1 },
                    system_prompt = require("gp.defaults").code_system_prompt,
                },
            },

            -- Use these two as the defaults when opening chat / running code actions.
            default_chat_agent = "ChatGPT-4o",
            default_command_agent = "CodeGPT-4o-mini",
        })

        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }

        -- Chat
        map("n", "<leader>ac", "<cmd>GpChatNew<cr>", vim.tbl_extend("force", opts, { desc = "GP: new chat" }))
        map("n", "<leader>at", "<cmd>GpChatToggle<cr>", vim.tbl_extend("force", opts, { desc = "GP: toggle chat" }))
        map("n", "<leader>af", "<cmd>GpChatFinder<cr>", vim.tbl_extend("force", opts, { desc = "GP: find chats" }))

        -- Prompt on current file / selection
        map({ "n", "v" }, "<leader>ap", "<cmd>GpPopup<cr>", vim.tbl_extend("force", opts, { desc = "GP: prompt popup" }))
        map({ "n", "v" }, "<leader>ar", "<cmd>GpRewrite<cr>", vim.tbl_extend("force", opts, { desc = "GP: rewrite" }))
        map({ "n", "v" }, "<leader>ae", "<cmd>GpAppend<cr>", vim.tbl_extend("force", opts, { desc = "GP: append" }))
        map({ "n", "v" }, "<leader>ab", "<cmd>GpPrepend<cr>", vim.tbl_extend("force", opts, { desc = "GP: prepend" }))

        -- Optional useful utility
        map("n", "<leader>an", "<cmd>GpNextAgent<cr>", vim.tbl_extend("force", opts, { desc = "GP: next agent" }))
    end,
}
