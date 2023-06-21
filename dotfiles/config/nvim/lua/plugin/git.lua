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
        keys = { { "lg", ":LazyGit<Return>", silent = true } },
    },
    {
        "tpope/vim-fugitive",
        lazy = false,
        keys = { { "gd", ":Gdiffsplit<Return>", silent = true } },
    },
}
