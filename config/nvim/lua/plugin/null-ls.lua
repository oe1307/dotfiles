return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        lazy = false,
        keys = {
            { "<C-m>", ":Mason<Return>", silent = true },
            { "ff", ":lua vim.lsp.buf.format()<Return>", silent = true },
        },
        dependencies = {
            "williamboman/mason.nvim",
            "jose-elias-alvarez/null-ls.nvim",
        },
        config = function()
            local formatter = require("null-ls").builtins.formatting
            local linter = require("null-ls").builtins.diagnostics
            local completion = require("null-ls").builtins.completion
            require("null-ls").setup({
                sources = {
                    -- python
                    formatter.ruff,
                    linter.ruff,
                    formatter.isort.with({ extra_args = { "--profile", "black" } }),
                    linter.mypy.with({ extra_args = { "--ignore-missing-imports" } }),

                    -- rust
                    formatter.rustfmt,

                    -- shell
                    formatter.shfmt.with({ extra_args = { "-i", "4" } }),
                    formatter.beautysh,

                    -- lua
                    formatter.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),

                    -- cpp
                    formatter.clang_format,
                    linter.cpplint.with({
                        args = { "--filter", "-legal/copyright,-whitespace/indent,-readability/todo", "$FILENAME" },
                    }),
                    linter.cmake_lint,
                    formatter.cmake_format,

                    -- json, yaml, html, markdown
                    formatter.prettier.with({
                        filetypes = { "html", "json", "yaml" },
                        extra_args = { "--prose-wrap", "always" },
                    }),

                    -- tex
                    formatter.latexindent.with({
                        extra_args = { "-w", "-m", "-g", "/dev/null", "-l", "~/.config/latex/indent.yaml" },
                    }),

                    -- docker
                    linter.hadolint.with({
                        extra_args = { "--ignore", "DL3006", "--ignore", "DL3008", "--ignore", "DL3009" },
                    }),

                    -- others
                    formatter.trim_whitespace,
                    formatter.taplo,
                    completion.vsnip,
                },
            })
            require("mason-null-ls").setup()
        end,
    },
}
