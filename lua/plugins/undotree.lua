return {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        require('undotree').setup({
            float_diff = true,      -- using float window previews diff, set this `true` will disable layout option
            layout = "left_bottom", -- "left_bottom", "left_left_bottom"
            position = "right",     -- "left", "bottom"
            ignore_filetype = { 'undotree', 'undotreeDiff', 'qf', 'TelescopePrompt', 'spectre_panel', 'tsplayground' },
            window = {
                winblend = 30,
                position = "right",
                width = 30,

            },
            keymaps = {
                ['j'] = "move_next",
                ['k'] = "move_prev",
                ['gj'] = "move2parent",
                ['J'] = "move_change_next",
                ['K'] = "move_change_prev",
                ['<cr>'] = "action_enter",
                ['p'] = "enter_diffbuf",
                ['q'] = "quit",
            },
            mappings = {
                ["<C-n>"] = "<C-w>h",
                ["<C-p>"] = "<C-w>l",
            },
        })


        vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })
    end
}
