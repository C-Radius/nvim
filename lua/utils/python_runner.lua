local M = {}

local uv = vim.uv or vim.loop

local function path_sep()
    return package.config:sub(1, 1)
end

local function normalize(path)
    return vim.fs.normalize(path)
end

local function file_exists(path)
    local stat = uv.fs_stat(path)
    return stat and stat.type == "file"
end

local function dir_exists(path)
    local stat = uv.fs_stat(path)
    return stat and stat.type == "directory"
end

local function join_paths(...)
    return table.concat({ ... }, path_sep())
end

local function is_windows()
    return path_sep() == "\\"
end

local function get_buf_path()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        return nil
    end
    return normalize(path)
end

local function find_git_root(start_path)
    local dir = vim.fs.dirname(start_path)
    local git_dir = vim.fs.find(".git", {
        path = dir,
        upward = true,
        type = "directory",
    })[1]

    if git_dir then
        return normalize(vim.fs.dirname(git_dir))
    end

    return nil
end

local function find_pyproject_root(start_path)
    local dir = vim.fs.dirname(start_path)
    local pyproject = vim.fs.find("pyproject.toml", {
        path = dir,
        upward = true,
        type = "file",
    })[1]

    if pyproject then
        return normalize(vim.fs.dirname(pyproject))
    end

    return nil
end

local function find_package_root(start_path)
    return find_pyproject_root(start_path) or find_git_root(start_path) or normalize(vim.fn.getcwd())
end

