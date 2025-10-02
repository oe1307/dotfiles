return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        keys = {
            { "K", vim.lsp.buf.definition, silent = true },
            { "ff", ":lua require('conform').format()<Enter>", silent = true },
        },
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "neovim/nvim-lspconfig",
            "stevearc/conform.nvim",
            "mfussenegger/nvim-lint",
            "rachartier/tiny-inline-diagnostic.nvim",
        },
        config = function()
            require("mason").setup()
            local lsp = require("lspconfig")
            local formatter = require("conform")
            local linter = require("lint")

            -- lsp
            lsp.pyright.setup({
                settings = {
                    python = {
                        analysis = {
                            diagnosticSeverityOverrides = {
                                reportCallIssue = "none",
                            },
                        },
                    },
                },
            })

            -- formatter
            formatter.setup({
                formatters_by_ft = {
                    python = { "ruff_format", "isort" },
                    lua = { "stylua" },
                    ["*"] = { "trim_whitespace" },
                },
                formatters = {
                    isort = {
                        prepend_args = { "--profile", "black" },
                    },
                },
            })
            formatter.formatters.stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            }

            -- linter
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false })
            linter.flake8 = { cmd = { "flake8" } }
            linter.mypy = { cmd = { "mypy" } }
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "pyright",
                    "ruff",
                    "isort",
                    "stylua",
                    "flake8",
                    "mypy",
                },
                auto_update = true,
            })
        end,
    },
}
