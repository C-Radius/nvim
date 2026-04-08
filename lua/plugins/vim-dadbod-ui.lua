return {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
    },
    keys = {
        { "<leader>du", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI" },
        { "<leader>df", "<cmd>DBUIFindBuffer<CR>", desc = "Find DB UI buffer" },
        { "<leader>da", "<cmd>DBUIAddConnection<CR>", desc = "Add DB connection" },
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_win_position = "left"
        vim.g.db_ui_winwidth = 35
        vim.g.db_ui_execute_on_save = 1
        vim.g.db_ui_auto_execute_table_helpers = 1
    end,
}
