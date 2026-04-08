return {
    "nvim-telescope/telescope.nvim",
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
        { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        local has_project_actions, project_actions = pcall(require, "telescope._extensions.project.actions")

        local function check_dependency(cmd, name, url)
            if vim.fn.executable(cmd) ~= 1 then
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

        local function get_git_root()
            local file_path = vim.api.nvim_buf_get_name(0)
            if file_path == "" then
                return nil
            end

            local file_dir = vim.fn.fnamemodify(file_path, ":h")
            local result = vim.system(
                { "git", "-C", file_dir, "rev-parse", "--show-toplevel" },
                { text = true }
            ):wait()

            if result.code ~= 0 then
                return nil
            end

            local root = vim.trim(result.stdout or "")
            if root == "" or vim.fn.isdirectory(root) ~= 1 then
                return nil
            end

            return root
        end

        check_dependency("fd", "fd", "https://github.com/sharkdp/fd")
        check_dependency("rg", "ripgrep", "https://github.com/BurntSushi/ripgrep")

        local project_extension_config = {
            base_dirs = {
                { path = vim.fn.expand("~/Documents/Projects"), max_depth = 4 },
            },
            ignore_missing_dirs = true,
            hidden_files = true,
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = true,
        }

        if has_project_actions then
            project_extension_config.on_project_selected = function(prompt_bufnr)
                project_actions.change_working_directory(prompt_bufnr, false)

                local selected_dir = vim.fn.getcwd()
                if selected_dir and selected_dir ~= "" then
                    vim.cmd("Neotree dir=" .. vim.fn.fnameescape(selected_dir))
                end
            end

            project_extension_config.mappings = {
                n = {
                    ["d"] = project_actions.delete_project,
                    ["r"] = project_actions.rename_project,
                    ["c"] = project_actions.add_project,
                    ["C"] = project_actions.add_project_cwd,
                    ["f"] = project_actions.find_project_files,
                    ["b"] = project_actions.browse_project_files,
                    ["s"] = project_actions.search_in_project_files,
                    ["R"] = project_actions.recent_project_files,
                    ["w"] = project_actions.change_working_directory,
                    ["o"] = project_actions.next_cd_scope,
                },
                i = {
                    ["<c-d>"] = project_actions.delete_project,
                    ["<c-v>"] = project_actions.rename_project,
                    ["<c-a>"] = project_actions.add_project,
                    ["<c-A>"] = project_actions.add_project_cwd,
                    ["<c-f>"] = project_actions.find_project_files,
                    ["<c-b>"] = project_actions.browse_project_files,
                    ["<c-s>"] = project_actions.search_in_project_files,
                    ["<c-r>"] = project_actions.recent_project_files,
                    ["<c-l>"] = project_actions.change_working_directory,
                    ["<c-o>"] = project_actions.next_cd_scope,
                },
            }
        end

        telescope.setup({
            extensions = {
                ["ui-select"] = {},
                project = project_extension_config,
            },
        })

        pcall(telescope.load_extension, "project")
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")
        pcall(telescope.load_extension, "file_browser")
        pcall(telescope.load_extension, "frecency")
        pcall(telescope.load_extension, "media_files")
        pcall(telescope.load_extension, "github")

        vim.keymap.set("n", "<leader>ff", function()
            local root = get_git_root()
            if root then
                builtin.find_files({ cwd = root })
            else
                builtin.find_files()
            end
        end, { desc = "Find files in git root" })

        vim.keymap.set("n", "<leader>fg", function()
            local root = get_git_root()
            if root then
                builtin.live_grep({ cwd = root })
            else
                builtin.live_grep()
            end
        end, { desc = "Grep in git root" })

        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
        vim.keymap.set("n", "<leader>p", function()
            if telescope.extensions.project then
                telescope.extensions.project.project({})
            else
                vim.notify("telescope-project extension is not available", vim.log.levels.WARN)
            end
        end, { desc = "Telescope Project" })
    end,
}
