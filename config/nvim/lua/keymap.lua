local keymap = vim.keymap
local autocmd = vim.api.nvim_create_autocmd

-- move to the end of the line
keymap.set("", "4", "$")

-- increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("v", "+", "<C-a>gv")
keymap.set("n", "-", "<C-x>")
keymap.set("v", "-", "<C-x>gv")

-- delete
keymap.set("n", "d", "")
keymap.set("n", "dd", "dd")
keymap.set("n", "x", "")
keymap.set("n", "<C-d>", "")

-- delete word
keymap.set("n", "dw", "daw")
keymap.set("n", "xw", '"_daw')

-- do not yank
keymap.set("v", "x", '"_x')
keymap.set("n", "xx", '"_dd')
keymap.set("n", "X", '"_d$')

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

-- select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- move window
keymap.set("n", "<Space>", "<C-w>w")
keymap.set("n", "<C-w>", "<C-w>W")

-- replace
keymap.set("n", "<C-c>", ":%s;;;g<Left><Left><Left>")
keymap.set("v", "<C-c>", ":s;;;g<Left><Left><Left>")

-- quit
keymap.set("n", "<C-q>", ":qa<Return>", { silent = true })

-- ignore <CR>
keymap.set("n", "<CR>", "j")

-- keep indent
keymap.set("n", "o", "o.<BS><esc>a")
keymap.set("n", "O", "O.<BS><esc>a")

-- previous file
keymap.set("n", "Z", ":bp<Return>", { silent = true })
