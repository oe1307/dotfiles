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

-- Start insert mode with terminal
autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert",
})

-- Don't show line numbers in terminal
autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber norelativenumber",
})
