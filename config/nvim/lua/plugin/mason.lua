return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        keys = {
            { "K", vim.lsp.buf.definition, silent = true },
            { "ff", ":lua require('conform').format()<Enter>", silent = true },
        },
        dependencies = {
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
            lsp.pyright.setup({})

            -- formatter
            formatter.setup({
                formatters_by_ft = {
                    python = { "ruff_format", "isort" },
                    lua = { "stylua" },
                    ["*"] = { "trim_whitespace" },
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
        end,
    },
}
