return {
    "rcarriga/nvim-notify",
    config = function()
        -- Universal notify patch for 2 or 3 arguments
        vim.notify = function(msg, level, opts)
            local notify = package.loaded["notify"] or require("notify")
            if notify then
                if opts ~= nil then
                    notify(msg, level, opts)
                else
                    notify(msg, level)
                end
            else
                vim.api.nvim_echo({ { msg } }, true, {})
            end
        end

        local notify = require("notify")

        -- Now override vim.notify with nvim-notify (still safe due to patch)
        vim.notify = notify

        notify.setup({
            stages = "fade",    -- Animation style
            timeout = 3000,     -- Notification duration in ms
            render = "default", -- Display style
            top_down = true,    -- Order of notifications
        })

        vim.keymap.set("n", "<leader>fn", "<cmd>Telescope notify<cr>", { desc = "Notify History" })
    end,
}
