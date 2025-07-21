-- Neovim Configuration in Lua
-- Basic settings extracted from vim config

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

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
vim.opt.relativenumber = false

-- Current line highlighting
vim.opt.cursorline = true

-- Bracket matching and highlighting
vim.opt.showmatch = true
vim.opt.matchtime = 2

-- Colors and appearance
vim.opt.background = "dark"
vim.opt.termguicolors = false

-- Search Options
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Clear search highlighting when pressing Escape in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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

-- Plugin setup
require("lazy").setup({
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
      })
      
      local lspconfig = require("lspconfig")
      
      -- Python LSP (Pyright)
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic"
            }
          }
        }
      })
      
      -- LSP keybindings
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end,
  },
  
  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim", "bash" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  
  -- Python-specific virtual environment support
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = function()
      require("venv-selector").setup({
        auto_refresh = true,
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select virtual environment" },
    },
  },
  
  -- Formatting
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      formatters_by_ft = {
        python = { "black", "isort" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = false,
    },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
  },

  -- Bracket highlighting and matching
  {
    "luochen1990/rainbow",
    config = function()
      vim.g.rainbow_active = 1
    end,
  },

  -- Colorschemes
  { "marko-cerovac/material.nvim" },
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/everforest" },
})

-- Set default colorscheme
vim.cmd.colorscheme("material")
