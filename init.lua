-- Лідер-клавіша
vim.g.mapleader = " "

-- 1. Ініціалізація Packer
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'nvim-treesitter/nvim-treesitter'
  use 'mfussenegger/nvim-dap'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-telescope/telescope.nvim'
end)

-- 2. Treesitter (Покращена підсвітка)
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "lua", "bash" },
  highlight = { enable = true },
}

-- 3. Налаштування LSP
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Налаштовуємо Pyright (логіка)
lspconfig.pyright.setup{
  capabilities = capabilities,
}

-- Налаштовуємо Ruff (лінтер і швидкий форматер)
lspconfig.ruff.setup{
  capabilities = capabilities,
}

-- 4. Автодоповнення (cmp)
local cmp = require'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- 5. Nvim-tree
require("nvim-tree").setup({
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = false },
})

-- 6. Telescope
require('telescope').setup{}

-- 7. Клавіші (Hotkeys)
local key = vim.keymap.set
key('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
key('n', '<leader>ff', ':Telescope find_files<CR>', { silent = true })
key('n', '<leader>r', ':w<CR>:!python %<CR>', { silent = true })

-- Додамо корисні LSP-хоткеї
key('n', 'gd', vim.lsp.buf.definition)      -- Перейти до визначення
key('n', 'K', vim.lsp.buf.hover)           -- Документація при наведенні
key('n', '<leader>ca', vim.lsp.buf.code_action) -- Швидкі виправлення
