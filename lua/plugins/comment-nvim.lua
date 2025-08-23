-- plugins/config_comment.lua
return {
    "numToStr/Comment.nvim",
    opts = {
        -- Enable basic mappings
        mappings = true,
        -- Add padding between comment and line
        padding = true,
        -- Whether to ignore empty lines
        ignore = "^$",
    },
    config = function(_, opts)
        require("Comment").setup(opts)
    end,
}
