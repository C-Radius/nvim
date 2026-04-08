--   ____      ____           _ _
--  / ___|    |  _ \ __ _  __| (_)_   _ ___
-- | |   _____| |_) / _` |/ _` | | | | / __|
-- | |__|_____|  _ < (_| | (_| | | |_| \__ \
--  \____|    |_| \_\__,_|\__,_|_|\__,_|___/
--
-- Author: C-Radius
-- Last Mod: 08/04/2026
-- Bootstrap lazy.nvim

-----------------------------------------------------------------------------------------------------------
-- Configuration target version
-- Check if current nvim version is compatible with the version these config files were setup for.
-----------------------------------------------------------------------------------------------------------
local target_major = 0
local target_minor = 12

local actual = vim.version()
local actual_version = ("%d.%d.%d"):format(actual.major, actual.minor, actual.patch)

if actual.major ~= target_major or actual.minor ~= target_minor then
    vim.schedule(function()
        vim.notify(
            string.format(
                "⚠️  Your Neovim version is %s — this config targets the 0.12.x line.\nCompatibility issues may occur.",
                actual_version
            ),
            vim.log.levels.WARN
        )
    end)
end
----------------------------------------------------------------------------------------------------------

-- Neovim version
-- This section is for neovide settings
vim.g.neovide_cursor_vfx_mode = "pixiedust"

if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font:h10"
end

-- First of all make sure lazy is installed, if not, install it
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Environment variables
vim.g.polyglot_disabled = { "markdown" }

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins.lazy")
