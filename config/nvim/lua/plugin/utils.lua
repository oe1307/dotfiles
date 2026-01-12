return {
    {
        -- message
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        keys = { { "nh", ":Noice history<Return>", silent = true } },
        config = function()
            require("noice").setup({
                lsp = { override = { ["cmp.entry.get_documentation"] = true } },
            })
            require("notify").setup({ background_colour = "#000000" })
        end,
    },
    {
        -- colorscheme
        "Mofiqul/vscode.nvim",
        lazy = false,
        config = function()
            require("vscode").setup({ transparent = true })
            require("vscode").load()
        end,
    },
    {
        -- comment out
        "numToStr/Comment.nvim",
        event = "BufReadPost",
        config = function()
            require("Comment").setup()
        end,
    },
    {
        -- todo highlight
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end,
    },
    {
        -- auto pairs
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ map_bs = false })
        end,
    },
    {
        -- multiple cursors
        "mg979/vim-visual-multi",
        keys = { "<C-n>", mode = { "n" } },
    },
    {
        -- git signs
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup()
            vim.opt.signcolumn = "auto"
        end,
    },
    {
        -- git diff
        "dinhhuy258/git.nvim",
        event = "VeryLazy",
        keys = {
            { "gd", ":GitDiff<Return>", silent = true },
            { "gs", ":Git status -s<Return>", silent = true },
            { "gt", ":Git add -A && git commit -m update && git pull && git push<Return>", silent = true },
        },
        config = function()
            require("git").setup({ default_mappings = false })
        end,
    },
    {
        -- syntax highlighting
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = function()
            require("nvim-treesitter").install({ "python" })
        end,
        config = function()
            require("nvim-treesitter").setup({})
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    {
        -- status bar
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "wombat", globalstatus = true },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "filename", path = 3 } },
                    lualine_c = { "diagnostics" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "filetype" },
                },
            })
        end,
    },
    {
        -- focus mode
        "tadaa/vimade",
        opts = {
            recipe = { "default", { animate = true } },
            fadelevel = 0.7,
        },
    },
    {
        -- custom diagnostic display
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
}
