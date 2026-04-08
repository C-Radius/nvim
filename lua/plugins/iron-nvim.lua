return {
    "Vigemus/iron.nvim",
    ft = { "python", "lua", "rust" },
    event = "VeryLazy",
    config = function()
        local iron = require("iron.core")
        local view = require("iron.view")

        local sep = package.config:sub(1, 1)
        local root_markers = {
            "pyproject.toml",
            "pyrightconfig.json",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "tox.ini",
            ".git",
            ".venv",
            "venv",
        }

        local function normalize(path)
            return path and vim.fs.normalize(path) or nil
        end

        local function is_directory(path)
            return path and vim.fn.isdirectory(path) == 1
        end

        local function join_path(...)
            return table.concat({ ... }, sep)
        end

        local function resolve_path_input(path_or_bufnr)
            if type(path_or_bufnr) == "number" then
                local ok, name = pcall(vim.api.nvim_buf_get_name, path_or_bufnr)
                if ok then
                    path_or_bufnr = name
                else
                    path_or_bufnr = nil
                end
            end

            if type(path_or_bufnr) ~= "string" then
                return nil
            end

            if path_or_bufnr == "" then
                return nil
            end

            return normalize(path_or_bufnr)
        end

        local function find_project_root(start_path)
            start_path = resolve_path_input(start_path)
            if not start_path then
                return nil
            end

            local start_dir = start_path
            if vim.fn.isdirectory(start_dir) == 0 then
                start_dir = vim.fs.dirname(start_dir)
            end

            local matches = vim.fs.find(root_markers, {
                path = start_dir,
                upward = true,
                limit = 1,
            })

            if #matches == 0 then
                return nil
            end

            return normalize(vim.fs.dirname(matches[1]))
        end

        local function find_local_venv(start_path, root_dir)
            start_path = resolve_path_input(start_path)
            if not start_path then
                return nil
            end

            local current = start_path
            if vim.fn.isdirectory(current) == 0 then
                current = vim.fs.dirname(current)
            end

            current = normalize(current)
            root_dir = normalize(root_dir)

            while current do
                for _, name in ipairs({ ".venv", "venv" }) do
                    local candidate = normalize(join_path(current, name))
                    if is_directory(candidate) then
                        return candidate
                    end
                end

                if current == root_dir then
                    break
                end

                local parent = normalize(vim.fs.dirname(current))
                if not parent or parent == current then
                    break
                end
                current = parent
            end

            return nil
        end

        local function python_from_venv(venv_dir)
            local candidates = {
                join_path(venv_dir, "Scripts", "python.exe"),
                join_path(venv_dir, "bin", "python"),
            }

            for _, candidate in ipairs(candidates) do
                if vim.fn.executable(candidate) == 1 then
                    return candidate
                end
            end

            return nil
        end

        local function resolve_python(start_path)
            local root_dir = find_project_root(start_path)
            local local_venv = find_local_venv(start_path, root_dir)

            if local_venv then
                local python = python_from_venv(local_venv)
                if python then
                    return python
                end
            end

            if vim.fn.executable("python") == 1 then
                return "python"
            end
            if vim.fn.executable("py") == 1 then
                return "py"
            end
            if vim.fn.executable("python3") == 1 then
                return "python3"
            end

            return "python"
        end

        iron.setup({
            config = {
                repl_definition = {
                    python = {
                        command = function(meta)
                            local bufname = vim.api.nvim_buf_get_name(meta.current_bufnr)
                            return { resolve_python(bufname), "-m", "IPython" }
                        end,
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
