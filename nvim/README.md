# Neovim Config Cheatsheet

## Leader Key
`<Space>` - Your leader key

---

## File Navigation (fzf-lua)
| Key | Action |
|-----|--------|
| `<leader>p` | Find files |
| `<leader>t` | Browse treesitter symbols |
| `<leader>gf` | Find git files |
| `<leader>gc` | Browse git commits |
| `<leader>f` | Search in current buffer |
| `<leader>fa` | Live grep in all files |
| `<leader>c` | Browse colorschemes |

---

## LSP (Language Server)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |

---

## Diagnostics (Errors/Warnings)
| Key | Action |
|-----|--------|
| `<leader>nr` | Go to next diagnostic |
| `<leader>or` | Open diagnostic float |
| `<leader>rr` | List all workspace diagnostics |

---

## Buffer Management
| Key | Action |
|-----|--------|
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Delete buffer |

---

## File Operations
| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>s` | Reload config (source init.lua) |

---

## Build System
| Key | Action |
|-----|--------|
| `<leader>t` | Run build.sh (finds it in parent dirs) |

**How it works:**
- Searches upward from current file for `build.sh`
- Runs build and captures output in quickfix
- Opens quickfix window vertically if there's output
- Shows errors/warnings from build

---

## Clipboard Operations
| Key | Action |
|-----|--------|
| `<leader>yb` | Copy entire buffer to clipboard |
| `<leader>yq` | Copy quickfix list to clipboard |

---

## Diffview (Git Diffs)
| Key | Action |
|-----|--------|
| `<leader>do` | Open diffview |
| `<leader>dc` | Close diffview |
| `<leader>dh` | Show file history |

---

## Mini.nvim Features
| Key | Action |
|-----|--------|
| `<leader>j` | Jump to visible location (mini.jump) |
| `ga` | Align text (mini.align) |

---

## Completion (Insert Mode)
| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm completion |
| `<C-e>` | Abort completion |

---

## Auto-Format on Save
**Go files (*.go):**
- Formats with LSP on save

**C/C++ files (*.c, *.h, *.cpp, *.hpp):**
- Uses LSP formatting if available
- Falls back to `clang-format` if no LSP

---

## Quickfix Window
- Automatically opens on the right side
- Width is locked (won't resize)
- Build errors appear here

---

## Special Features

**Escape Key Disabled in Insert Mode**
- `<Esc>` does nothing in insert mode
- Use `<C-[>` or `<C-c>` instead

**Transparent Background**
- Normal, float, and statusline backgrounds are transparent

**No Mouse Support**
- Mouse is completely disabled

**No Swap/Backup Files**
- Clean working directory

**Clipboard Integration**
- System clipboard is used by default (`unnamedplus`)

---

## Installed LSP Servers
- **clangd** - C/C++ (auto-enabled)
- **gopls** - Go
- **rust_analyzer** - Rust

---

## Treesitter Languages
Syntax highlighting for:
- C
- Lua
- Go
- Rust

---

## Tips

1. **Finding build.sh**: The build runner searches upward from your current file, so it works from any subdirectory

2. **Quickfix navigation**: Use `:cnext` and `:cprev` to navigate build errors

3. **LSP not working?**: Check `:LspInfo` to see if server is attached

4. **Format code manually**: `:lua vim.lsp.buf.format()` for LSP formatting

5. **Clear quickfix**: `:cclose` to close the quickfix window

---

## Command Mode Useful Commands
| Command | Action |
|---------|--------|
| `:LspInfo` | Show LSP status |
| `:LspRestart` | Restart LSP servers |
| `:Lazy` | Open plugin manager |
| `:TSUpdate` | Update treesitter parsers |
| `:checkhealth` | Check Neovim health |
