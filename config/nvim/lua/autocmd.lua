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

-- marp
local marp_augroup = vim.api.nvim_create_augroup("MarpPreviewGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = marp_augroup,
    pattern = "markdown",
    callback = function()
        if vim.bo.buftype ~= "" or vim.fn.empty(vim.fn.expand("%")) == 1 then
            return
        end
        local command_args = {
            vim.fn.expand("%"),
            "-p",
            "--theme",
            vim.fn.expand("~/dotfiles/config/marp/ntt.css"),
        }

        vim.loop.spawn("marp", {
            args = command_args,
            cwd = vim.fn.fnamemodify(vim.fn.expand("%"), ":h"),
        }, function(exit_code, signal)
            if exit_code ~= 0 then
                vim.notify("Marp Preview failed (Exit Code: " .. exit_code .. ")", vim.log.levels.ERROR)
            end
        end)
    end,
})
