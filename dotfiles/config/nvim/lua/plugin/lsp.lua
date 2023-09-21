return {
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        keys = {
            { "K", ":lua vim.lsp.buf.definition()<Return>", silent = true },
            { "re", ":lua vim.lsp.buf.rename()<Return>", silent = true },
        },
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "jedi_language_server",
                    "clangd",
                },
            })
            require("mason-lspconfig").setup_handlers({
                function(server)
                    require("lspconfig")[server].setup({})
                end,
                jedi_language_server = function()
                    require("lspconfig").jedi_language_server.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    })
                end,
                clangd = function()
                    require("lspconfig").clangd.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        cmd = { "clangd", "--offset-encoding=utf-16" },
                    })
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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
