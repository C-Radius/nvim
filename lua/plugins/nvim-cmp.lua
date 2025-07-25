return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",                -- LSP source
        "hrsh7th/cmp-vsnip",                   -- LSP source
        "hrsh7th/nvim-cmp",                    -- LSP source
        "hrsh7th/cmp-nvim-lua",                -- LSP source
        "hrsh7th/cmp-buffer",                  -- buffer words
        "hrsh7th/cmp-nvim-lsp-signature-help", -- buffer words
        "hrsh7th/cmp-path",                    -- file paths
        "hrsh7th/cmp-cmdline",                 -- command-line completion
        "saadparwaiz1/cmp_luasnip",            -- LuaSnip source
        "L3MON4D3/LuaSnip",                    -- snippet engine
        "rafamadriz/friendly-snippets",        -- common snippets (vscode-style)
    },

    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Load vscode-style snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
                -- Confirm selection
                ["<CR>"] = cmp.mapping.confirm({ select = true }),

                -- Manual completion
                ["<C-Space>"] = cmp.mapping.complete(),

                -- Cancel completion
                ["<C-e>"] = cmp.mapping.abort(),

                -- Navigate completion items
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),

                -- Use tab ONLY to jump in snippets, not to expand
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }),

            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                    local menu_icon = {
                        nvim_lsp = "[LSP]",
                        luasnip  = "[Snip]",
                        buffer   = "[Buf]",
                        path     = "[Path]",
                    }
                    vim_item.menu = menu_icon[entry.source.name]
                    return vim_item
                end,
            },
        })
    end,
}
