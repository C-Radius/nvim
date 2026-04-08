local M = {}

M.root_markers = {
    "pyproject.toml",
    "pyrightconfig.json",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "tox.ini",
    ".git",
    ".venv",
    "venv",
}

local sep = package.config:sub(1, 1)
local path_sep = (sep == [[\]]) and ";" or ":"

local function normalize(path)
    return path and vim.fs.normalize(path) or nil
end

local function join_path(...)
    return table.concat({ ... }, sep)
end

local function is_directory(path)
    return path and vim.fn.isdirectory(path) == 1
end

function M.resolve_path_input(path_or_bufnr)
    if type(path_or_bufnr) == "number" then
        local ok, name = pcall(vim.api.nvim_buf_get_name, path_or_bufnr)
        if ok then
            path_or_bufnr = name
        else
            path_or_bufnr = nil
        end
    end

    if type(path_or_bufnr) ~= "string" or path_or_bufnr == "" then
        return nil
    end

    return normalize(path_or_bufnr)
end

function M.find_project_root(start_path)
    start_path = M.resolve_path_input(start_path)
    if not start_path then
        return nil
    end

    local start_dir = start_path
    if vim.fn.isdirectory(start_dir) == 0 then
        start_dir = vim.fs.dirname(start_dir)
    end

    local matches = vim.fs.find(M.root_markers, {
        path = start_dir,
        upward = true,
        limit = 1,
    })

    if #matches == 0 then
        return nil
    end

    return normalize(vim.fs.dirname(matches[1]))
end

function M.find_local_venv(start_path, root_dir)
    start_path = M.resolve_path_input(start_path)
    if not start_path then
        return nil
    end

    local current = start_path
    if vim.fn.isdirectory(current) == 0 then
        current = vim.fs.dirname(current)
    end

    current = normalize(current)
    root_dir = normalize(root_dir)

    while current do
        for _, name in ipairs({ ".venv", "venv" }) do
            local candidate = normalize(join_path(current, name))
            if is_directory(candidate) then
                return candidate
            end
        end

        if current == root_dir then
            break
        end

        local parent = normalize(vim.fs.dirname(current))
        if not parent or parent == current then
            break
        end
        current = parent
    end

    return nil
end

function M.find_root_venv(root_dir)
    if not root_dir or root_dir == "" then
        return nil
    end

    for _, name in ipairs({ ".venv", "venv" }) do
        local candidate = normalize(join_path(root_dir, name))
        if is_directory(candidate) then
            return candidate
        end
    end

    return nil
end

function M.venv_bin_dir(venv_dir)
    if sep == [[\]] then
        return join_path(venv_dir, "Scripts")
    end
    return join_path(venv_dir, "bin")
end

function M.python_from_venv(venv_dir)
    local candidates = {
        join_path(venv_dir, "Scripts", "python.exe"),
        join_path(venv_dir, "bin", "python"),
    }

    for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then
            return candidate
        end
    end

    return nil
end

function M.ruff_from_venv(venv_dir)
    local candidates = {
        join_path(venv_dir, "Scripts", "ruff.exe"),
        join_path(venv_dir, "bin", "ruff"),
    }

    for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then
            return candidate
        end
    end

    return nil
end

function M.preferred_python(path_or_bufnr)
    local path = M.resolve_path_input(path_or_bufnr)
    local root_dir = M.find_project_root(path)
    local local_venv = M.find_local_venv(path, root_dir) or M.find_root_venv(root_dir)

    if local_venv then
        local python = M.python_from_venv(local_venv)
        if python then
            return python, local_venv
        end
    end

    for _, exe in ipairs({ "python", "py", "python3" }) do
        if vim.fn.executable(exe) == 1 then
            return exe, nil
        end
    end

    return "python", nil
end

function M.preferred_ruff(path_or_bufnr)
    local path = M.resolve_path_input(path_or_bufnr)
    local root_dir = M.find_project_root(path)
    local local_venv = M.find_local_venv(path, root_dir) or M.find_root_venv(root_dir)

    if local_venv then
        local ruff = M.ruff_from_venv(local_venv)
        if ruff then
            return ruff
        end
    end

    return "ruff"
end

function M.capture_base_env()
    vim.g.python_project_base_path = vim.g.python_project_base_path or (vim.env.PATH or "")
    vim.g.python_project_base_virtual_env = vim.g.python_project_base_virtual_env or vim.env.VIRTUAL_ENV
end

function M.apply_local_venv(venv_dir)
    M.capture_base_env()
    local bin_dir = M.venv_bin_dir(venv_dir)
    local base_path = vim.g.python_project_base_path or ""

    vim.g.python_project_active_venv = venv_dir
    vim.env.VIRTUAL_ENV = venv_dir
    vim.env.PATH = bin_dir .. path_sep .. base_path
end

function M.restore_base_env()
    M.capture_base_env()
    vim.g.python_project_active_venv = nil
    vim.env.VIRTUAL_ENV = vim.g.python_project_base_virtual_env
    vim.env.PATH = vim.g.python_project_base_path or (vim.env.PATH or "")
end

function M.activate_for_path(path_or_bufnr)
    local path = M.resolve_path_input(path_or_bufnr)
    if not path then
        M.restore_base_env()
        return nil
    end

    local root_dir = M.find_project_root(path)
    local local_venv = M.find_local_venv(path, root_dir) or M.find_root_venv(root_dir)

    if local_venv then
        M.apply_local_venv(local_venv)
        return local_venv
    end

    M.restore_base_env()
    return nil
end

return M
