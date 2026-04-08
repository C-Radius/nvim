-- Relativenumber toggle
local group = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

local excluded_buftypes = {
    terminal = true,
    prompt = true,
    nofile = true,
    quickfix = true,
    help = true,
}

local excluded_filetypes = {
    oil = true,
    help = true,
    qf = true,
    notify = true,
    snacks_notif = true,
    dashboard = true,
    alpha = true,
}

local function should_manage_relativenumber()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    return not excluded_buftypes[buftype] and not excluded_filetypes[filetype]
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    group = group,
    pattern = "*",
    callback = function()
        if should_manage_relativenumber() then
            vim.opt_local.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    group = group,
    pattern = "*",
    callback = function()
        if should_manage_relativenumber() then
            vim.opt_local.relativenumber = false
        end
    end,
})

-- Rust helper mapping
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.keymap.set("n", "<leader>cw", function()
            vim.cmd("belowright 10split | terminal cargo watch -q --why -x clippy")
            vim.cmd("startinsert")
        end, { buffer = true, desc = "Start cargo watch in terminal" })
    end,
})

local function darken_color(hex, amount)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)

    r = math.floor(r * (1 - amount))
    g = math.floor(g * (1 - amount))
    b = math.floor(b * (1 - amount))

    return string.format("#%02x%02x%02x", r, g, b)
end

local function set_custom_ui()
    local ok, normal_hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
    if not ok or not normal_hl.bg then
        return
    end

    local bg = string.format("#%06x", normal_hl.bg)
    local darker_bg = darken_color(bg, 0.18)

    vim.cmd(string.format("hi NormalNC guibg=%s", darker_bg))
    vim.cmd("hi VertSplit guifg=#555555 guibg=NONE")
    vim.cmd("hi WinSeparator guifg=#666666 guibg=NONE")
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_custom_ui,
})

set_custom_ui()

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local font = vim.o.guifont
        if font ~= "" and not font:lower():match("nerd") then
            vim.schedule(function()
                vim.notify("⚠️ Nerd Font not detected! Icons may not display correctly.", vim.log.levels.WARN)
            end)
        end
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        vim.schedule(function()
            vim.cmd("redraw")
        end)
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
})
