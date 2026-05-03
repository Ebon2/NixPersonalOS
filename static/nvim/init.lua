-- ============================================================
--  init.lua — Neovim config para devs serios
--  Basado en lazy.nvim | LSP nativo (0.11+) | Sin drama
-- ============================================================

-- ========================
--  Opciones globales
-- ========================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.termguicolors  = true
opt.showmode       = false          -- lualine lo muestra, no necesitamos duplicar
opt.pumheight      = 10            -- máx items en popup de autocompletado
opt.cmdheight      = 1

-- Comportamiento de edición
opt.wrap         = false
opt.scrolloff    = 8
opt.sidescrolloff = 8
opt.splitright   = true
opt.splitbelow   = true

-- Indentación
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true
opt.shiftround  = true

-- Búsqueda
opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true

-- Performance y UX
opt.updatetime  = 250
opt.timeoutlen  = 400
opt.undofile    = true           -- undo persistente entre sesiones
opt.swapfile    = false
opt.backup      = false
opt.clipboard   = "unnamedplus"

-- ========================
--  Keymaps
-- ========================
local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Guardar / Salir
map("n", "<leader>w",  ":w<CR>",   "Guardar archivo")
map("n", "<leader>q",  ":q<CR>",   "Cerrar ventana")
map("n", "<leader>Q",  ":qa!<CR>", "Cerrar todo sin guardar")

-- Explorador de archivos
map("n", "<leader>e", ":Ex<CR>", "Explorador (netrw)")

-- Mover líneas en modo visual (clásico)
map("v", "J", ":m '>+1<CR>gv=gv", "Mover selección abajo")
map("v", "K", ":m '<-2<CR>gv=gv", "Mover selección arriba")

-- Mantener cursor centrado al buscar / scroll
map("n", "n",     "nzzzv",   "Siguiente resultado (centrado)")
map("n", "N",     "Nzzzv",   "Resultado anterior (centrado)")
map("n", "<C-d>", "<C-d>zz", "Scroll abajo (centrado)")
map("n", "<C-u>", "<C-u>zz", "Scroll arriba (centrado)")

-- Splits: navegación
map("n", "<C-h>", "<C-w>h", "Split izquierda")
map("n", "<C-l>", "<C-w>l", "Split derecha")
map("n", "<C-j>", "<C-w>j", "Split abajo")
map("n", "<C-k>", "<C-w>k", "Split arriba")

-- Splits: redimensionar
map("n", "<C-Up>",    ":resize +2<CR>",          "Aumentar alto")
map("n", "<C-Down>",  ":resize -2<CR>",           "Disminuir alto")
map("n", "<C-Left>",  ":vertical resize -2<CR>",  "Disminuir ancho")
map("n", "<C-Right>", ":vertical resize +2<CR>",  "Aumentar ancho")

-- Buffers
map("n", "<leader>bn", ":bnext<CR>",     "Buffer siguiente")
map("n", "<leader>bp", ":bprevious<CR>", "Buffer anterior")
map("n", "<leader>bd", ":bdelete<CR>",   "Cerrar buffer")

-- Pegar sin perder el yank (modo visual)
map("v", "p", '"_dP', "Pegar sin sobrescribir registro")

-- Limpiar highlights de búsqueda
map("n", "<Esc>", ":nohlsearch<CR>", "Limpiar búsqueda")

-- Abrir terminal vertical
map("n", "<leader>t", ":vsplit | terminal<CR>", "Terminal vertical")

-- ========================
--  Autocomandos
-- ========================

-- Resaltar el texto al copiar (yank)
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yank",
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Volver a la última posición del cursor al abrir un archivo
vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Restaurar posición del cursor",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Cerrar ciertos buffers con 'q'
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "qf", "man", "lspinfo", "checkhealth" },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
    end,
})

