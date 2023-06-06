return {
    {
        -- colorscheme
        "Mofiqul/vscode.nvim",
        config = function()
            require("vscode").load()
        end,
    },
    {
        -- comment out
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    {
        -- todo highlight
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end,
    },
    {
        -- auto pairs
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    {
        -- multiple cursors
        "mg979/vim-visual-multi",
        config = function()
            vim.g.VM_maps = {
                ["I BS"] = "",
            }
        end,
    },
    {
        -- auto save
        "907th/vim-auto-save",
        config = function()
            vim.g.auto_save = 1
            vim.g.auto_save_silent = 1
            vim.g.auto_save_events = { "InsertLeave", "TextChanged" }
        end,
    },
    {
        -- message
        "folke/noice.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
            })
        end,
    },
    {
        -- markdown preview
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        keys = { { "<C-s>", ":MarkdownPreview<Return>", silent = true } },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        -- snippets
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
