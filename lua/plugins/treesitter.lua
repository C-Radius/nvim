return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
        local ts = require("nvim-treesitter")
        local install = require("nvim-treesitter.install")
        local filetypes = {
            "lua",
            "python",
            "javascript",
            "html",
            "css",
            "sql",
            "c",
            "rust",
            "markdown",
            "bash",
            "json",
            "yaml",
            "toml",
            "vim",
            "query",
        }
        local parsers = {
            "query",
            "lua",
            "python",
            "javascript",
            "html",
            "css",
            "sql",
            "c",
            "rust",
            "markdown",
            "markdown_inline",
            "bash",
            "json",
            "yaml",
            "toml",
            "vim",
            "vimdoc",
        }

        install.prefer_git = true

        ts.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        vim.schedule(function()
            pcall(function()
                ts.install(parsers)
            end)
        end)

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
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
        })

        local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = filetypes,
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)

                if vim.bo[args.buf].filetype == "python" then
                    vim.bo[args.buf].syntax = "python"
                end

                local no_indentexpr = {
                    markdown = true,
                }

                if not no_indentexpr[vim.bo[args.buf].filetype] then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
