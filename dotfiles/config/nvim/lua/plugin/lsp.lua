return {
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        keys = {
            { "K", ":lua vim.lsp.buf.definition()<Return>", silent = true },
            { "J", ":lua vim.lsp.buf.hover()<Return>", silent = true },
            { "re", ":lua vim.lsp.buf.rename()<Return>", silent = true },
        },
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "jedi_language_server",
                    "bashls",
                    "clangd",
                },
                automatic_installation = true,
            })
            require("mason-lspconfig").setup_handlers({
                function(server)
                    require("lspconfig")[server].setup({ capabilities = capabilities })
                end,
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        settings = { Lua = { diagnostics = { enable = false }, format = { enable = false } } },
                    })
                end,
                jedi_language_server = function()
                    require("lspconfig").jedi_language_server.setup({})
                end,
                clangd = function()
                    require("lspconfig").clangd.setup({})
                end,
                bashls = function()
                    require("lspconfig").bashls.setup({})
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "markdown", "markdown_inline", "regex" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
            })
        end,
    },
}
