return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
        current_line_blame = false,
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, {
                    buffer = bufnr,
                    desc = "Git: " .. desc,
                })
            end

            map("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, "next hunk")

            map("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, "previous hunk")

            map("n", "<leader>gs", gitsigns.stage_hunk, "stage hunk")
            map("n", "<leader>gr", gitsigns.reset_hunk, "reset hunk")
            map("v", "<leader>gs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "stage selected hunk")
            map("v", "<leader>gr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "reset selected hunk")
            map("n", "<leader>gS", gitsigns.stage_buffer, "stage buffer")
            map("n", "<leader>gu", gitsigns.undo_stage_hunk, "undo staged hunk")
            map("n", "<leader>gp", gitsigns.preview_hunk, "preview hunk")
            map("n", "<leader>gb", function()
                gitsigns.blame_line({ full = true })
            end, "blame line")
            map("n", "<leader>gd", gitsigns.diffthis, "diff against index")
        end,
    },
}
