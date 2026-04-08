return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            end

            return {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        end,
        formatters = {
            ruff = {
                command = function(_, ctx)
                    local python_env = require("utils.python_env")
                    local filename = (ctx and ctx.filename) or vim.api.nvim_buf_get_name(0)
                    return python_env.preferred_ruff(filename)
                end,
            },
        },
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff" },
        },
    },
}
