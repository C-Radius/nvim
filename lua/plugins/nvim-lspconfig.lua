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
        {
            "b0o/schemastore.nvim",
        },
    },

    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        _G.inlay_hints_enabled = true

        local server_opts = {
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
                        completion = {
                            autoimport = {
                                true
                            },
                        },
                        assist = {
                            importGranularity = "module",
                            importPrefix = "by_self",
                        },
                        cargo = { allFeatures = true },
                        check = { command = "clippy" },
                        inlayHints = {
                            enable = true,
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true,
                            },
                            typeHints = { enable = true },
                            chainingHints = { enable = true },
                            parameterHints = { enable = true },
                        },
                    },
                },
            },
            pyright = {
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic",
                        },
                    },
                },
            },
            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },
            sqlls = {},
            omnisharp = {
                cmd = { "omnisharp" },
                enable_editorconfig_support = true,
                enable_roslyn_analyzers = true,
                organize_imports_on_format = true,
            },
            ts_ls = {
                settings = {
                    completions = {
                        completeFunctionCalls = true,
                    },
                },
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            },
            gopls = {
                settings = {
                    gopls = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                    },
                },
            },
        }

        -- only include servers that are not ts_ls (manual install)
        local ensure_installed = {}
        for name, _ in pairs(server_opts) do
            if name ~= "ts_ls" then
                table.insert(ensure_installed, name)
            end
        end

        mason_lspconfig.setup({
            ensure_installed = ensure_installed,
            automatic_installation = false,
        })

        for name, opts in pairs(server_opts) do
            opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})

            -- Inject on_attach without overwriting per-server custom on_attach
            local existing_attach = opts.on_attach
            opts.on_attach = function(client, bufnr)
                if existing_attach then
                    existing_attach(client, bufnr)
                end

                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
                map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
                map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
                map("n", "gr", vim.lsp.buf.references, "Go to References")
                map("n", "K", vim.lsp.buf.hover, "Hover")
                map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
                map("n", "<C-]>", vim.lsp.buf.definition, "Jump to Definition (LSP)")
            end

            lspconfig[name].setup(opts)
        end

        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = true,
            severity_sort = true,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.server_capabilities.inlayHintProvider then
                    if _G.inlay_hints_enabled then
                        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                    end
                end
            end,
        })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
            callback = function()
                if _G.inlay_hints_enabled then
                    vim.lsp.inlay_hint.enable(true)
                end
            end,
        })

        vim.keymap.set("n", "<leader>th", function()
            _G.inlay_hints_enabled = not _G.inlay_hints_enabled
            vim.lsp.inlay_hint.enable(_G.inlay_hints_enabled)
        end, { desc = "Toggle Inlay Hints" })
    end,
}
