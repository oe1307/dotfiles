vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "R", ":belowright split | term python %<Enter>i", silent=true)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "<C-s>", "o# breakpoint()<esc>", silent=true)
    end,
})