local function relative_to(root, path)
    root = normalize(root)
    path = normalize(path)

    if path:sub(1, #root) == root then
        local rel = path:sub(#root + 1)
        rel = rel:gsub("^[/\\]+", "")
        return rel
    end

    return path
end

local function strip_py_extension(path)
    return path:gsub("%.py$", "")
end

local function relpath_to_module(relpath)
    local mod = relpath:gsub("^[/\\]+", "")
    mod = strip_py_extension(mod)
    mod = mod:gsub("[/\\]+", ".")
    mod = mod:gsub("^%.+", "")
    mod = mod:gsub("%.__init__$", "")
    return mod
end

local function is_python_file(path)
    return path and path:match("%.py$") ~= nil
end

local function env_dict_to_list(env_dict)
    local env_list = {}

    for key, value in pairs(env_dict) do
        table.insert(env_list, string.format("%s=%s", key, tostring(value)))
    end

    return env_list
end

local function venv_python_path(venv_root)
    if not venv_root or venv_root == "" then
        return nil
    end

    if is_windows() then
        return join_paths(venv_root, "Scripts", "python.exe")
    end

    return join_paths(venv_root, "bin", "python")
end

local function find_local_python(root)
    local selected_venv = vim.g.python_project_active_venv
    if type(selected_venv) == "string" and selected_venv ~= "" then
        local selected_python = venv_python_path(selected_venv)
        if selected_python and file_exists(selected_python) then
            return selected_python
        end
    end

    local candidates

    if is_windows() then
        candidates = {
            join_paths(root, ".venv", "Scripts", "python.exe"),
            join_paths(root, "venv", "Scripts", "python.exe"),
        }
    else
        candidates = {
            join_paths(root, ".venv", "bin", "python"),
            join_paths(root, "venv", "bin", "python"),
        }
    end

    for _, candidate in ipairs(candidates) do
        if file_exists(candidate) then
            return candidate
        end
    end

    if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
        local activated_python = venv_python_path(vim.env.VIRTUAL_ENV)
        if activated_python and file_exists(activated_python) then
            return activated_python
        end
    end

    if vim.fn.executable("python") == 1 then
        return "python"
    end

    if is_windows() and vim.fn.executable("py") == 1 then
        return "py"
    end

    if vim.fn.executable("python3") == 1 then
        return "python3"
    end

    return nil
end

local function build_python_command(file_path)
    local root = find_package_root(file_path)
    local rel = relative_to(root, file_path)
    local module = relpath_to_module(rel)
    local python = find_local_python(root)

    if not python then
        vim.notify("No Python executable found.", vim.log.levels.ERROR)
        return nil
    end

    if not module or module == "" then
        vim.notify("Failed to resolve Python module name for current file.", vim.log.levels.ERROR)
        return nil
    end

    return {
        python = python,
        root = root,
        file_path = file_path,
        rel = rel,
        module = module,
        argv = { python, "-m", module },
    }
end

local function shell_join(argv)
    return table.concat(vim.tbl_map(vim.fn.shellescape, argv), " ")
end

local function run_in_toggleterm_float(cmd)
    local ok, terminal_mod = pcall(require, "toggleterm.terminal")
    if not ok then
        return false
    end

    local Terminal = terminal_mod.Terminal
    local term = Terminal:new({
        cmd = shell_join(cmd.argv),
        dir = cmd.root,
        direction = "float",
        hidden = true,
        close_on_exit = false,
        start_in_insert = true,
        on_open = function(t)
            vim.bo[t.bufnr].buflisted = false
            vim.cmd("startinsert")
        end,
    })

    term:toggle()
    return true
end

function M.run_in_terminal_split()
    local file_path = get_buf_path()

    if not file_path or not is_python_file(file_path) then
        vim.notify("Current buffer is not a Python file.", vim.log.levels.ERROR)
        return
    end

    vim.cmd("write")

    local cmd = build_python_command(file_path)
    if not cmd then
        return
    end

    if run_in_toggleterm_float(cmd) then
        vim.notify(
            string.format("Running in floating terminal: %s (cwd=%s)", table.concat(cmd.argv, " "), cmd.root),
            vim.log.levels.INFO
        )
        return
    end

    vim.cmd("botright 15split")
    local term_buf = vim.api.nvim_get_current_buf()

    vim.fn.termopen(cmd.argv, {
        cwd = cmd.root,
    })

    vim.bo[term_buf].buflisted = false
    vim.bo[term_buf].filetype = ""
    vim.cmd("startinsert")

    vim.notify(
        string.format("Running: %s (cwd=%s)", table.concat(cmd.argv, " "), cmd.root),
        vim.log.levels.INFO
    )
end

function M.run_detached()
    local file_path = get_buf_path()

    if not file_path or not is_python_file(file_path) then
        vim.notify("Current buffer is not a Python file.", vim.log.levels.ERROR)
        return
    end

    vim.cmd("write")

    local cmd = build_python_command(file_path)
    if not cmd then
        return
    end

    local root = cmd.root

    local log_dir = join_paths(root, ".nvim-run")
    if not dir_exists(log_dir) then
        vim.fn.mkdir(log_dir, "p")
    end

    local rel_sanitized = cmd.rel:gsub("[/\\]", "__"):gsub("%.py$", "")
    local stdout_log = join_paths(log_dir, rel_sanitized .. ".stdout.log")
    local stderr_log = join_paths(log_dir, rel_sanitized .. ".stderr.log")

    local stdout_fd = uv.fs_open(stdout_log, "w", 420)
    if not stdout_fd then
        vim.notify("Failed to open stdout log: " .. stdout_log, vim.log.levels.ERROR)
        return
    end

    local stderr_fd = uv.fs_open(stderr_log, "w", 420)
    if not stderr_fd then
        uv.fs_close(stdout_fd)
        vim.notify("Failed to open stderr log: " .. stderr_log, vim.log.levels.ERROR)
        return
    end

    local argv = vim.deepcopy(cmd.argv)
    local exe = table.remove(argv, 1)

    local handle
    local pid

    ---@type uv.spawn.options
    local spawn_opts = {
        args = argv,
        cwd = root,
        detached = true,
        stdio = { nil, stdout_fd, stderr_fd },
        env = env_dict_to_list(vim.fn.environ()),
        uid = nil,
        gid = nil,
        verbatim = false,
        hide = true,
    }

    handle, pid = uv.spawn(exe, spawn_opts, function(code, signal)
        if handle and not handle:is_closing() then
            handle:close()
        end

        vim.schedule(function()
            if code == 0 then
                vim.notify(
                    string.format("Detached run finished: %s", table.concat(cmd.argv, " ")),
                    vim.log.levels.INFO
                )
            else
                vim.notify(
                    string.format(
                        "Detached run failed (exit=%d, signal=%d)\nstdout: %s\nstderr: %s",
                        code,
                        signal or 0,
                        stdout_log,
                        stderr_log
                    ),
                    vim.log.levels.ERROR
                )
            end
        end)
    end)

    uv.fs_close(stdout_fd)
    uv.fs_close(stderr_fd)

    if not handle or not pid then
        vim.notify(
            string.format("Failed to start detached process: %s", table.concat(cmd.argv, " ")),
            vim.log.levels.ERROR
        )
        return
    end

    uv.unref(handle)

    vim.notify(
        string.format(
            "Detached run started.\ncmd: %s\ncwd: %s\npid: %s\nstdout: %s\nstderr: %s",
            table.concat(cmd.argv, " "),
            root,
            tostring(pid),
            stdout_log,
            stderr_log
        ),
        vim.log.levels.INFO
    )
end

function M.show_run_info()
    local file_path = get_buf_path()

    if not file_path or not is_python_file(file_path) then
        vim.notify("Current buffer is not a Python file.", vim.log.levels.ERROR)
        return
    end

    local cmd = build_python_command(file_path)
    if not cmd then
        return
    end

    print(vim.inspect({
        python = cmd.python,
        cwd = cmd.root,
        file = cmd.file_path,
        relative = cmd.rel,
        module = cmd.module,
        argv = cmd.argv,
    }))
end

return M
