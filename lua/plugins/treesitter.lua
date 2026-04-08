return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
        -- 1. Setup Main Treesitter
        -- Note: We call require("nvim-treesitter").setup, NOT .configs
        require("nvim-treesitter").setup({
            ensure_installed = {
                "query", "lua", "python", "javascript", "html", "css", 
                "sql", "c", "rust", "markdown", "markdown_inline"
            },
            highlight = { 
                enable = true,
                -- In 0.12, native highlighting is preferred
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        })

        -- 2. Setup Textobjects
        -- This plugin now handles its own initialization
        require("nvim-treesitter-textobjects").setup({
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
                goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
            },
            swap = {
                enable = true,
                swap_next = { ["<leader>a"] = "@parameter.inner" },
                swap_previous = { ["<leader>A"] = "@parameter.inner" },
            },
        })

        -- Optional: Fix for Windows git issues if they occur
        require("nvim-treesitter.install").prefer_git = true
    end,
}

