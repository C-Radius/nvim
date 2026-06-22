return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        indent = {
            char = "│",
            highlight = "IblChar",
        },
        scope = {
            char = "│",
            highlight = "IblScopeChar",
        },
    },
    config = function(_, opts)
        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        require("ibl").setup(opts)

        -- Disable indent guides on dashboard buffers.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dashboard", "nvdash" },
            callback = function()
                vim.b.ibl_disable = true
            end,
        })
    end,
}
