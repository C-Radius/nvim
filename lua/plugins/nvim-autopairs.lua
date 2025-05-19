return {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Load only when entering insert mode
    dependencies = {
        "hrsh7th/nvim-cmp", -- Required for completion integration
    },
    config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true, -- Enable Tree-sitter integration to skip comments/strings
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
        })

        -- Integrate with nvim-cmp
        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
