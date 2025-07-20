# Neovim LSP Cheat Sheet

## Leader Key
Your leader key is **`\`** (backslash) - this is the default in Neovim.

## LSP Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to Definition | Jump to where a function/variable is defined |
| `gr` | Go to References | Show all places where symbol is used |
| `K` | Hover Documentation | Show docs/type info for symbol under cursor |

## Error/Diagnostic Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `[d` | Previous Diagnostic | Go to previous error/warning |
| `]d` | Next Diagnostic | Go to next error/warning |
| `\e` | Show Error Float | Show error details in popup window |
| `\q` | Error List | Show all errors in quickfix list |

## Code Editing
| Key | Action | Description |
|-----|--------|-------------|
| `\rn` | Rename Symbol | Rename variable/function across entire codebase |
| `\ca` | Code Actions | Show available fixes/suggestions |
| `\f` | Format Buffer | Auto-format current file |

## Autocompletion (when popup appears)
| Key | Action |
|-----|--------|
| `Tab` | Next completion item |
| `Ctrl+Space` | Trigger completion manually |
| `Enter` | Accept completion |
| `Ctrl+d` | Scroll docs down |
| `Ctrl+f` | Scroll docs up |

## Tips
- LSP features only work when a language server is running (you'll see "LSP" in status)
- For Python files, Pyright LSP should start automatically
- Errors/warnings appear as underlines with colored text
- Use `:LspInfo` to check LSP status
- Use `:Mason` to manage language servers