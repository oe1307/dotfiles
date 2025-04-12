return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        keys = {
            { "K", vim.lsp.buf.definition, silent = true },
            { "ff", vim.lsp.buf.format, silent = true },
        },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvimtools/none-ls.nvim",
            "mfussenegger/nvim-lint",
            "rachartier/tiny-inline-diagnostic.nvim",
        },
        config = function()
            require("mason").setup()
            local lsp = require("lspconfig")
            local formatter = require("null-ls").builtins.formatting
            local linter = require("null-ls").builtins.diagnostics
            local completion = require("null-ls").builtins.completion

            lsp.pyright.setup({})
            require("null-ls").setup({
                sources = {
                    -- python
                    formatter.black,
                    formatter.isort.with({ extra_args = { "--profile", "black" } }),
                    linter.pylint,
                    linter.mypy.with({ extra_args = { "--ignore-missing-imports" } }),
                    -- shell
                    formatter.shfmt.with({ extra_args = { "-i", "4" } }),
                    -- lua
                    formatter.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
                    -- cpp
                    formatter.clang_format,
                    formatter.cmake_format,
                    linter.cmake_lint,
                    -- *
                    linter.trail_space,
                },
            })
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
}
