-- Relativenumber toggle

local group = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd(
    { "BufEnter", "FocusGained", "InsertLeave" },
    {
        group = group,
        pattern = "*",
        command = "set relativenumber",
    }
)

vim.api.nvim_create_autocmd(
    { "BufLeave", "FocusLost", "InsertEnter" },
    {
        group = group,
        pattern = "*",
        command = "set norelativenumber",
    }
)


--This code will create a terminal split for running `cargo watch` with `clippy` in Rust files.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        -- Start cargo watch in 10-line terminal split
        vim.keymap.set("n", "<leader>cw", function()
            -- Open a 10-line terminal split and run cargo watch with clippy
            vim.cmd("belowright 10split | terminal cargo watch -q --why -x clippy")
            -- Optionally, enter insert mode automatically in the terminal
            vim.cmd("startinsert")
        end, { buffer = true, desc = "Start cargo watch in terminal" })
    end,
})
--end of terminal split
--

-- Split separation visual enchancement
-- Function to apply custom highlight settings
local function darken_color(hex, amount)
    -- Remove '#' and convert to RGB
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)

    -- Apply darkening factor
    r = math.floor(r * (1 - amount))
    g = math.floor(g * (1 - amount))
    b = math.floor(b * (1 - amount))

    -- Clamp to 00–FF and return hex string
    return string.format("#%02x%02x%02x", r, g, b)
end

local function set_custom_ui()
    -- Get Normal highlight group using the modern API
    local ok, normal_hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
    if not ok or not normal_hl.bg then return end

    -- Convert to hex
    local bg = string.format("#%06x", normal_hl.bg)
    local darker_bg = darken_color(bg, 0.18) -- ~18% darker

    -- Apply highlights
    vim.cmd(string.format("hi NormalNC guibg=%s", darker_bg))
    vim.cmd("hi VertSplit guifg=#555555 guibg=NONE")
    vim.cmd("hi WinSeparator guifg=#666666 guibg=NONE")
end

-- Reapply on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_custom_ui,
})

-- Apply immediately at startup
set_custom_ui()

-- Check if we have nerd fonts installed
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local font = vim.o.guifont
        if not font:lower():match("nerd") then
            vim.schedule(function()
                vim.notify("⚠️ Nerd Font not detected! Icons may not display correctly.", vim.log.levels.WARN)
            end)
        end
    end,
})


-- Force redraw and buffer reload after Telescope opens a file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" and vim.bo.filetype == "" then
            vim.cmd("edit!") -- Reload the file
        end
        vim.cmd("redraw!")   -- Force UI refresh
    end,
})

-- Force diagnostics while typing
vim.diagnostic.config({
    virtual_text = true,     -- show inline
    signs = true,            -- show in sign column
    underline = true,        -- underline issues
    update_in_insert = true, -- ⚠️ this is key: updates *during* insert
    severity_sort = true,    -- sort errors > warnings > hints
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
})

-- Change working directory to file's dir.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" and vim.fn.bufname() ~= "" then
            local dir = vim.fn.expand("%:p:h")
            if vim.fn.isdirectory(dir) == 1 then
                vim.cmd("tcd " .. dir)
            end
        end
    end,
})
