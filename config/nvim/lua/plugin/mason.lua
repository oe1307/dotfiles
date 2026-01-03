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
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason").setup()
            local lsp = vim.lsp
            local formatter = require("conform")
            local linter = require("lint")

            -- install
            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- python
                    "pyright",
                    "ruff",
                    "isort",
                    "flake8",
                    -- lua
                    "stylua",
                    "emmylua_ls",
                },
                auto_update = true,
            })

            -- lsp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            lsp.config("pyright", {
                capabilities = capabilities,
            })
            lsp.config("emmylua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            lsp.enable({ "pyright", "emmylua_ls" })

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
                    stylua = {
                        prepend_args = { "--indent-type", "Spaces" },
                    },
                },
            })

            -- linter
            linter.flake8 = { cmd = { "flake8" } }
        end,
    },
}
