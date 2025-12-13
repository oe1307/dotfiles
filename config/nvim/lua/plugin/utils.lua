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
        -- git signs
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
            vim.opt.signcolumn = "auto"
        end,
    },
    {
        -- git diff
        "dinhhuy258/git.nvim",
        keys = { { "gd", ":GitDiff<Return>", silent = true } },
        config = function()
            require("git").setup({ default_mappings = false })
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
                ensure_installed = { "python" },
            })
        end,
    },
}
