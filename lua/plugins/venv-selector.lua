return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
    },
    ft = { "python" },
    keys = {
        { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select venv" },
        { "<leader>vc", "<cmd>VenvSelectCache<cr>", desc = "Select cached venv" },
    },
    opts = {
        options = {
            cached_venv_automatic_activation = true,
            auto_refresh = true,
            set_environment_variables = true,
            activate_venv_in_terminal = true,
        },
        search = {
            { name = ".venv", type = "venv" },
            { name = "venv", type = "venv" },
        },
    },
    config = function(_, opts)
        local python_env = require("utils.python_env")
        require("venv-selector").setup(opts)

        local group = vim.api.nvim_create_augroup("PythonProjectVenv", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            group = group,
            pattern = "*.py",
            callback = function(args)
                local bufname = vim.api.nvim_buf_get_name(args.buf)
                python_env.activate_for_path(bufname)
            end,
        })
    end,
}
