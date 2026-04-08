# Neovim Configuration

A fast, minimal, and structured Neovim setup focused on **navigation**, **filesystem editing**, and **native LSP**.

This README is meant to be sufficient for anyone (including future you) to understand and use the setup without guessing.

---

# Core Philosophy

This config is intentionally split into clear responsibilities:

* **Telescope** → *find things* (files, text, projects)
* **Oil** → *change things* (rename, move, delete files)
* **LSP (native Neovim)** → *understand things* (code intelligence)

There is **no sidebar-based workflow**. Everything is buffer-driven.

---

# Installation

## 1. Install Neovim

Required version:

```
Neovim 0.12.x
```

---

## 2. Install dependencies

### Windows (using winget)

Install everything with:

```
winget install Neovim.Neovim
winget install Git.Git
winget install BurntSushi.ripgrep.MSVC
winget install sharkdp.fd
winget install OpenJS.NodeJS
winget install Python.Python.3
```

---

### Linux (APT – Debian/Ubuntu)

```
sudo apt update
sudo apt install neovim git ripgrep fd-find nodejs npm python3 python3-pip
```

👉 Note: On Ubuntu/Debian, `fd` is installed as `fdfind`

Fix:

```
sudo ln -s $(which fdfind) ~/.local/bin/fd
```

---

### Linux (Pacman – Arch)

```
sudo pacman -S neovim git ripgrep fd nodejs npm python python-pip
```

---

## 3. Install config

### Windows

```
C:\Users\<your-user>\AppData\Local\nvim
```

### Linux/macOS

```
~/.config/nvim
```

Place the config files there.

---

## 4. Install plugins

Open Neovim and run:

```
:Lazy sync
```

---

# Keybindings

## Telescope (Navigation)

| Key          | Action                |
| ------------ | --------------------- |
| `<leader>ff` | Find files            |
| `<leader>fg` | Live grep             |
| `<leader>fo` | Open directory in Oil |

---

## Oil (Filesystem)

| Key         | Action                        |
| ----------- | ----------------------------- |
| `-`         | Open current file's directory |
| `<leader>n` | Open Oil (floating explorer)  |

---

## Buffers

| Key          | Action          |
| ------------ | --------------- |
| `<leader>bn` | Next buffer     |
| `<leader>bp` | Previous buffer |

---

# Oil (Filesystem Editing)

## Mental Model

Oil = **filesystem as a text buffer**

You are not clicking files.
You are editing a list of files.

---

## Navigation inside Oil

| Key     | Action                      |
| ------- | --------------------------- |
| `j / k` | Move                        |
| `<CR>`  | Open file / enter directory |
| `-`     | Go to parent directory      |
| `g.`    | Toggle hidden files         |

---

## File Operations

### Rename

Edit the filename:

```
old.txt → new.txt
```

Then:

```
:w
```

---

### Move file

```
file.txt → folder/file.txt
```

Then:

```
:w
```

---

### Delete file

```
dd
:w
```

---

### Create file

```
newfile.txt
:w
```

---

### Create folder

```
folder_name/
:w
```

---

## Undo

```
u
```

---

## Important Rule

Nothing happens until:

```
:w
```

---

# Workflow

### 1. Find file

```
<leader>ff
```

### 2. Open file

```
<CR>
```

### 3. Open its folder

```
-
```

### 4. Modify with Oil

---

# LSP (Language Server)

Uses **native Neovim LSP (modern style)**.

---

## DO NOT use:

```
:LspInfo
```

---

## Use instead:

### Check status

```
:checkhealth vim.lsp
```

### Check active clients

```
:lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
```

---

## LSP servers

Managed via Mason.

Examples:

* Python → pyright, ruff
* JSON → jsonls

---

# Telescope Details

* `ripgrep` → required for searching
* `fd` → used for fast file finding

If `fd` is missing:

* file search still works
* but slower

---

# Clipboard

```
vim.opt.clipboard = "unnamedplus"
```

### Linux requirement:

```
sudo apt install xclip
```

or

```
sudo pacman -S wl-clipboard
```

---

# Notes

* Neo-tree removed → replaced by Oil
* No sidebar file explorer
* Fully cross-platform
* Minimal and predictable

---

# Summary

* Telescope → find
* Oil → modify
* LSP → understand

---

# Final Advice

If something feels wrong, you're probably using it like a traditional file explorer.

Don't.

Think:

* navigation → Telescope
* editing → Oil

