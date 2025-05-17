return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            version = "1.8.3",
            config = function()
                require("mason").setup({
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                })
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            version = "1.29.0",
        },
        {
            "hrsh7th/cmp-nvim-lsp",
        },
    },

    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = { callSnippet = "Replace" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            },
            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        check = { command = "clippy" },
                        cargo = { allFeatures = true },
                        inlayHints = { enable = true },
                    },
                },
            },
            pyright = {},
        }

        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = false,
            handlers = {
                function(server_name)
                    local opts = servers[server_name] or {}
                    opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
                    lspconfig[server_name].setup(opts)
                end,
            },
        })

        -- ✅ Inlay hints auto-enable on LSP attach
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local buf = args.buf
                if client and client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true)
                end
            end,
        })

        -- ✅ Toggle inlay hints keybinding: <leader>th
        vim.keymap.set("n", "<leader>th", function()
            local enabled = vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(not enabled)
        end, { desc = "Toggle Inlay Hints" })
    end,
}
