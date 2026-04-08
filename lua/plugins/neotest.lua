return {
    {
        "nvim-neotest/neotest",
        cmd = { "Neotest" },
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run nearest test",
            },
            {
                "<leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run file tests",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({ enter = true })
                end,
                desc = "Open test output",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle test summary",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "nvim-neotest/nvim-nio",
            "rouge8/neotest-rust",
        },
        config = function()
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

            local function find_project_root(start_path)
                if not start_path or start_path == "" then
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
                if not start_path or start_path == "" then
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

            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        python = function()
                            return resolve_python(vim.api.nvim_buf_get_name(0))
                        end,
                    }),
                    require("neotest-rust"),
                },
            })
        end,
    },
}
