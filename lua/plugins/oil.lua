return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local oil = require("oil")

        oil.setup({
            default_file_explorer = true,
            columns = {
                "icon",
                "size",
                "mtime",
            },
            delete_to_trash = false,
            skip_confirm_for_simple_edits = false,
            view_options = {
                show_hidden = true,
                natural_order = true,
            },
            float = {
                padding = 2,
                max_width = 0.9,
                max_height = 0.9,
                border = "rounded",
            },
            keymaps = {
                ["<CR>"] = "actions.select",
                ["<C-s>"] = "actions.select_vsplit",
                ["<C-h>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["g."] = "actions.toggle_hidden",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["?/"] = "actions.show_help",
            },
            use_default_keymaps = true,
        })

        local function toggle_oil_float()
            if vim.bo.filetype == "oil" then
                vim.cmd("close")
                return
            end

            oil.open_float()
        end

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>n", toggle_oil_float, { desc = "Toggle Oil explorer" })
    end,
}
