return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        { "<leader>ff", desc = "Find files in project root" },
        { "<leader>fg", desc = "Grep in project root" },
        { "<leader>fb", desc = "Telescope buffers" },
        { "<leader>fh", desc = "Telescope help tags" },
        { "<leader>fo", desc = "Project directories (Telescope Oil or Oil fallback)" },
        { "<leader>p",  desc = "Telescope Project" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            enabled = vim.fn.executable("make") == 1,
            build = "make",
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-telescope/telescope-frecency.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "nvim-telescope/telescope-github.nvim" },
        { "albenisolmos/telescope-oil.nvim" },
        { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        local function join_path(...)
            return table.concat({ ... }, "\\")
        end

        local function file_exists(path)
            return path ~= nil and path ~= "" and vim.fn.filereadable(path) == 1
        end

        local function dir_exists(path)
            return path ~= nil and path ~= "" and vim.fn.isdirectory(path) == 1
        end

        local function pick_executable(name, preferred_paths)
            for _, path in ipairs(preferred_paths or {}) do
                if file_exists(path) then
                    return path
                end
            end

            local exepath = vim.fn.exepath(name)
            if exepath ~= "" and file_exists(exepath) then
                return exepath
            end

            return nil
        end

        local home = vim.fn.expand("~")
        local winget_links = join_path(home, "AppData", "Local", "Microsoft", "WinGet", "Links")

        local fd_path = pick_executable("fd", {
            join_path(winget_links, "fd.exe"),
            join_path(
                home,
                "AppData",
                "Local",
                "Microsoft",
                "WinGet",
                "Packages",
                "sharkdp.fd_Microsoft.Winget.Source_8wekyb3d8bbwe",
                "fd-v10.4.2-x86_64-pc-windows-msvc",
                "fd.exe"
            ),
        })

        local rg_path = pick_executable("rg", {
            join_path(winget_links, "rg.exe"),
            join_path(
                home,
                "AppData",
                "Local",
                "Microsoft",
                "WinGet",
                "Packages",
                "BurntSushi.ripgrep.MSVC_Microsoft.Winget.Source_8wekyb3d8bbwe",
                "ripgrep-15.1.0-x86_64-pc-windows-msvc",
                "rg.exe"
            ),
        })

        local function can_spawn(exe)
            if not exe or not file_exists(exe) then
                return false, "executable not found"
            end

            local ok, job = pcall(vim.fn.jobstart, { exe, "--version" }, { detach = false })
            if not ok then
                return false, tostring(job)
            end

            if type(job) ~= "number" or job <= 0 then
                return false, "jobstart returned " .. tostring(job)
            end

            pcall(vim.fn.jobstop, job)
            return true, nil
        end

        local function check_dependency(path, name, url)
            if not path then
                vim.schedule(function()
                    vim.notify(
                        string.format(
                            "[Telescope] Missing dependency: %s\nDownload: %s",
                            name,
                            url
                        ),
                        vim.log.levels.WARN,
                        { title = "Telescope Dependency" }
                    )
                end)
            end
        end

        local function get_project_root()
            local current = vim.api.nvim_buf_get_name(0)

            if current == "" then
                local cwd = vim.uv.cwd()
                return (cwd and cwd ~= "") and cwd or nil
            end

            local dir = vim.fn.fnamemodify(current, ":p:h")
            local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })

            for _, client in ipairs(lsp_clients) do
                local root_dir = client.config and client.config.root_dir
                if type(root_dir) == "string" and root_dir ~= "" then
                    return root_dir
                end
            end

            local markers = {
                ".git",
                "Cargo.toml",
                "pyproject.toml",
                "pyrightconfig.json",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                ".python-version",
                "stylua.toml",
                ".stylua.toml",
                "package.json",
                "tsconfig.json",
                "go.mod",
                "Makefile",
                "CMakeLists.txt",
                ".sln",
            }

            local match = vim.fs.find(markers, {
                upward = true,
                path = dir,
                stop = vim.loop.os_homedir(),
                limit = 1,
            })[1]

            if match then
                return vim.fs.dirname(match)
            end

            local cwd = vim.uv.cwd()
            return (cwd and cwd ~= "") and cwd or dir
        end

        check_dependency(fd_path, "fd", "https://github.com/sharkdp/fd")
        check_dependency(rg_path, "ripgrep", "https://github.com/BurntSushi/ripgrep")

        local find_command = nil
        if fd_path then
            find_command = {
                fd_path,
                "--type",
                "f",
                "--strip-cwd-prefix",
                "--hidden",
                "--exclude",
                ".git",
            }
        end

        local vimgrep_arguments = nil
        if rg_path then
            vimgrep_arguments = {
                rg_path,
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            }
        end

        telescope.setup({
            defaults = {
                find_command = find_command,
                vimgrep_arguments = vimgrep_arguments,
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
            extensions = {
                ["ui-select"] = {},
                project = {
                    base_dirs = {
                        { path = vim.fn.expand("~/Documents/Projects"), max_depth = 4 },
                    },
                    ignore_missing_dirs = true,
                    hidden_files = true,
                    theme = "dropdown",
                    order_by = "asc",
                    search_by = "title",
                },
                oil = {
                    hidden = true,
                    no_ignore = false,
                    show_preview = true,
                    debug = false,
                },
            },
        })

        pcall(telescope.load_extension, "project")
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")
        pcall(telescope.load_extension, "file_browser")
        pcall(telescope.load_extension, "frecency")
        pcall(telescope.load_extension, "media_files")
        pcall(telescope.load_extension, "github")
        pcall(telescope.load_extension, "oil")

        vim.keymap.set("n", "<leader>ff", function()
            builtin.find_files({ cwd = get_project_root(), hidden = true })
        end, { desc = "Find files in project root" })

        vim.keymap.set("n", "<leader>fg", function()
            builtin.live_grep({ cwd = get_project_root() })
        end, { desc = "Grep in project root" })

        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

        vim.keymap.set("n", "<leader>fo", function()
            local cwd = get_project_root()

            if cwd and dir_exists(cwd) then
                vim.cmd.cd(vim.fn.fnameescape(cwd))
            end

            local oil_extension_available = telescope.extensions
                and telescope.extensions.oil
                and type(telescope.extensions.oil.oil) == "function"

            local fd_ok, fd_err = can_spawn(fd_path)

            if oil_extension_available and fd_ok then
                local ok, err = pcall(function()
                    telescope.extensions.oil.oil({})
                end)

                if ok then
                    return
                end

                vim.notify(
                    table.concat({
                        "telescope-oil failed; falling back to Oil",
                        "fd: " .. tostring(fd_path),
                        "cwd: " .. vim.fn.getcwd(),
                        "error: " .. tostring(err),
                    }, "\n"),
                    vim.log.levels.WARN,
                    { title = "telescope-oil" }
                )
            else
                vim.notify(
                    table.concat({
                        "telescope-oil unavailable; using Oil fallback",
                        "fd: " .. tostring(fd_path),
                        "cwd: " .. vim.fn.getcwd(),
                        "reason: " .. tostring(fd_err or "extension not loaded"),
                    }, "\n"),
                    vim.log.levels.WARN,
                    { title = "telescope-oil" }
                )
            end

            if cwd and dir_exists(cwd) then
                vim.cmd("Oil --float " .. vim.fn.fnameescape(cwd))
            else
                vim.cmd("Oil --float")
            end
        end, { desc = "Project directories (Telescope Oil or Oil fallback)" })

        vim.keymap.set("n", "<leader>p", function()
            if telescope.extensions.project then
                telescope.extensions.project.project({})
            else
                vim.notify("telescope-project extension is not available", vim.log.levels.WARN)
            end
        end, { desc = "Telescope Project" })
    end,
}
