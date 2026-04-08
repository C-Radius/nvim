# Neovim Configuration

This is a modular Neovim setup built around `lazy.nvim`, native LSP, and per-plugin config files under `lua/plugins/`.

The setup is aimed at:
- native LSP instead of `coc.nvim`
- Rust, Python, Lua, JSON, SQL
- explicit configuration over hidden framework behavior
- reasonable startup time through lazy-loading
- project-root-aware workflows for Telescope, Oil, and Neogit

---

## Directory layout

- `init.lua`  
  Entry point.

- `lua/core/`  
  Core editor behavior such as options, keymaps, and autocmds.

- `lua/plugins/`  
  One plugin file per plugin or plugin group.

- `lua/utils/`  
  Helper modules used by the config.

This structure is meant to keep plugin behavior isolated and debuggable.

---

## Installation

Place the config in:

```text
C:\Users\<your-user>\AppData\Local\nvim
```

Then open Neovim and install/update plugins:

```vim
:Lazy sync
```

---

## Leader key

Leader is set to:

```text
<leader> = Space
```

So `<leader>ff` means:

```text
Space ff
```

---

## Fresh install requirements

This config expects some external tools to exist on your system. The most important ones for the current setup are:

- `git`
- `fd`
- `rg` (ripgrep)

### Why `fd` and `rg` matter

They are used by Telescope-related workflows.

- `fd` is used for fast file and directory discovery.
- `rg` is used for grep-style searching across projects.

Without them:
- Telescope directory/file workflows may be degraded or fail
- grep workflows will not work correctly

---

## Installing `fd` and `rg` on Windows with winget

Open PowerShell and run:

```powershell
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
```

These are the correct packages for:
- `fd`
- `ripgrep` (`rg`)

### Important

After installation:
1. close PowerShell
2. close Neovide / Neovim completely
3. reopen them

Winget updates `PATH`, but already-open processes do not automatically pick that up.

---

## Verifying `fd` and `rg`

In a fresh PowerShell window:

```powershell
fd --version
rg --version
where.exe fd
where.exe rg
```

Then inside Neovim:

```vim
:echo exepath('fd')
:echo exepath('rg')
```

You want both to resolve to a valid executable path.

You can also test whether Neovim can actually spawn them:

```vim
:lua print(vim.fn.jobstart({ vim.fn.exepath('fd'), "--version" }))
:lua print(vim.fn.jobstart({ vim.fn.exepath('rg'), "--version" }))
```

A positive number means Neovim successfully started the process.

### Important note about this config

This config tries to prefer Winget-installed `fd` and `rg` when configuring Telescope behavior. If Neovim still has trouble spawning one of them, Telescope-based file search and grep may be affected even if the executable exists on disk.

---

## Project root behavior

This config is set up so project-oriented actions try to operate from the actual project root instead of whatever random directory Neovide happened to start in.

That matters for:
- Telescope searches
- Oil browsing
- Neogit
- relative paths

Project root is determined using:
1. attached LSP root if available
2. root markers such as:
   - `.git`
   - `Cargo.toml`
   - `pyproject.toml`
   - `package.json`
   - `go.mod`
   - `CMakeLists.txt`
   - `.sln`
3. current working directory as fallback

---

## Telescope

Config file:
- `lua/plugins/telescope.lua`

Main bindings:

- `<leader>ff` — find files in project root
- `<leader>fg` — grep in project root
- `<leader>fb` — list open buffers
- `<leader>fh` — help tags
- `<leader>fo` — directory workflow using Telescope Oil if it works, otherwise Oil fallback
- `<leader>p` — project picker

### Notes

- `find_files` and `live_grep` are scoped to the detected project root.
- Telescope is lazy-loaded now, so it no longer slows down startup the way it did before.
- `<leader>fo` does **not** guarantee that your Neovim working directory changes. It opens a directory workflow. Changing cwd is a separate action.

---

## Oil

Config file:
- `lua/plugins/oil.lua`

Oil is a file explorer/buffer-based browser.

### Important distinction

Oil browsing is **not the same thing** as changing Neovim's working directory.

Navigating inside Oil does not automatically change `:pwd`.

That is intentional, because automatic cwd changes can break:
- LSP context
- Git context
- relative path expectations

### Practical result

- use Oil to browse
- change cwd explicitly when needed
- do not assume browsing a directory means Neovim has switched project root

---

## Neogit

Config file:
- `lua/plugins/neogit.lua`

Neogit gives you a Git UI inside Neovim.

Primary binding:

- `<leader>gg` — open Neogit status

