return {
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
            local action = require("null-ls").builtins.code_actions
            local completion = require("null-ls").builtins.completion
            require("null-ls").setup({
                sources = {
                    -- python
                    formatter.black,
                    formatter.isort.with({ extra_args = { "--profile", "black" } }),
                    linter.flake8.with({
                        extra_args = { "--ignore", "E402,W503,E203", "--max-line-length", "88" },
                    }),

                    -- shell
                    formatter.shfmt.with({ extra_args = { "-i", "4" } }),
                    linter.shellcheck,
                    formatter.beautysh,

                    -- lua
                    formatter.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
                    linter.luacheck.with({ extra_args = { "--globals", "vim" } }),

                    -- cpp
                    formatter.clang_format,
                    linter.cpplint.with({
                        args = { "--filter", "-legal/copyright,-whitespace/indent,-readability/todo", "$FILENAME" },
                    }),
                    linter.cmake_lint,
                    formatter.cmake_format,

                    -- json, yaml, html, markdown
                    formatter.prettier.with({ extra_args = { "--prose-wrap", "always" } }),

                    -- tex
                    formatter.latexindent.with({
                        extra_args = { "-w", "-m", "-g", "/dev/null", "-l", "~/.config/latex/indent.yaml" },
                    }),

                    -- others
                    formatter.trim_whitespace,
                    formatter.taplo,
                    completion.vsnip,
                },
            })
            require("mason-null-ls").setup({ automatic_installation = true })
        end,
    },
}
