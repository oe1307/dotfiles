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
        opts = {
            lsp = {
                override = {
                    ["cmp.entry.get_documentation"] = true,
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
        },
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
        keys = { { "<C-n>", mode = { "n", "v" } } },
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
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "python",
                "c",
                "cpp",
                "markdown",
                "html",
                "bash",
                "html_tags",
                "markdown_inline",
            })
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
        keys = { { "<C-f>", ":lua require('conform').format()<Enter>", silent = true } },
        opts = {
            formatters_by_ft = {
                python = { "ruff_fix", "ruff_format" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                lua = { "stylua" },
                -- verilog = { "verible" },
                -- systemverilog = { "verible" },
                markdown = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                javascript = { "prettier" },
                sh = { "shfmt" },
                zsh = { "shfmt_zsh" },
                dockerfile = { "dockerfmt" },
                ["*"] = { "trim_whitespace" },
            },
            formatters = {
                stylua = { prepend_args = { "--indent-type", "Spaces" } },
                shfmt_zsh = { inherit = "shfmt", prepend_args = { "-ln=zsh" } },
            },
        },
    },
    {
        -- language server
        "neovim/nvim-lspconfig",
        lazy = false,
        keys = {
            { "K", vim.lsp.buf.definition, silent = true },
            { "H", vim.lsp.buf.hover, silent = true },
        },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cap = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("pyright", {
                capabilities = cap,
                init_options = {
                    disablePullDiagnostics = true,
                },
                settings = {
                    python = {
                        analysis = {
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
            })
            vim.lsp.config("clangd", {
                capabilities = cap,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--completion-style=detailed",
                },
            })
            vim.lsp.config(
                "lua_ls",
                { capabilities = cap, settings = { Lua = { diagnostics = { globals = { "vim" } } } } }
            )
            -- vim.lsp.config("verible", { capabilities = cap })

            vim.lsp.enable({ "pyright", "lua_ls", "clangd" })

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
        lazy = false,
        keys = {
            {
                "<C-e>",
                function()
                    vim.cmd("checktime")
                    require("lint").try_lint()
                end,
                silent = true,
                noremap = true,
            },
        },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "ruff", "mypy" },
                -- verilog = { "verible" },
                -- systemverilog = { "verible" },
            }
            -- lint.linters.verible = {
            --     cmd = "verible-verilog-lint",
            --     stdin = false,
            --     append_fname = true,
            --     args = { "--parse_fatal" },
            --     stream = "stdout",
            --     ignore_exitcode = true,
            --     parser = require("lint.parser").from_pattern(
            --         [[([^:]+):(%d+):(%d+)%-(%d+):%s*(.+)]],
            --         { "file", "lnum", "col", "end_col", "message" },
            --         { severity = vim.diagnostic.severity.WARN }
            --     ),
            -- }
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
            vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
                callback = function()
                    lint.try_lint(nil, { filter = "stdin" })
                end,
            })
            vim.keymap.set("n", "<C-y>", function()
                local bufnr = vim.api.nvim_get_current_buf()
                local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
                local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
                if vim.tbl_isempty(diagnostics) then
                    vim.notify("No diagnostics on this line")
                    return
                end
                local filename = vim.api.nvim_buf_get_name(bufnr)
                local severity_names = {
                    [vim.diagnostic.severity.ERROR] = "ERROR",
                    [vim.diagnostic.severity.WARN] = "WARN",
                    [vim.diagnostic.severity.INFO] = "INFO",
                    [vim.diagnostic.severity.HINT] = "HINT",
                }
                local messages = {}
                for _, d in ipairs(diagnostics) do
                    local parts = {
                        "file: " .. filename,
                        string.format("location: %d:%d - %d:%d", d.lnum + 1, d.col + 1, d.end_lnum + 1, d.end_col + 1),
                        "severity: " .. (severity_names[d.severity] or "UNKNOWN"),
                        "message: " .. d.message,
                    }
                    if d.code ~= nil then
                        table.insert(parts, "code: " .. tostring(d.code))
                    end
                    if d.source then
                        table.insert(parts, "source: " .. d.source)
                    end
                    local start_line = math.max(0, d.lnum - 2)
                    local end_line = math.min(vim.api.nvim_buf_line_count(bufnr), d.lnum + 3)
                    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
                    table.insert(parts, "context:")
                    for i, line in ipairs(lines) do
                        local current = start_line + i
                        local marker = current == d.lnum + 1 and ">" or " "
                        table.insert(parts, string.format("%s %d | %s", marker, current, line))
                    end
                    local lsp = d.user_data and d.user_data.lsp
                    if lsp and lsp.relatedInformation then
                        table.insert(parts, "related information:")
                        for _, info in ipairs(lsp.relatedInformation) do
                            table.insert(parts, info.message)

                            if info.location and info.location.uri then
                                local path = vim.uri_to_fname(info.location.uri)
                                local pos = info.location.range and info.location.range.start
                                if pos then
                                    table.insert(
                                        parts,
                                        string.format("  at %s:%d:%d", path, pos.line + 1, pos.character + 1)
                                    )
                                end
                            end
                        end
                    end

                    table.insert(messages, table.concat(parts, "\n"))
                end

                vim.fn.setreg("+", table.concat(messages, "\n\n"))
                vim.notify(string.format("Copied %d diagnostic(s) with context", #diagnostics))
            end, { desc = "Copy detailed diagnostics" })
        end,
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                options = {
                    use_icons_from_diagnostic = true,

                    multilines = {
                        enabled = true,
                        always_show = true,
                    },

                    show_all_diags_on_cursorline = false,
                    show_diags_only_under_cursor = false,

                    enable_on_insert = true,
                    enable_on_select = true,

                    overwrite_events = {
                        "LspAttach",
                        "BufEnter",
                    },
                },
            })

            vim.diagnostic.config({
                virtual_text = false,
            })
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
