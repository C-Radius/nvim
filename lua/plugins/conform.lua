return { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_format = 'fallback' }
            end,
            mode = '',
            desc = '[F]ormat buffer',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end
        end,

        formatters = {
            ruff = {
                command = function(_, ctx)
                    local sep = package.config:sub(1, 1)
                    local root_markers = {
                        'pyproject.toml',
                        'pyrightconfig.json',
                        'setup.py',
                        'setup.cfg',
                        'requirements.txt',
                        'Pipfile',
                        'tox.ini',
                        '.git',
                        '.venv',
                        'venv',
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
                        if not start_path or start_path == '' then
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
                        if not start_path or start_path == '' then
                            return nil
                        end

                        local current = start_path
                        if vim.fn.isdirectory(current) == 0 then
                            current = vim.fs.dirname(current)
                        end

                        current = normalize(current)
                        root_dir = normalize(root_dir)

                        while current do
                            for _, name in ipairs({ '.venv', 'venv' }) do
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

                    local function ruff_from_venv(venv_dir)
                        local candidates = {
                            join_path(venv_dir, 'Scripts', 'ruff.exe'),
                            join_path(venv_dir, 'bin', 'ruff'),
                        }

                        for _, candidate in ipairs(candidates) do
                            if vim.fn.executable(candidate) == 1 then
                                return candidate
                            end
                        end

                        return nil
                    end

                    local filename = (ctx and ctx.filename) or vim.api.nvim_buf_get_name(0)
                    local root_dir = find_project_root(filename)
                    local local_venv = find_local_venv(filename, root_dir)

                    if local_venv then
                        local ruff = ruff_from_venv(local_venv)
                        if ruff then
                            return ruff
                        end
                    end

                    return 'ruff'
                end,
            },
        },

        formatters_by_ft = {
            lua = { 'stylua' },
            python = { 'ruff' },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },

            -- DO NOT define cs here — fallback to OmniSharp LSP format instead.
        },
    },
}
