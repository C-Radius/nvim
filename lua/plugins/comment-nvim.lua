-- plugins/config_comment.lua
return {
    "numToStr/Comment.nvim",
    opts = {
        padding = true, -- space between comment and text
        sticky = true,  -- keep cursor position
        ignore = "^$",  -- ignore empty lines
        toggler = {     -- normal mode
            line = "gcc",
            block = "gbc",
        },
        opleader = { -- visual/operator-pending
            line = "gc",
            block = "gb",
        },
        extra = { -- extra mappings
            above = "gcO",
            below = "gco",
            eol   = "gcA",
        },
        mappings = { -- this must be a table, not boolean
            basic = true,
            extra = true,
        },
        pre_hook = nil,
        post_hook = nil,
    },
    config = function(_, opts)
        -- Optional: context-aware comments if you use ts-context-commentstring
        local ok, ts = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
        if ok then
            opts.pre_hook = ts.create_pre_hook()
        end
        require("Comment").setup(opts)
    end,
}
