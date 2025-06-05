return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers", -- tabs | buffers
                numbers = "ordinal", -- or "buffer_id" or false
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                show_buffer_close_icons = true,
                show_close_icon = false,
                separator_style = "slant", -- "slant" | "thick" | "thin" | {"", ""}
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true,
                    },
                },
            },
        })

        -- Optional keymaps (put in your keymaps file if separated)
        vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
    end,
}
