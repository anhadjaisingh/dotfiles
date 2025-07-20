-- Neovim Configuration in Lua
-- Basic settings extracted from vim config

-- Formatting and Indentation
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.ruler = true
vim.opt.backspace = {'indent', 'eol', 'start'}

-- Line Numbers
vim.opt.number = true

-- Search Options
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Completion
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.wildmenu = true

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"sh", "bash", "zsh"},
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})