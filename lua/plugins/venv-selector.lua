return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
    },
    ft = { "python" },
    keys = {
        { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select venv" },
        { "<leader>vc", "<cmd>VenvSelectCache<cr>", desc = "Select cached venv" },
    },
    opts = {
        options = {
            cached_venv_automatic_activation = true,
            auto_refresh = true,
            set_environment_variables = true,
            activate_venv_in_terminal = true,
        },
        search = {
            { name = ".venv", type = "venv" },
            { name = "venv", type = "venv" },
        },
    },
    config = function(_, opts)
        local venv_selector = require("venv-selector")
        venv_selector.setup(opts)

        local sep = package.config:sub(1, 1)
        local path_sep = (sep == [[\]]) and ";" or ":"
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

        vim.g.python_project_base_path = vim.g.python_project_base_path or (vim.env.PATH or "")
        vim.g.python_project_base_virtual_env = vim.g.python_project_base_virtual_env or vim.env.VIRTUAL_ENV

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

        local function venv_bin_dir(venv_dir)
            if sep == [[\]] then
                return join_path(venv_dir, "Scripts")
            end
            return join_path(venv_dir, "bin")
        end

        local function apply_local_venv(venv_dir)
            local bin_dir = venv_bin_dir(venv_dir)
            local base_path = vim.g.python_project_base_path or ""

            vim.g.python_project_active_venv = venv_dir
            vim.env.VIRTUAL_ENV = venv_dir
            vim.env.PATH = bin_dir .. path_sep .. base_path
        end

        local function clear_local_venv()
            vim.g.python_project_active_venv = nil
            vim.env.VIRTUAL_ENV = vim.g.python_project_base_virtual_env
            vim.env.PATH = vim.g.python_project_base_path or (vim.env.PATH or "")
        end

        local group = vim.api.nvim_create_augroup("PythonProjectVenv", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "python",
            callback = function(args)
                local bufname = vim.api.nvim_buf_get_name(args.buf)
                if bufname == "" then
                    clear_local_venv()
                    return
                end

                local root_dir = find_project_root(bufname)
                local local_venv = find_local_venv(bufname, root_dir)

                if local_venv then
                    apply_local_venv(local_venv)
                else
                    clear_local_venv()
                end
            end,
        })
    end,
}
