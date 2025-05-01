
-- Relativenumber toggle
vim.api.nvim_exec(
[[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
  augroup END
]],
false
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

-- Function to detect and activate a Python virtual environment for running code
local function detect_project_venv()
    local function find_venv(start_dir)
        local path_sep = package.config:sub(1, 1) -- Path separator ('/' or '\')
        local dir = start_dir

        while dir do
            local venv_dirs = {
                dir .. path_sep .. "venv",
                dir .. path_sep .. ".venv",
                dir .. path_sep .. "env"
            }

            for _, venv in ipairs(venv_dirs) do
                local python_exec = venv .. path_sep .. "Scripts" .. path_sep .. "python.exe" -- Windows
                if vim.fn.has("win32") == 0 then
                    python_exec = venv .. path_sep .. "bin" .. path_sep .. "python"
                end

                if vim.fn.executable(python_exec) == 1 then
                    return python_exec
                end
            end

            -- Move up to the parent directory
            local parent_dir = vim.fn.fnamemodify(dir, ":h")
            if parent_dir == dir then
                break
            end
            dir = parent_dir
        end
        return nil
    end

    -- Get the directory of the file opened in Neovide or fallback to cwd
    local file_dir = vim.fn.expand("%:p:h")
    if vim.fn.empty(file_dir) == 1 then
        file_dir = vim.loop.cwd()
    end

    -- Find and return the virtual environment Python path
    return find_venv(file_dir)
end

-- Set up the virtual environment for running code
local project_venv = detect_project_venv()
if project_venv then
    vim.g.project_python = project_venv
    print("Project virtual environment detected: " .. project_venv)
else
    vim.g.project_python = "python" -- Fallback to system Python
    print("No project virtual environment found. Using system Python.")
end

-- Autocommands to detect virtual environments
vim.api.nvim_create_autocmd({"DirChanged", "BufReadPost"}, {
    pattern = "*",
    callback = detect_project_venv,
})
-- Define a command to run Python files using the detected virtual environment
vim.api.nvim_create_user_command("RunPython", function()
    local python = vim.g.project_python
    local file = vim.fn.expand("%:p") -- Current file's full path
    vim.cmd("!" .. python .. " " .. file)
end, {})

