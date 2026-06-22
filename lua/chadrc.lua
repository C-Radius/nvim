---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "onedark",
    theme_toggle = { "onedark", "one_light" },
    transparency = false,
    integrations = {
        "diffview",
        "flash",
        "notify",
        "rainbowdelimiters",
        "trouble",
    },
}

M.ui = {
    cmp = {
        style = "atom",
        icons_left = true,
        abbr_maxwidth = 60,
    },
    telescope = {
        style = "borderless",
    },
    statusline = {
        enabled = true,
        theme = "default",
        separator_style = "round",
    },
    tabufline = {
        enabled = true,
        lazyload = true,
        bufwidth = 21,
    },
}

M.nvdash = {
    load_on_startup = true,
    header = {
        "                                      ",
        "    ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "    ████╗  ██║██║   ██║██║████╗ ████║",
        "    ██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                      ",
        "             C-Radius × NvChad        ",
        "                                      ",
    },
    buttons = {
        { txt = "  Find File", keys = "f", cmd = "Telescope find_files" },
        { txt = "  Recent Files", keys = "r", cmd = "Telescope oldfiles" },
        { txt = "󰈭  Find Word", keys = "g", cmd = "Telescope live_grep" },
        { txt = "󱂬  Projects", keys = "p", cmd = "Telescope project" },
        { txt = "󱥚  Themes", keys = "t", cmd = "lua require('nvchad.themes').open()" },
        { txt = "  Keymaps", keys = "k", cmd = "NvCheatsheet" },
        { txt = "󰒲  Plugins", keys = "l", cmd = "Lazy" },
        { txt = "󰩈  Quit", keys = "q", cmd = "qa" },
        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
        {
            txt = function()
                local stats = require("lazy").stats()
                return ("  Loaded %d/%d plugins in %d ms"):format(
                    stats.loaded,
                    stats.count,
                    math.floor(stats.startuptime)
                )
            end,
            hl = "NvDashFooter",
            no_gap = true,
            content = "fit",
        },
        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    },
}

-- Keep the existing lsp_signature.nvim behavior and avoid duplicate popups.
M.lsp = {
    signature = false,
}

-- Color previews are useful, but enabling them globally would be a behavioral
-- change unrelated to this UI transplant.
M.colorify = {
    enabled = false,
}

return M
