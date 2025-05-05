
-- Set options
vim.opt.compatible = false
vim.opt.path:append("**")
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
--vim.cmd([[colorscheme onedark_vivid]])
--vim.cmd([[colorscheme github_default]])
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.linespace = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.winminheight = 0
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest", "full" }
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"

vim.opt.scrolljump = 5
vim.opt.scrolloff = 3
vim.opt.foldenable = true
vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 1
vim.opt.encoding = "utf-8"
vim.opt.ttimeoutlen = 50
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.keymap = "greek_utf-8"
vim.opt.iminsert = 0
vim.opt.imsearch = -1
vim.opt.guicursor = ""
vim.opt.autochdir = true


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

vim.o.winbar = "%=%m %f"
