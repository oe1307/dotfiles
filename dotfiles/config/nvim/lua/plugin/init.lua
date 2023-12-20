local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    vim.fn.system({
        "npm",
        "install",
        "-g",
        "neovim",
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    { import = "plugin/cmp" },
    { import = "plugin/filer" },
    { import = "plugin/git" },
    { import = "plugin/lsp" },
    { import = "plugin/null-ls" },
    { import = "plugin/utils" },
}, {
    lockfile = vim.fn.stdpath("data") .. "lazy-lock.json",
})
