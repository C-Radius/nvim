return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
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
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),

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
                    local kind_icons = {
                        Text = " Text",
                        Method = " Method",
                        Function = " Function",
                        Constructor = " Ctor",
                        Field = " Field",
                        Variable = " Var",
                        Class = " Class",
                        Interface = " Trait", -- override
                        Module = " Mod",
                        Property = " Prop",
                        Unit = " Unit",
                        Value = " Val",
                        Enum = " Enum",
                        Keyword = " Kw",
                        Snippet = " Snip",
                        Color = " Color",
                        File = " File",
                        Reference = " Ref",
                        Folder = " Dir",
                        EnumMember = " Emem",
                        Constant = " Const",
                        Struct = " Struct",
                        Event = " Ev",
                        Operator = " Op",
                        TypeParameter = " Type",
                    }

                    -- Rename "Interface" to "Trait" (for rust-analyzer)
                    if vim_item.kind == "Interface" then
                        vim_item.kind = "Trait"
                    end

                    vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind

                    local menu_icon = {
                        nvim_lsp = "[LSP]",
                        luasnip  = "[Snip]",
                        buffer   = "[Buf]",
                        path     = "[Path]",
                    }
                    vim_item.menu = menu_icon[entry.source.name] or entry.source.name

                    return vim_item
                end,
            },
        })
    end,
}
