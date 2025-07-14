return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
        -- Disable indent guides on dashboard buffer
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dashboard" },
            callback = function()
                vim.b.ibl_disable = true
            end,
        })
    end,
}
