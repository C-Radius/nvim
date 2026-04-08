return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "williamboman/mason.nvim",
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
        { "williamboman/mason-lspconfig.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "b0o/schemastore.nvim" },
        { "Hoffs/omnisharp-extended-lsp.nvim" },
        {
            "ray-x/lsp_signature.nvim",
            event = "VeryLazy",
            opts = {
                bind = true,
                floating_window = true,
                floating_window_above_cur_line = false,
                hint_enable = false,
                handler_opts = {
                    border = "rounded",
                },
                max_height = 12,
                max_width = 100,
                doc_lines = 10,
                padding = " ",
                transparency = nil,
                toggle_key = "<M-x>",
            },
        },
    },

    config = function()
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local omnisharp_extended = require("omnisharp_extended")
        local python_env = require("utils.python_env")
        local lsp_signature = require("lsp_signature")

        local inlay_hints_enabled = true

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
            max_width = 100,
            max_height = 30,
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
            max_width = 100,
            max_height = 20,
        })

        local function apply_python_path(config, root_dir)
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = python_env.preferred_python(root_dir)
        end

        local python_env_notified = {}

        local function notify_python_env(bufnr)
            if python_env_notified[bufnr] then
                return
            end

            local path = python_env.resolve_path_input(bufnr)
            if not path then
                return
            end

            local _, local_venv = python_env.preferred_python(path)
            local message
            local level = vim.log.levels.INFO

            if local_venv then
                message = "Python venv selected: " .. local_venv
            else
                message = "Python venv not found"
                level = vim.log.levels.WARN
            end

            python_env_notified[bufnr] = true
            vim.schedule(function()
                vim.notify(message, level, { title = "Python Env" })
            end)
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            callback = function(args)
                notify_python_env(args.buf)
            end,
        })

        local server_opts = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        hint = {
                            enable = true,
                            arrayIndex = "Enable",
                            await = true,
                            paramName = "All",
                            paramType = true,
                            semicolon = "Disable",
                            setType = true,
                        },
                    },
                },
            },

            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        completion = {
                            autoimport = { true },
                            callable = { snippets = "none" },
                        },
                        assist = {
                            importGranularity = "module",
                            importPrefix = "by_self",
                        },
                        cargo = {
                            allFeatures = true,
                        },
                        check = {
                            command = "clippy",
                        },
                        inlayHints = {
                            enable = true,
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true,
                            },
                            typeHints = {
                                enable = true,
                            },
                            chainingHints = {
                                enable = true,
                            },
                            parameterHints = {
                                enable = true,
                            },
                        },
                    },
                },
            },

            basedpyright = {
                root_dir = function(bufnr, on_dir)
                    local path = python_env.resolve_path_input(bufnr)
                    local root = python_env.find_project_root(path)

                    if not root and path then
                        if vim.fn.isdirectory(path) == 1 then
                            root = path
                        else
                            root = vim.fs.dirname(path)
                        end
                    end

                    if on_dir then
                        on_dir(root)
                        return
                    end

                    return root
                end,

                before_init = function(_, config)
                    apply_python_path(config, config.root_dir)
                end,

                on_new_config = function(new_config, root_dir)
                    apply_python_path(new_config, root_dir)
                end,

                settings = {
                    basedpyright = {
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            inlayHints = {
                                variableTypes = true,
                                callArgumentNames = true,
                                callArgumentNamesMatching = false,
                                functionReturnTypes = true,
                                genericTypes = true,
                            },
                        },
                    },
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            },

            ruff = {},

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
                enable_editorconfig_support = true,
                enable_roslyn_analyzers = true,
                organize_imports_on_format = true,
                enable_import_completion = true,
                handlers = {
                    ["textDocument/definition"] = omnisharp_extended.handler,
                },
                on_attach = function(client, bufnr)
                    if client.server_capabilities.semanticTokensProvider
                        and client.server_capabilities.semanticTokensProvider.full
                    then
                        local augroup = vim.api.nvim_create_augroup(
                            string.format("OmniSharpSemanticTokens:%d", bufnr),
                            { clear = true }
                        )

                        vim.api.nvim_create_autocmd("TextChanged", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                client:request("textDocument/semanticTokens/full", {
                                    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
                                }, function(_, result, ctx)
                                    if result and ctx then
                                        vim.lsp.semantic_tokens.on_full(_, result, ctx)
                                    end
                                end)
                            end,
                        })
                    end
                end,
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
        }

        local function with_on_attach(name, existing_attach)
            return function(client, bufnr)
                if existing_attach then
                    existing_attach(client, bufnr)
                end

                lsp_signature.on_attach({
                    bind = true,
                    floating_window = true,
                    floating_window_above_cur_line = false,
                    hint_enable = false,
                    handler_opts = {
                        border = "rounded",
                    },
                    max_height = 12,
                    max_width = 100,
                    doc_lines = 10,
                    padding = " ",
                    transparency = nil,
                    toggle_key = "<M-x>",
                }, bufnr)

                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
                map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
                map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
                map("n", "gr", vim.lsp.buf.references, "Go to References")
                map("n", "K", vim.lsp.buf.hover, "Hover")
                map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
                map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format")
                map("n", "<C-]>", vim.lsp.buf.definition, "Jump to Definition (LSP)")

                if name == "ruff" then
                    map("n", "<leader>rf", function()
                        vim.lsp.buf.code_action({
                            apply = true,
                            context = { only = { "source.fixAll" } },
                        })
                    end, "Ruff: Fix all")
                end
            end
        end

        local ensure = {
            "lua_ls",
            "rust_analyzer",
            "basedpyright",
            "jsonls",
            "sqlls",
            "omnisharp",
            "ruff",
            "ts_ls",
        }

        mason_lspconfig.setup({
            ensure_installed = ensure,
            automatic_enable = true,
        })

        local has_handlers = type(mason_lspconfig.setup_handlers) == "function"

        if has_handlers then
            mason_lspconfig.setup_handlers({
                function(server)
                    local opts = server_opts[server] or {}
                    opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
                    opts.on_attach = with_on_attach(server, opts.on_attach)

                    vim.lsp.config(server, opts)
                    vim.lsp.enable(server)
                end,
            })
        else
            for _, server in ipairs(ensure) do
                local opts = server_opts[server] or {}
                opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
                opts.on_attach = with_on_attach(server, opts.on_attach)

                vim.lsp.config(server, opts)
                vim.lsp.enable(server)
            end
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.server_capabilities.inlayHintProvider and inlay_hints_enabled then
                    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                end
            end,
        })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
            callback = function()
                if inlay_hints_enabled then
                    vim.lsp.inlay_hint.enable(true)
                end
            end,
        })

        vim.keymap.set("n", "<leader>th", function()
            inlay_hints_enabled = not inlay_hints_enabled
            vim.lsp.inlay_hint.enable(inlay_hints_enabled)
        end, { desc = "Toggle Inlay Hints" })
    end,
}
