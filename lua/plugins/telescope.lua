return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-project.nvim'
  },
  config = function()
    local telescope = require('telescope')
    telescope.load_extension('project')
    local project_actions = require("telescope._extensions.project.actions")

    telescope.setup({
      extensions = {
        project = {
          base_dirs = {
            '~/dev/src',
            {'~/dev/src2'},
            {'~/dev/src3', max_depth = 4},
            {path = '~/dev/src4'},
            {path = '~/dev/src5', max_depth = 2},
          },
          ignore_missing_dirs = true,
          hidden_files = true,
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true,
          on_project_selected = function(prompt_bufnr)
            project_actions.change_working_directory(prompt_bufnr, false)
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

    -- Keymaps
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>p', function()
      telescope.extensions.project.project({})
    end, { desc = 'Telescope Project' })
  end
}
