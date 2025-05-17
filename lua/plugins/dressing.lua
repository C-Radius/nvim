return {
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
        input = {
            enabled = true,
            default_prompt = "Input: ",
            prompt_align = "left",
            insert_only = false,
            win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            wrap = false,
            },
        },
        select = {
            enabled = true,
            backend = { "builtin", "telescope", "fzf_lua" },
            builtin = {
            trim_prompt_chars = true,
            win_options = {
                winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                wrap = false,
            },
            },
        },
        },
    },
}