### Basic Neogit workflow

Open status:

```text
<leader>gg
```

From the Neogit status window:

- `s` — stage file or hunk depending on cursor context
- `S` — stage all
- `u` — unstage
- `c c` — commit
- `P p` — push
- `F p` — pull
- `l l` — log
- `b b` — checkout branch
- `b c` — create branch

### Minimal commit/push sequence

1. open Neogit  
   `<leader>gg`

2. stage what you want  
   `S` for all, or `s` on a specific item

3. start commit  
   `c c`

4. write the commit message and save/quit the commit buffer  
   `:wq`

5. push  
   `P p`

### If Neogit seems to attach to the wrong repo

Check:

```vim
:pwd
```

Neogit works against the current working directory / repo context. If cwd is wrong, repo detection may also be wrong.

---

## Trouble

Config file:
- `lua/plugins/trouble.lua`

Main binding:

- `<leader>xx` — open diagnostics list

Use it to inspect:
- errors
- warnings
- LSP issues
- references, depending on mode/config

---

## Harpoon

Config file:
- `lua/plugins/harpoon.lua`

Main bindings:

- `<leader>ha` — add current file
- `<leader>hh` — open Harpoon menu
- `<leader>h1` to `<leader>h4` — jump to stored file slots

Use Harpoon for a small set of repeatedly used files in the current project.

---

## Formatting

Config file:
- `lua/plugins/conform.lua`

Formatting is handled by `conform.nvim`.

Use the configured format binding in your setup to format the current buffer. If you are unsure what that binding currently is, search the config for `conform` or your format keymap.

---

## Treesitter

Config file:
- `lua/plugins/treesitter.lua`

Treesitter provides:
- syntax highlighting
- parser-aware text objects
- parser-aware movement and selection

This setup also includes textobjects support, which allows operations such as:
- around function
- inside function
- around class

The exact usability depends on installed parsers.

---

## Completion

Config file:
- `lua/plugins/nvim-cmp.lua`

Completion is lazy-loaded now instead of dragging startup down immediately.

That means the first insert/cmdline completion use may incur a one-time load cost, but startup stays much faster.

---

## LSP

Config file:
- `lua/plugins/nvim-lspconfig.lua`

This setup uses native Neovim LSP with Mason-managed language servers.

Common actions in a normal LSP-enabled buffer usually include:
- `gd` — go to definition
- `K` — hover
- diagnostics through Trouble or virtual text/signs

Check attached servers with:

```vim
:LspInfo
```

---

## Database stack

Config file:
- `lua/plugins/vim-dadbod-ui.lua`

Installed stack:
- `vim-dadbod`
- `vim-dadbod-ui`
- `vim-dadbod-completion`

Purpose:
- connect to databases
- browse schemas/tables
- run queries from within Neovim

This is the proper stack, not one plugin by itself.

### Caveat

The UI plugin does not magically install database drivers or client support on your machine. Actual DB connectivity still depends on the database and client tooling available on the system.

---

## Startup tuning

A major issue in an earlier version of the config was startup bloat from eager-loading too many plugins at launch.

The current setup was adjusted so heavy plugins such as:
- Telescope
- cmp
- Neotest
- Iron
- parts of the LSP stack

load later instead of all at startup.

Result: startup time dropped substantially.

Use:

```vim
:Lazy profile
```

to inspect where time is going.

---

## Useful troubleshooting commands

### Lazy.nvim profile

```vim
:Lazy profile
```

Shows which plugins are consuming startup or deferred load time.

### LSP status

```vim
:LspInfo
```

### Health check

```vim
:checkhealth
```

### Treesitter parser updates

```vim
:TSUpdate
```

### Current working directory

```vim
:pwd
```

### Executable resolution

```vim
:echo exepath('fd')
:echo exepath('rg')
```

---

## Practical daily workflow

### Search files in current project

```text
<leader>ff
```

### Grep text in current project

```text
<leader>fg
```

### Browse directories / files

```text
<leader>fo
```

### Open Git UI

```text
<leader>gg
```

### See diagnostics

```text
<leader>xx
```

### Jump quickly between important project files

```text
<leader>ha
<leader>hh
<leader>h1 ... <leader>h4
```

---

## Summary

This config is designed around:
- modularity
- explicit plugin files
- project-aware navigation
- native LSP
- reasonable startup time

The main things to remember are:

1. install external tools like `fd` and `rg`
2. use `:Lazy sync` after changes
3. check `:pwd` when project behavior seems wrong
4. use Neogit explicitly for Git operations rather than guessing key sequences
