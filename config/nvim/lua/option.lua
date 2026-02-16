-- user interface
vim.opt.mouse = ""
vim.opt.smartindent = true
vim.o.shellcmdflag = "-l -c"
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
vim.opt.diffopt:append("context:1000000")
vim.opt.report = 100000
vim.opt.clipboard:append({ "unnamedplus" })

-- backup
vim.opt.writebackup = false
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.undodir = vim.fs.normalize("~/.local/state/nvim")

-- language
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.wrap = true
  end,
})

