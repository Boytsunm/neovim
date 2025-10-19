-- Лідер-клавіша
vim.g.mapleader = " "

-- Ініціалізація packer
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

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python" },
  auto_install = true,
  highlight = { enable = true },
}

-- Автодоповнення
local cmp = require'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- Nvim-tree
require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  filters = {
    dotfiles = false,
  },
})

-- Telescope
require('telescope').setup{}

-- Клавіші
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', ':w<CR>:!python %<CR>', { noremap = true, silent = true })

-- Pyright через новий API
vim.lsp.config.pyright = {
  default_config = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = vim.fn.getcwd(),
    settings = {},
  }
}

-- Автозапуск LSP для Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    local clients = vim.lsp.get_clients({ name = "pyright" })
    if #clients == 0 then
      vim.lsp.start({
        name = "pyright",
        cmd = vim.lsp.config.pyright.default_config.cmd,
        root_dir = vim.lsp.config.pyright.default_config.root_dir,
      })
    end
  end,
})
