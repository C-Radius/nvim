return {
    "rcarriga/nvim-notify",
    config = function()
        local notify = require("notify")

        -- Override vim.notify with nvim-notify
        vim.notify = notify

        notify.setup({
            stages = "fade",        -- Animation style
            timeout = 3000,         -- Notification duration in ms
            render = "default",     -- Display style
            top_down = true,        -- Order of notifications
        })

        vim.keymap.set("n", "<leader>un", "<cmd>Telescope notify<cr>", { desc = "Notify History" })
    end,
}
