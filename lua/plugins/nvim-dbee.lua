return {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
        if vim.fn.has("win32") == 1 then
            local install_dir = vim.fn.stdpath("data") .. "\\lazy\\nvim-dbee\\dbee"
            local binary_path = install_dir .. "\\dbee.exe"

            if vim.fn.filereadable(binary_path) == 0 then
                vim.fn.mkdir(install_dir, "p")

                local download_cmd = string.format(
                    [[powershell -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/kndndrj/nvim-dbee/releases/latest/download/dbee-x86_64-pc-windows-msvc.exe' -OutFile '%s'" ]],
                    binary_path
                )

                print("Downloading dbee binary...")
                local ok = os.execute(download_cmd)
                if ok ~= 0 then
                    vim.notify("Failed to download dbee.exe", vim.log.levels.ERROR)
                end
            end

            -- Make sure the binary is in PATH for this session
            vim.env.PATH = vim.env.PATH .. ";" .. install_dir
        end
    end,
    config = function()
        require("dbee").setup()
    end,
    cmd = { "Dbee" },
    keys = {
        { "<leader>db", "<cmd>Dbee<cr>", desc = "Open DB Explorer" }
    }
}
