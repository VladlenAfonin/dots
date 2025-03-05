-- Plugins.
local lazy = {}

function lazy.install(path)
    if not vim.loop.fs_stat(path) then
        print('Installing lazy.nvim....')
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            path,
        })
    end
end

function lazy.setup(plugins)
    if vim.g.plugins_ready then
        return
    end

    -- You can "comment out" the line below after lazy.nvim is installed.
    lazy.install(lazy.path)

    vim.opt.rtp:prepend(lazy.path)

    require('lazy').setup(plugins, lazy.opts)
    vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
    {'tpope/vim-commentary'},
    {'tpope/vim-surround'},
    {'tpope/vim-fugitive'},
    {'navarasu/onedark.nvim'},
    {'nvim-lualine/lualine.nvim'},

    -- LSP Setup.
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {'saadparwaiz1/cmp_luasnip'},
})

require('onedark').load()
require('lualine').setup({
    options = {
        icons_enabled = false,
        theme = 'onedark',
        section_separators = '',
        component_separators = '',
    }
})

-- Leader.
vim.g.mapleader = ' '

-- Mouse.
vim.opt.mouse = 'a'

-- Numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Emacs.
vim.keymap.set('i', '<C-f>', '<Right>')
vim.keymap.set('i', '<C-b>', '<Left>')

-- Braces.
vim.keymap.set('i', '()', '()<Esc>i')
vim.keymap.set('i', '{}', '{}<Esc>i')
vim.keymap.set('i', '[]', '[]<Esc>i')
vim.keymap.set('i', '<>', '<><Esc>i')
vim.keymap.set('i', '\'\'', '\'\'<Esc>i')
vim.keymap.set('i', '""', '""<Esc>i')
vim.keymap.set('i', '$$', '$$<Esc>i')
vim.keymap.set('i', '``', '``<Esc>i')

-- Quick Configuration Edit.
vim.keymap.set('n', '<Leader>e', ':e $MYVIMRC<Cr>')
vim.keymap.set('n', '<Leader>r', ':source $MYVIMRC<Cr>')

-- No Highlight.
vim.keymap.set('n', '<Leader>m', ':noh<Cr>', { silent = true })

-- Copying.
vim.keymap.set('', '<Leader>y', '"*y')
vim.keymap.set('', '<Leader>p', '"*p')

-- Spelling.
vim.opt.linebreak = true
vim.opt.spell = true
vim.opt.spelllang = 'ru_yo,en_us'
vim.opt.keymap = 'russian-jcukenmac'
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.keymap.set('n', '<Leader>s', ':set spell!<Cr>')

-- LSP.
vim.opt.signcolumn = 'yes'

local cmp = require('cmp')
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  snippet = {
      expand = function(args)
          require('luasnip').lsp_expand(args.body)
      end,
  },
  -- window = {
  --   completion = cmp.config.window.bordered(),
  --   documentation = cmp.config.window.bordered(),
  -- },
  mapping = cmp.mapping.preset.insert({
    -- scroll up and down the documentation window
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<Cr>'] = cmp.mapping.confirm({select = true}),
    -- Jump to the next snippet placeholder
    ['<C-f>'] = cmp.mapping(function(fallback)
      local luasnip = require('luasnip')
      if luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),
    -- Jump to the previous snippet placeholder
    ['<C-b>'] = cmp.mapping(function(fallback)
      local luasnip = require('luasnip')
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  }),
})

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

require('lspconfig').zls.setup({})
require('lspconfig').rust_analyzer.setup({})
require('lspconfig').clangd.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').bashls.setup({})
require('lspconfig').lua_ls.setup({
on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

