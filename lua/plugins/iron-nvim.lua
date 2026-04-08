return {
    "Vigemus/iron.nvim",
    ft = { "python", "lua", "rust" },
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide", "IronWatch" },
    keys = {
        { "<space>ir", desc = "Start REPL" },
        { "<space>is", desc = "Restart REPL" },
        { "<space>iq", desc = "Close REPL" },
        { "<space>sl", desc = "Send line" },
        { "<space>sf", desc = "Send file" },
        { "<space>sc", mode = "v", desc = "Send selection" },
        { "<space>sq", desc = "Quit REPL" },
        { "<space>si", desc = "Interrupt REPL" },
    },
    config = function()
        local iron = require("iron.core")
        local view = require("iron.view")
        local python_env = require("utils.python_env")

        local function system_ok(cmd)
            local result = vim.system(cmd, { text = true }):wait()
            return result.code == 0
        end

        local function python_repl_command(meta)
            local bufname = vim.api.nvim_buf_get_name(meta.current_bufnr)
            local python = python_env.preferred_python(bufname)

            if python and system_ok({ python, "-c", "import IPython" }) then
                return { python, "-m", "IPython", "--no-autoindent" }
            end

            return { python, "-i" }
        end

        iron.setup({
            config = {
                repl_definition = {
                    python = {
                        command = python_repl_command,
                    },
                    lua = {
                        command = { "lua" },
                    },
                    rust = {
                        command = { "evcxr" },
                    },
                },
                repl_open_cmd = view.split.vertical.botright(0.4),
                close_window_on_exit = false,
            },
            highlight = {
                italic = true,
            },
            ignore_blank_lines = true,
        })

        local set = vim.keymap.set

        set("n", "<space>ir", ":IronRepl<CR>", { desc = "Start REPL" })
        set("n", "<space>is", ":IronRestart<CR>", { desc = "Restart REPL" })
        set("n", "<space>iq", function()
            require("iron.core").close_repl()
        end, { desc = "Close REPL" })

        set("n", "<space>sl", function()
            require("iron.core").send_line()
        end, { desc = "Send line" })
        set("n", "<space>sf", function()
            require("iron.core").send_file()
        end, { desc = "Send file" })
        set("v", "<space>sc", function()
            require("iron.core").visual_send()
        end, { desc = "Send selection" })
        set("n", "<space>sq", function()
            require("iron.core").close_repl()
        end, { desc = "Quit REPL" })
        set("n", "<space>si", function()
            require("iron.core").interrupt()
        end, { desc = "Interrupt REPL" })
    end,
}
