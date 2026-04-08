return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-vsnip",
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
            completion = {
                completeopt = "menu,menuone,noinsert",
            },

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            experimental = {
                ghost_text = true,
            },

            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<Down>"] = cmp.mapping.select_next_item(),
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer" },
            }),

            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                    local kind_icons = {
                        Text = " Text",
                        Method = " Method",
                        Function = "󰊕 Function",
                        Constructor = " Constructor",
                        Field = " Field",
                        Variable = " Variable",
                        Class = " Class",
                        Interface = "󰠱 Interface",
                        Module = " Module",
                        Property = " Property",
                        Unit = " Unit",
                        Value = " Value",
                        Enum = " Enum",
                        Keyword = " Keyword",
                        Snippet = " Snippet",
                        Color = " Color",
                        File = " File",
                        Reference = " Reference",
                        Folder = " Folder",
                        EnumMember = " EnumMember",
                        Constant = " Constant",
                        Struct = "󰙅 Struct",
                        Event = " Event",
                        Operator = " Operator",
                        TypeParameter = " Type",
                    }

                    if vim_item.kind == "Interface" then
                        vim_item.kind = "Trait"
                    end

                    vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind

                    local menu_icon = {
                        nvim_lsp = "[LSP]",
                        nvim_lsp_signature_help = "[Sig]",
                        luasnip = "[Snip]",
                        buffer = "[Buf]",
                        path = "[Path]",
                    }

                    vim_item.menu = menu_icon[entry.source.name] or ("[" .. entry.source.name .. "]")

                    return vim_item
                end,
            },
        })

        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
