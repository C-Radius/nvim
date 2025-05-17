return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
            enabled = true,
            default_prompt = "Input: ",
            prompt_align = "left",
            insert_only = false,
            border = "rounded",
            override = function(conf)
                conf.keymaps = {
                    ["<C-c>"] = "close",
                    ["<C-u>"] = "clear_line",
                    ["<Esc>"] = "close",
                }
                return conf
            end,
            win_options = {
                winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                wrap = false,
            },
        },
        select = {
            enabled = true,
            backend = { "telescope", "fzf_lua", "builtin" }, -- prefer telescope/fzf if available
            builtin = {
                trim_prompt_chars = true,
                border = "rounded",
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    wrap = false,
                },
            },
        },
    },
}
