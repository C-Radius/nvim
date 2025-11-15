-- Neovim Options Configuration

-- UI Settings
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
vim.opt.linespace = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true
vim.opt.guicursor = ""
vim.opt.winbar = "%=%m %f"
vim.opt.laststatus = 3

-- File Handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.path:append("**")
vim.opt.mouse = "a"
vim.opt.ttimeoutlen = 50

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest", "full" }

-- Tabs & Indentation
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.joinspaces = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scrolling & Folding
vim.opt.scrolljump = 5
vim.opt.scrolloff = 3
vim.opt.foldenable = true
vim.opt.wrap = false

-- Input
vim.opt.whichwrap:append("b,s,h,l,<,>,[,]")
vim.opt.keymap = "greek_utf-8"
vim.opt.iminsert = 0
vim.opt.imsearch = -1

-- Split border characters setup for cleaner look
vim.opt.fillchars:append({
    vert = '│',
    horiz = '─',
    horizup = '┴',
    horizdown = '┬',
    vertleft = '┤',
    vertright = '├',
    verthoriz = '┼',
})

-- Clipboard (set asynchronously for better startup performance)
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Diagnostic display configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Custom diagnostic signs (Neovim 0.11+ API)
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
        },
    },
})
