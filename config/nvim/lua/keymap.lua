local keymap = vim.keymap

-- restart
keymap.set("n", "<C-e>", ":edit<Return>", { silent = true })

-- shortcut
keymap.set("n", "<C-w>", ":w<Return>", { silent = true })
keymap.set("n", "<C-q>", ":q<Return>", { silent = true })

-- delete
keymap.set("n", "d", "")
keymap.set("n", "dd", "dd")
keymap.set("n", "x", "")
keymap.set("n", "<C-d>", "")
keymap.set("v", "x", '"_x')
keymap.set("n", "xx", '"_dd')
keymap.set("n", "X", '"_d$')
keymap.set("n", "dw", '"_daw')

-- move adaptive with wrap
keymap.set("n", "<Down>", "gj", { noremap = true, silent = true })
keymap.set("n", "<Up>", "gk", { noremap = true, silent = true })
keymap.set("n", "^", "g^", { noremap = true, silent = true })
keymap.set("n", "4", "g$", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", function()
    return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true })

vim.keymap.set({ "n", "v" }, "<Up>", function()
    return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true })
keymap.set("i", "<Up>", function()
  return vim.fn.pumvisible() == 1 and "<Up>" or "<C-o>gk"
end, { noremap = true, silent = true, expr = true })

keymap.set("i", "<Down>", function()
  return vim.fn.pumvisible() == 1 and "<Down>" or "<C-o>gj"
end, { noremap = true, silent = true, expr = true })

-- move indent
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")
keymap.set("n", "<", "<<")
keymap.set("n", ">", ">>")

-- command mode
keymap.set("n", ";", ":")

-- no highlight
keymap.set("n", "<Esc><Esc>", ":noh<Return>", { silent = true })

-- split window
keymap.set("n", "ss", "<C-w>v<C-w>l")

-- select all
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set("v", "<C-a>", "")

-- move window
keymap.set("n", "<Space>", "<C-w>w")
keymap.set("n", "<S-Space>", "<C-w>W")

-- replace
keymap.set("n", "<C-c>", ":%s;;;g<Left><Left><Left>")
keymap.set("v", "<C-c>", ":s;;;g<Left><Left><Left>")

-- keep indent
keymap.set("n", "o", "o.<BS><esc>a")
keymap.set("n", "O", "O.<BS><esc>a")

-- previous file
keymap.set("n", "Z", ":bp<Return>", { silent = true })

-- python keymap
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "<C-s>", "obreakpoint()<esc>h", { noremap = true, silent = true })
    end,
})
