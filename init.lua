-- Disable netrw at the very start of your init.lua.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Optionally enable 24-bit colour.
vim.opt.termguicolors = true

-- Plugins.
local lazy = {}

function lazy.install(path)
    if not vim.loop.fs_stat(path) then
        print("Installing lazy.nvim...")
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            path,
        })
    end
end

function lazy.setup(plugins)
    if vim.g.plugins_ready then
        return
    end

    lazy.install(lazy.path)
    vim.opt.rtp:prepend(lazy.path)
    require("lazy").setup(plugins, lazy.opts)
    vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
lazy.opts = {}

lazy.setup({
    { "tpope/vim-commentary" },
    { "tpope/vim-surround" },
    { "tpope/vim-fugitive" },
    { "navarasu/onedark.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-tree/nvim-web-devicons" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "sbdchd/neoformat" },
    { "https://codeberg.org/FelipeLema/cmp-async-path" },
})

require("onedark").load()
require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = "onedark",
        section_separators = "",
        component_separators = "",
    },
})
require("nvim-web-devicons").setup()
require("nvim-tree").setup({
    filters = {
        dotfiles = true,
    },
})
require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = "all",

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "norg" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 KB
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})

-- Leader.
vim.g.mapleader = " "

-- Mouse.
vim.opt.mouse = "a"

-- Numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.keymap.set("n", "<Leader>n", ":NvimTreeToggle<Cr>", { silent = true, noremap = true })

-- Emacs.
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-b>", "<Left>")

-- Braces.
vim.keymap.set("i", "()", "()<Esc>i")
vim.keymap.set("i", "{}", "{}<Esc>i")
vim.keymap.set("i", "[]", "[]<Esc>i")
vim.keymap.set("i", "<>", "<><Esc>i")
vim.keymap.set("i", "''", "''<Esc>i")
vim.keymap.set("i", '""', '""<Esc>i')
vim.keymap.set("i", "$$", "$$<Esc>i")
vim.keymap.set("i", "``", "``<Esc>i")

vim.keymap.set("i", "<C-o>", "<Esc>O")

-- Quick Configuration Edit.
vim.keymap.set("n", "<Leader>e", ":e $MYVIMRC<Cr>")
vim.keymap.set("n", "<Leader>r", ":source $MYVIMRC<Cr>")

-- No Highlight.
vim.keymap.set("n", "<Leader>m", ":noh<Cr>", { silent = true })

-- Copying.
vim.keymap.set("", "<Leader>y", '"*y')
vim.keymap.set("", "<Leader>p", '"*p')

-- Spelling.
vim.opt.linebreak = true
vim.g.spellfile_URL = "https://ftp.pl.vim.org/pub/vim/runtime/spell"
vim.opt.spell = true
vim.opt.spelllang = "ru_yo,en_us"
vim.opt.keymap = "russian-jcukenmac"
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.keymap.set("n", "<Leader>s", ":set spell!<Cr>")

-- LSP.
vim.opt.signcolumn = "yes"

local cmp = require("cmp")
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "async_path" },
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        -- scroll up and down the documentation window
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<Cr>"] = cmp.mapping.confirm({ select = true }),
        -- Jump to the next snippet placeholder
        ["<C-f>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        -- Jump to the previous snippet placeholder
        ["<C-b>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
})

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
    vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.c", "*.h", "*.zig", "*.lua", "*.rust", "*.py" },
    desc = "Neoformat",
    command = "Neoformat",
})

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<Leader>q", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end,
})

require("nvim-tree").setup({
    renderer = {
        icons = {
            show = {
                file = false,
                folder = false,
            },
        },
    },
})

require("lspconfig").zls.setup({
    settings = {
        zls = {
            Zls = {
                enableAutofix = true,
                enable_snippets = true,
                enable_ast_check_diagnostics = true,
                enable_autofix = true,
                enable_import_embedfile_argument_completions = true,
                warn_style = true,
                enable_semantic_tokens = true,
                enable_inlay_hints = true,
                inlay_hints_hide_redundant_param_names = true,
                inlay_hints_hide_redundant_param_names_last_token = true,
                operator_completions = true,
                include_at_in_builtins = true,
                max_detail_length = 1048576,
            },
        },
    },
})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").clangd.setup({})
require("lspconfig").pyright.setup({})
require("lspconfig").bashls.setup({})
require("lspconfig").lua_ls.setup({
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        })
    end,
    settings = {
        Lua = {},
    },
})
