return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
            vim.opt.signcolumn = "auto"
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = { { "lg", ":LazyGitCurrentFile<Return>", silent = true } },
    },
    {
        "dinhhuy258/git.nvim",
        keys = { { "gd", ":GitDiff<Return>", silent = true } },
        config = function()
            require("git").setup({ default_mappings = false })
        end,
    },
}
