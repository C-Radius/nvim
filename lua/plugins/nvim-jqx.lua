return {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
    cmd = { "JqxList", "JqxQuery" },
    init = function()
        if vim.fn.executable("jq") ~= 1 then
            vim.schedule(function()
                vim.notify(
                    "nvim-jqx requires jq to be installed and available in PATH",
                    vim.log.levels.WARN,
                    { title = "nvim-jqx" }
                )
            end)
        end
    end,
    keys = {
        { "<leader>jl", "<cmd>JqxList<CR>", desc = "JSON list keys" },
        { "<leader>jq", "<cmd>JqxQuery<CR>", desc = "JSON query" },
    },
}
