return {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local crates = require("crates")
        crates.setup {
            -- Removed smart_append, src, and null_ls to avoid warnings
            popup = { autofocus = true, border = "rounded" },
            smart_insert = true,
            loading_indicator = true,
            -- Most features now auto-enabled; use docs for new settings if needed
        }
        vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { desc = "Show crate versions" })
        vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Show crate features" })
        vim.keymap.set("n", "<leader>cu", crates.update_crate, { desc = "Update crate" })
        vim.keymap.set("n", "<leader>cU", crates.update_all_crates, { desc = "Update all crates" })
        vim.keymap.set("n", "<leader>cr", crates.reload, { desc = "Reload crate info" })
    end,
}
