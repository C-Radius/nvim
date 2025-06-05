return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 10,
            open_mapping = [[<C-\>]],
            start_in_insert = true,
            direction = "vertical",
            shell = "powershell.exe",
            float_opts = {
                border = "curved",
                width = math.ceil(vim.o.columns * 0.8),
                height = math.ceil(vim.o.lines * 0.2),
            },
        })
    end
}
