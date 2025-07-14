--   ____      ____           _ _
--  / ___|    |  _ \ __ _  __| (_)_   _ ___
-- | |   _____| |_) / _` |/ _` | | | | / __|
-- | |__|_____|  _ < (_| | (_| | | |_| \__ \
--  \____|    |_| \_\__,_|\__,_|_|\__,_|___/
--
-- Author: C-Radius
-- Last Mod: 17/05/2025
-- Bootstrap lazy.nvim

-----------------------------------------------------------------------------------------------------------
-- Configuration target version
-- Check if current nvim version is compatible with the version these config files were setup for.
-----------------------------------------------------------------------------------------------------------
local required_nvim_version = "0.10.4"

-- Get current version table: { major, minor, patch }
local actual = vim.version()
local actual_version = ("%d.%d.%d"):format(actual.major, actual.minor, actual.patch)

-- Compare version strings
if actual_version ~= required_nvim_version then
    vim.schedule(function()
        vim.notify(
            string.format(
                "⚠️  Your Neovim version is %s — this config was built for %s.\nCompatibility issues may occur.",
                actual_version,
                required_nvim_version
            ),
            vim.log.levels.WARN
        )
    end)
end
----------------------------------------------------------------------------------------------------------

-- Neovim version
-- This section is for neovide settings
--Set neovide cursor trails
vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- Set neovide fonts
if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font:h10"
end

-- First of all make sure lazy is installed, if not, install it
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field --This dcorator silences a warning about fs_stat not existing. It does on runtime.
if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)


--Decide which terminal to use if we're in windows.
--Powershell by default, but you can change it to cmd or bash if you want.
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.opt.shell = "powershell"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end


-- Environment variables
vim.g.polyglot_disabled = { "markdown" }
vim.env.NVIM_PYTHON_LOG_FILE = "C:\\nvim.log" -- Set location for NVIM log file.

-- Enable Python Support by determining the Python path
if vim.fn.has("win32") == 1 then
    vim.g.python_host_prog = "C:\\Program Files\\python310\\python.exe"
    vim.g.python3_host_prog = "C:\\Program Files\\Python310\\python3.exe"
else
    vim.g.python_host_prog = "/usr/bin/python2"
    vim.g.python3_host_prog = "/usr/bin/python3"
end

-- This is the main configuration file for Neovim, which loads all the necessary modules and plugins.
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins.lazy")
