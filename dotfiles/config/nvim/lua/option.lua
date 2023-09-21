-- user interface
vim.opt.mouse = ""
vim.opt.smartindent = true
vim.opt.shell = "zsh"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = "tab:> ,trail:-"
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 50
vim.opt.cindent = true
vim.opt.path:append({ "**" })
vim.opt.diffopt:append({ "vertical" })

-- backup
vim.opt.writebackup = false
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim"

-- language
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
