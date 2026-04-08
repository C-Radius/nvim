# Neovim Configuration (C-Radius)

## Overview

This is a modular Neovim configuration targeting **Neovim 0.12.x**.

The goal of this setup is:

* Stability over time (minimal breakage on updates)
* Predictable behavior (especially clipboard and shell)
* Clean separation between core config and plugins
* Easy debugging when something breaks

---

## Directory Structure

```
.
├── init.lua
├── lua/
│   ├── core/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocmds.lua
│   │
│   └── plugins/
│       ├── lazy.lua
│       ├── telescope.lua
│       ├── ...
```

### Responsibilities

| File                | Purpose                                             |
| ------------------- | --------------------------------------------------- |
| `init.lua`          | Entry point, bootstraps lazy.nvim, loads everything |
| `core/options.lua`  | All editor behavior (clipboard, UI, etc.)           |
| `core/keymaps.lua`  | Keybindings only                                    |
| `core/autocmds.lua` | Event-driven behavior                               |
| `plugins/*.lua`     | Plugin definitions and setup                        |

---

## Core Design Decisions

### 1. Clipboard Behavior (IMPORTANT)

We use:

```lua
vim.opt.clipboard = "unnamedplus"
```

This makes:

* `yy`, `dd`, `p` use the **system clipboard**
* No need for `"+y` or `"+p`

#### Rules

* DO NOT remap `p`, `y`, `d` unless absolutely necessary
* If clipboard stops working → issue is **environment**, not config

#### Linux requirement

You MUST have one of:

* `wl-clipboard` (Wayland)
* `xclip` or `xsel` (X11)

---

### 2. Shell Configuration (CRITICAL)

We DO NOT override shell globally.

❌ BAD:

```lua
vim.opt.shell = "cmd.exe"
```

This breaks:

* plugin subprocess calls
* quoting behavior
* cross-platform compatibility

#### Rule:

If something needs a specific shell → fix it locally, NOT globally.

---

### 3. Plugin Management (lazy.nvim)

* Plugins are defined in `lua/plugins/`
* Lazy handles install/update/locking

#### Rules:

* Avoid pinning to unstable branches (`master`)
* Prefer stable or default versions
* Avoid plugin internals (e.g. `_extensions`)

---

### 4. Telescope Philosophy

Telescope is used heavily, so:

#### Constraints:

* Must not crash if extensions fail
* Must work without optional dependencies

#### Decisions:

* `fzf-native` only loads if `make` exists
* All extensions loaded with `pcall`
* Project extension guarded (no hard dependency)

---

### 5. Version Targeting

Config targets:

```
Neovim 0.12.x
```

If using a different version:

* Expect breakage
* You will get a warning on startup

---

## Known Fragile Areas

These are things that can break easily:

### 1. Telescope Extensions

* `telescope-fzf-native` → requires `make`
* `telescope-project` → uses internal APIs sometimes

### 2. Clipboard

If broken:

* Not a config issue
* Check:

  * provider availability
  * terminal support
  * OS clipboard tools

### 3. Autocommands

File:

```
core/autocmds.lua
```

This block is suspicious:

```lua
BufReadPost → edit! + redraw!
```

Potential issues:

* unexpected reloads
* buffer flickering
* weird file state

If something feels “random” → check here first.

---

## Dependency Requirements

### Required (for full functionality)

| Tool           | Purpose             |
| -------------- | ------------------- |
| `git`          | Plugin management   |
| `ripgrep (rg)` | Telescope search    |
| `fd`           | Faster file finding |

### Optional

| Tool            | Purpose                 |
| --------------- | ----------------------- |
| `make`          | Build fzf-native        |
| clipboard tools | Linux clipboard support |

---

## Debugging Strategy

When something breaks:

### Step 1 — Identify scope

* Clipboard?
* Telescope?
* Plugin?
* Keymap?

### Step 2 — Eliminate config

Run:

```bash
nvim --clean
```

If it works there → config issue

### Step 3 — Check logs

```vim
:messages
```

### Step 4 — Check plugin load

```vim
:Lazy
```

---

## Rules for Future Edits

### DO:

* Keep logic inside the correct file (options vs keymaps vs plugins)
* Use `pcall` for optional dependencies
* Prefer explicit over “magic behavior”

### DO NOT:

* Add global hacks (like forcing shell)
* Use plugin internals unless unavoidable
* Delay core options with `vim.schedule`

---

## Common Tasks

### Add a plugin

* Add file in `lua/plugins/`
* Restart → Lazy installs automatically

### Update plugins

```vim
:Lazy update
```

### Fix clipboard

* Verify `clipboard=unnamedplus`
* Verify system provider exists

---

## Philosophy Summary

This config prioritizes:

1. **Predictability**
2. **Minimal hidden behavior**
3. **Controlled plugin usage**
4. **Cross-platform compatibility**

If something feels “random”, it's a bug.

---

## Future Improvements (optional)

* Remove fragile autocmd behavior
* Add health check command
* Add plugin loading profiling
* Add fallback configs for missing dependencies

---

## Final Note

If something breaks:

* It is either:

  * environment
  * plugin update
  * bad override

It is almost never “Neovim being weird”.
