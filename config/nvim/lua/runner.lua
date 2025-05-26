vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "R", ":term python %<Enter>")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "<C-s>", "o# -- DEBUG --<Enter>print()<Enter># -- End --<Enter><Esc>kk$i\"\"<Left>")
    end,
})
