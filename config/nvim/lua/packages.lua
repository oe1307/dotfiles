return {
    {
        -- message
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            { "rcarriga/nvim-notify", opts = { background_colour = "#000000" } },
        },
        keys = { { "?", ":Noice history<Return>", silent = true, noremap = true } },
        opts = { lsp = { override = { ["cmp.entry.get_documentation"] = true } } },
    },
    {
        -- colorscheme
        "Mofiqul/vscode.nvim",
        lazy = false,
        config = function()
            require("vscode").setup({ transparent = true })
            vim.cmd.colorscheme("vscode")
        end,
    },
    {
        -- todo highlight
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
    },
    {
        -- multiple cursors
        "mg979/vim-visual-multi",
        keys = { { "<C-n>", mode = { "n" } } },
    },
    {
        -- git signs
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        -- git diff
        "tpope/vim-fugitive",
        event = "VeryLazy",
        keys = { { "gd", ":Gdiffsplit<Return>", silent = true } },
    },
    {
        -- syntax highlighting
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = function()
            require("nvim-treesitter").install({ "python", "html", "ssh_config", "systemverilog" })
        end,
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    {
        -- status bar
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "wombat", globalstatus = true },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "filename", path = 3 } },
                    lualine_c = { "diagnostics" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "filetype" },
                },
            })
        end,
    },
    {
        -- focus mode
        "tadaa/vimade",
        opts = { recipe = { "default", { animate = true } }, fadelevel = 0.7 },
    },
    {
        -- formatter
        "stevearc/conform.nvim",
        keys = { { "ff", ":lua require('conform').format()<Enter>", silent = true } },
        opts = {
            formatters_by_ft = {
                python = { "ruff_format", "isort" },
                lua = { "stylua" },
                verilog = { "verible" },
                systemverilog = { "verible" },
                markdown = { "prettier" },
                css = { "prettier" },
                ["*"] = { "trim_whitespace" },
            },
            formatters = {
                isort = { prepend_args = { "--profile", "black" } },
                stylua = { prepend_args = { "--indent-type", "Spaces" } },
            },
        },
    },
    {
        -- language server
        "neovim/nvim-lspconfig",
        keys = { { "K", vim.lsp.buf.definition, silent = true } },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            vim.lsp.enable({ "pyright", "lua_ls", "verible" })
            local cap = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("pyright", { capabilities = cap })
            vim.lsp.config(
                "lua_ls",
                { capabilities = cap, settings = { Lua = { diagnostics = { globals = { "vim" } } } } }
            )
            vim.lsp.config("verible", { capabilities = cap })
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "󰌶",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
            })
        end,
    },
    {
        -- linter
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "flake8" },
                verilog = { "verible" },
                systemverilog = { "verible" },
            }
            vim.list_extend(lint.linters.flake8.args or {}, { "--max-line-length", "88" })
            lint.linters.verible = {
                cmd = "verible-verilog-lint",
                stdin = false,
                append_fname = true,
                args = { "--parse_fatal" },
                stream = "stdout",
                ignore_exitcode = true,
                parser = require("lint.parser").from_pattern(
                    [[([^:]+):(%d+):(%d+): ([^:]+): (.+)]],
                    { "file", "lnum", "col", "severity", "message" },
                    {
                        severities = {
                            error = vim.diagnostic.severity.ERROR,
                            warning = vim.diagnostic.severity.WARN,
                        },
                    }
                ),
            }
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        -- custom diagnostic display
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            require("tiny-inline-diagnostic").setup({
                options = {
                    use_icons_from_diagnostic = true,
                    multilines = { enabled = true },
                    enable_on_insert = true,
                    enable_on_select = true,
                    show_all_diags_on_cursorline = true,
                    show_diags_only_under_cursor = true,
                },
            })
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
    {
        -- nvim-cmp
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- plugin
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",

            -- snippet
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
            })

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    },
}
