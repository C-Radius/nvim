-- Neovim Options Configuration

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

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.path:append("**")
vim.opt.mouse = "a"
vim.opt.ttimeoutlen = 50

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest", "full" }

vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.joinspaces = false

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolljump = 5
vim.opt.scrolloff = 3
vim.opt.foldenable = true
vim.opt.wrap = false

vim.opt.whichwrap:append("b,s,h,l,<,>,[,]")
vim.opt.keymap = "greek_utf-8"
vim.opt.iminsert = 0
vim.opt.imsearch = -1

vim.opt.fillchars:append({
    vert = "│",
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
})

-- Use the system clipboard as the default register when it is actually available.
if vim.fn.has("win32") == 1 then
    vim.opt.clipboard = "unnamedplus"
elseif vim.fn.executable("wl-copy") == 1 or vim.fn.executable("xclip") == 1 then
    vim.opt.clipboard = "unnamedplus"
end

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
    },
})
