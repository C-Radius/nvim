return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { "nvim-telescope/telescope-fzf-native.nvim",  build = 'make' },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-telescope/telescope-frecency.nvim" },
        { 'nvim-telescope/telescope-project.nvim' },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "nvim-telescope/telescope-github.nvim" },
        { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
        local telescope = require('telescope')
        local project_actions = require("telescope._extensions.project.actions")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local builtin = require("telescope.builtin")

        telescope.setup({
            extensions = {
                project = {
                    base_dirs = {
                        '~/dev/src',
                        { '~/dev/src2' },
                        { '~/dev/src3',        max_depth = 4 },
                        { path = '~/dev/src4' },
                        { path = '~/dev/src5', max_depth = 2 },
                    },
                    ignore_missing_dirs = true,
                    hidden_files = true,
                    theme = "dropdown",
                    order_by = "asc",
                    search_by = "title",
                    sync_with_nvim_tree = true,
                    on_project_selected = function(prompt_bufnr)
                        project_actions.change_working_directory(prompt_bufnr, false)
                        local selected_dir = vim.fn.getcwd()
                        vim.cmd("Neotree dir=" .. selected_dir)
                    end,
                    mappings = {
                        n = {
                            ['d'] = project_actions.delete_project,
                            ['r'] = project_actions.rename_project,
                            ['c'] = project_actions.add_project,
                            ['C'] = project_actions.add_project_cwd,
                            ['f'] = project_actions.find_project_files,
                            ['b'] = project_actions.browse_project_files,
                            ['s'] = project_actions.search_in_project_files,
                            ['R'] = project_actions.recent_project_files,
                            ['w'] = project_actions.change_working_directory,
                            ['o'] = project_actions.next_cd_scope,
                        },
                        i = {
                            ['<c-d>'] = project_actions.delete_project,
                            ['<c-v>'] = project_actions.rename_project,
                            ['<c-a>'] = project_actions.add_project,
                            ['<c-A>'] = project_actions.add_project_cwd,
                            ['<c-f>'] = project_actions.find_project_files,
                            ['<c-b>'] = project_actions.browse_project_files,
                            ['<c-s>'] = project_actions.search_in_project_files,
                            ['<c-r>'] = project_actions.recent_project_files,
                            ['<c-l>'] = project_actions.change_working_directory,
                            ['<c-o>'] = project_actions.next_cd_scope,
                        }
                    }
                }
            }
        })

        -- Load only valid extensions
        pcall(telescope.load_extension, 'project')
        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, 'ui-select')
        pcall(telescope.load_extension, 'file_browser')
        pcall(telescope.load_extension, 'frecency')
        pcall(telescope.load_extension, 'media_files')
        pcall(telescope.load_extension, 'github')

        -- Project-root-aware file search using Git
        vim.keymap.set("n", "<leader>ff", function()
            local file_path = vim.api.nvim_buf_get_name(0)
            local file_dir = vim.fn.fnamemodify(file_path, ":h")
            local root = vim.fn.systemlist("git -C " .. file_dir .. " rev-parse --show-toplevel")[1]
            if vim.fn.isdirectory(root) == 1 then
                builtin.find_files({ cwd = root })
            else
                builtin.find_files()
            end
        end, { desc = "Find files in git root" })

        -- Git-root-aware live grep
        vim.keymap.set("n", "<leader>fg", function()
            local file_path = vim.api.nvim_buf_get_name(0)
            local file_dir = vim.fn.fnamemodify(file_path, ":h")
            local root = vim.fn.systemlist("git -C " .. file_dir .. " rev-parse --show-toplevel")[1]
            if vim.fn.isdirectory(root) == 1 then
                builtin.live_grep({ cwd = root })
            else
                builtin.live_grep()
            end
        end, { desc = "Grep in git root" })

        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set('n', '<leader>p', function()
            telescope.extensions.project.project({})
        end, { desc = 'Telescope Project' })
    end
}
