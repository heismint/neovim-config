-- Load packer.nvim plugin manager
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Plugin manager
    use 'wbthomason/packer.nvim'
    
    -- Provides a visual interface for navigating the undo history
    use 'mbbill/undotree'

    -- Sensible defaults
    use 'tpope/vim-sensible'

    -- File explorer
    use 'nvim-tree/nvim-tree.lua'

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Git integration
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'

    -- LSP Configuration & Plugins
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'hrsh7th/nvim-cmp'      -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer'    -- Buffer source for nvim-cmp
    use 'hrsh7th/cmp-path'      -- Path source for nvim-cmp
    use 'hrsh7th/cmp-cmdline'   -- Cmdline source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip'      -- Snippets plugin

    -- Rust
    use 'simrat39/rust-tools.nvim'

    -- Zig
    use 'ziglang/zig.vim'

    -- Gleam/Elixir
    use 'elixir-editors/vim-elixir'

    -- Treesitter (better syntax highlighting)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Auto pairs and other productivity plugins
    use 'windwp/nvim-autopairs'   -- Autoclose brackets, quotes, etc.
    use 'tpope/vim-surround'      -- Surrounding pairs like quotes, brackets, etc.

    -- Status line
    use 'hoob3rt/lualine.nvim'    -- Status line plugin

    -- File Icons
    use 'kyazdani42/nvim-web-devicons'
end)

-- Basic settings
vim.o.number = true              -- Show line numbers
vim.o.relativenumber = true      -- Show relative line numbers
vim.o.mouse = 'a'                -- Enable mouse support
vim.o.tabstop = 4                -- Number of spaces per tab
vim.o.shiftwidth = 4             -- Number of spaces for autoindent
vim.o.expandtab = true           -- Use spaces instead of tabs
vim.o.clipboard = 'unnamedplus'  -- Use system clipboard

-- Enable syntax highlighting and file type detection
vim.cmd 'syntax on'
vim.cmd 'filetype plugin indent on'

-- Configure Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "zig", "lua", "python", "javascript", "typescript", "html", "css", "bash" },

  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },

  indent = {
    enable = true,
  },
}

-- Configure LSP for Rust, Zig, etc.
local lspconfig = require('lspconfig')

-- Rust
require('rust-tools').setup({})

-- Zig
lspconfig.zls.setup{}

-- Git signs in the gutter
require('gitsigns').setup()

-- File explorer settings (nvim-tree)
require'nvim-tree'.setup {}

-- Telescope settings
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },
  },
}

-- Autopairs setup
require('nvim-autopairs').setup()

-- Snippets setup (if using LuaSnip)
require('luasnip').setup()

-- Status line setup
require('lualine').setup {
  options = {
    theme = 'gruvbox',
  },
}

-- Configure nvim-cmp
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- Configure cmdline completion
cmp.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})

