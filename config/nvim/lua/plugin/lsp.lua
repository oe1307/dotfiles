return {
    {
        -- LSP configuration
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set("n", "K", vim.lsp.buf.definition, { buffer = bufnr })
            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup({})
        end,
    },
    {
        -- syntax highlighting
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
            })
        end,
    },
}