-- ========================
--  Bootstrap lazy.nvim
-- ========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ========================
--  Plugins
-- ========================
require("lazy").setup({

    -- ─── Tema ────────────────────────────────────────────────
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                transparent = false,
                dimInactive = true,
            })
            vim.cmd("colorscheme kanagawa")
        end,
    },

    -- ─── Statusline ──────────────────────────────────────────
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "kanagawa",
                    globalstatus = true,
                    component_separators = "|",
                    section_separators   = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- ─── Treesitter ──────────────────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        -- Usar `opts` en lugar de `config` evita problemas de module path
        -- (común en NixOS y entornos con LuaJIT gestionado externamente)
        opts = {
            ensure_installed = {
                "lua", "python", "javascript", "typescript",
                "tsx", "c", "cpp", "bash", "json", "yaml",
                "html", "css", "markdown", "markdown_inline",
            },
            highlight = { enable = true },
            indent    = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection    = "<C-space>",
                    node_incremental  = "<C-space>",
                    node_decremental  = "<bs>",
                },
            },
        },
        config = function(_, opts)
            -- pcall por si el módulo tarda en estar disponible en el primer arranque
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                vim.notify("nvim-treesitter no disponible aún, reinicia nvim", vim.log.levels.WARN)
                return
            end
            configs.setup(opts)
        end,
    },

    -- ─── LSP (API nativa Neovim 0.11+) ───────────────────────
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Diagnósticos: íconos en el gutter
            vim.diagnostic.config({
                virtual_text    = true,
                signs           = true,
                underline       = true,
                update_in_insert = false,
                severity_sort   = true,
                float = {
                    border = "rounded",
                    source = true,
                },
            })

            -- Servidores LSP — agrega / quita según tu stack
            local servers = { "clangd", "pyright", "ts_ls" }
            for _, srv in ipairs(servers) do
                vim.lsp.config(srv, {})
                vim.lsp.enable(srv)
            end

            -- Keymaps cuando se adjunta un LSP al buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    local lsp = vim.lsp.buf
                    vim.keymap.set("n", "gd",         lsp.definition,     vim.tbl_extend("force", opts, { desc = "Ir a definición" }))
                    vim.keymap.set("n", "gD",         lsp.declaration,    vim.tbl_extend("force", opts, { desc = "Ir a declaración" }))
                    vim.keymap.set("n", "gr",         lsp.references,     vim.tbl_extend("force", opts, { desc = "Referencias" }))
                    vim.keymap.set("n", "gi",         lsp.implementation, vim.tbl_extend("force", opts, { desc = "Implementación" }))
                    vim.keymap.set("n", "K",          lsp.hover,          vim.tbl_extend("force", opts, { desc = "Hover doc" }))
                    vim.keymap.set("n", "<leader>rn", lsp.rename,         vim.tbl_extend("force", opts, { desc = "Renombrar" }))
                    vim.keymap.set("n", "<leader>ca", lsp.code_action,    vim.tbl_extend("force", opts, { desc = "Code action" }))
                    vim.keymap.set("n", "<leader>D",  lsp.type_definition,vim.tbl_extend("force", opts, { desc = "Tipo de definición" }))
                    vim.keymap.set("n", "<leader>f",  function()
                        lsp.format({ async = true })
                    end, vim.tbl_extend("force", opts, { desc = "Formatear buffer" }))

                    -- Diagnósticos
                    vim.keymap.set("n", "gl",  vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Ver diagnóstico" }))
                    vim.keymap.set("n", "[d",  vim.diagnostic.goto_prev,  vim.tbl_extend("force", opts, { desc = "Diagnóstico anterior" }))
                    vim.keymap.set("n", "]d",  vim.diagnostic.goto_next,  vim.tbl_extend("force", opts, { desc = "Diagnóstico siguiente" }))
                end,
            })
        end,
    },

    -- ─── Autocompletado ──────────────────────────────────────
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",   -- snippets listos para usar
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")

            -- Carga snippets de friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"]     = cmp.mapping.select_prev_item(),
                    ["<C-j>"]     = cmp.mapping.select_next_item(),
                    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]     = cmp.mapping.abort(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
                    -- Tab para navegar snippets
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer",  keyword_length = 3 },
                    { name = "path" },
                }),
                formatting = {
                    format = function(entry, item)
                        local icons = {
                            Text          = "󰉿",
                            Method        = "󰆧",
                            Function      = "󰊕",
                            Constructor   = "",
                            Field         = "󰜢",
                            Variable      = "󰀫",
                            Class         = "󰠱",
                            Interface     = "",
                            Module        = "",
                            Property      = "󰜢",
                            Unit          = "󰑭",
                            Value         = "󰎠",
                            Enum          = "",
                            Keyword       = "󰌋",
                            Snippet       = "",
                            Color         = "󰏘",
                            File          = "󰈙",
                            Reference     = "󰈇",
                            Folder        = "󰉋",
                            EnumMember    = "",
                            Constant      = "󰏿",
                            Struct        = "󰙅",
                            Event         = "",
                            Operator      = "󰆕",
                            TypeParameter = "",
                        }
                        item.kind = string.format("%s %s", icons[item.kind] or "", item.kind)
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snip]",
                            buffer   = "[Buf]",
                            path     = "[Path]",
                        })[entry.source.name]
                        return item
                    end,
                },
            })
        end,
    },

    -- ─── Telescope ───────────────────────────────────────────
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Extensión nativa para mayor performance
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond  = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end,               desc = "Buscar archivos" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,                desc = "Grep en proyecto" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end,                  desc = "Buffers abiertos" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end,                desc = "Ayuda de Neovim" },
            { "<leader>fr", function() require("telescope.builtin").oldfiles() end,                 desc = "Archivos recientes" },
            { "<leader>fd", function() require("telescope.builtin").diagnostics() end,              desc = "Diagnósticos" },
            { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end,     desc = "Símbolos del documento" },
            { "<leader>gc", function() require("telescope.builtin").git_commits() end,              desc = "Git commits" },
            { "<leader>gs", function() require("telescope.builtin").git_status() end,               desc = "Git status" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    prompt_prefix   = "  ",
                    selection_caret = " ",
                    path_display    = { "truncate" },
                    file_ignore_patterns = {
                        "node_modules", ".git/", "dist/", "build/",
                        "%.lock", "__pycache__",
                    },
                },
            })
            -- Cargar extensión fzf si está disponible
            pcall(telescope.load_extension, "fzf")
        end,
    },

    -- ─── Git ─────────────────────────────────────────────────
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local opts = { buffer = bufnr }

                    vim.keymap.set("n", "]h", gs.next_hunk,         vim.tbl_extend("force", opts, { desc = "Siguiente hunk" }))
                    vim.keymap.set("n", "[h", gs.prev_hunk,         vim.tbl_extend("force", opts, { desc = "Hunk anterior" }))
                    vim.keymap.set("n", "<leader>hs", gs.stage_hunk,    vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
                    vim.keymap.set("n", "<leader>hr", gs.reset_hunk,    vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
                    vim.keymap.set("n", "<leader>hb", gs.blame_line,    vim.tbl_extend("force", opts, { desc = "Blame línea" }))
                    vim.keymap.set("n", "<leader>hp", gs.preview_hunk,  vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
                end,
            })
        end,
    },

    -- ─── Comentarios ─────────────────────────────────────────
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("Comment").setup()
            -- gcc = comentar línea | gc en visual = comentar selección
        end,
    },

    -- ─── Pares automáticos ───────────────────────────────────
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({ check_ts = true })    -- usa treesitter para contexto

            -- Integración con nvim-cmp
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- ─── Indentation guides ──────────────────────────────────
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ibl").setup({
                indent  = { char = "│" },
                scope   = { enabled = true },
                exclude = { filetypes = { "help", "dashboard", "neo-tree" } },
            })
        end,
    },

    -- ─── which-key: muestra keymaps disponibles ───────────────
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                delay = 500,
            })
        end,
    },

    -- ─── Todo Comments ───────────────────────────────────────
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
            -- Buscar todos los TODOs: <leader>ft
            vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Buscar TODOs" })
        end,
    },

}, {
    -- Opciones de lazy.nvim
    ui = {
        border = "rounded",
    },
    checker = {
        enabled = true,   -- notifica updates de plugins
        notify  = false,  -- sin spam de notificaciones
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
})

-- ============================================================
--  FIN — Happy coding 🚀
-- ============================================================
