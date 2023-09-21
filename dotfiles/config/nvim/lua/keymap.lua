local keymap = vim.keymap
local autocmd = vim.api.nvim_create_autocmd

-- move to the beginning of the line
keymap.set("", "4", "$")

-- increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("v", "+", "<C-a>gv")
keymap.set("n", "-", "<C-x>")
keymap.set("v", "-", "<C-x>gv")

-- delete keymap
keymap.set("n", "d", "")
keymap.set("n", "dd", "dd")
keymap.set("n", "x", "")
keymap.set("n", "<C-d>", "")

-- do not yank
keymap.set("v", "x", '"_x')
keymap.set("n", "xx", '"_dd')
keymap.set("n", "X", '"_d$')

-- delete word
keymap.set("n", "dw", "daw")

-- select line
keymap.set("v", "v", "V")

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

-- terminal
keymap.set("n", "<C-t>", ":vsplit | term<Return>", { silent = true })
keymap.set("t", "<C-t>", "<C-\\><C-n>:vsplit | term<Return>", { silent = true })

-- escape terminal
keymap.set("t", "<esc>", "<C-\\><C-n>")

-- select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- move window
keymap.set("n", "<Space>", "<C-w>w")

-- replace
keymap.set("n", "<C-c>", ":%s;;;g<Left><Left><Left>")
keymap.set("v", "<C-c>", ":s;;;g<Left><Left><Left>")

-- move previous buffer
keymap.set("n", "<C-z>", ":b #<Return>", { silent = true })

-- new tab
keymap.set("n", "tt", ":tabnew | Alpha<Return>", { silent = true })

-- move tab
keymap.set("n", "bb", ":bnext<Return>", { silent = true })

-- quit
keymap.set("n", "<C-q>", ":q<Return>", { silent = true })

-- ignore <CR>
keymap.set("n", "<CR>", "j")

-- keep indent
keymap.set("n", "o", "o.<BS><esc>a")
keymap.set("n", "O", "O.<BS><esc>a")

-- python::breakpoint()
autocmd("FileType", {
    pattern = "python",
    command = ":map <silent> <C-s> obreakpoint()<esc>^",
})

-- markdown::preview
autocmd("FileType", {
    pattern = "markdown",
    command = "nmap <silent> <C-s> :MarkdownPreview<Return>",
})
