return {
    "Vigemus/iron.nvim",
    ft = { "python", "lua", "rust" },
    config = function()
        local iron = require("iron.core")
        local view = require("iron.view")

        iron.setup({
            config = {
                repl_definition = {
                    python = {
                        command = { "ipython" },
                    },
                    lua = {
                        command = { "lua" },
                    },
                    rust = {
                        command = { "evcxr" },
                    },
                },
                repl_open_cmd = view.split.vertical.botright(0.4),
                close_window_on_exit = true,
            },
            highlight = {
                italic = true,
            },
            ignore_blank_lines = true,
        })

        -- Global keymaps (manual attach only)
        local set = vim.keymap.set
        local opts = { noremap = true, silent = true, desc = "Iron REPL" }

        set("n", "<space>ir", ":IronRepl<CR>", { desc = "Start REPL" })
        set("n", "<space>is", ":IronRestart<CR>", { desc = "Restart REPL" })
        set("n", "<space>iq", function() require("iron.core").close_repl() end, { desc = "Close REPL" })

        set("n", "<space>sl", function() require("iron.core").send_line() end, { desc = "Send line" })
        set("n", "<space>sf", function() require("iron.core").send_file() end, { desc = "Send file" })
        set("v", "<space>sc", function() require("iron.core").visual_send() end, { desc = "Send selection" })
        set("n", "<space>sq", function() require("iron.core").close_repl() end, { desc = "Quit REPL" })
        set("n", "<space>si", function() require("iron.core").interrupt() end, { desc = "Interrupt REPL" })
    end,
}
