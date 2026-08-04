local autocmd = vim.api.nvim_create_autocmd

-- Don't auto commenting new lines
autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
})

-- Don't delete indent of new lines
autocmd("BufEnter", {
    pattern = "*",
    command = "imap <cr> <cr>.<BS>",
})

-- Auto save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = function()
        if vim.bo.modifiable and vim.bo.modified and vim.bo.filetype ~= "lua" then
            vim.cmd("silent write")
        end
    end,
})
