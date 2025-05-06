return {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    commit = '2f1e6e5', -- known good as of earlier builds
    config = function()
        require("github-theme").setup({})
        vim.cmd("colorscheme github_dark")

        -- Run compile only if theme isn't found
        local theme_path = vim.fn.stdpath("data") .. "/github-theme/compiled.lua"
        if vim.fn.filereadable(theme_path) == 0 then
            vim.cmd("GithubThemeCompile")
        end
    end,
}
