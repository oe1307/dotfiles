return {
    {
        -- message
        "folke/noice.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
        },
        config = function()
            require("noice").setup({
                messages = { view_error = "messages", view_warn = "messages" },
            })
        end,
    },
    {
        -- colorscheme
        "Mofiqul/vscode.nvim",
        config = function()
            require("vscode").setup({ transparent = true })
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
            require("nvim-autopairs").setup({ map_bs = false })
        end,
    },
    {
        -- multiple cursors
        "mg979/vim-visual-multi",
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
        "hrsh7th/vim-vsnip",
        dependencies = "hrsh7th/vim-vsnip-integ",
    },
}
