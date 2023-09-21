local is_mac = vim.fn.has("mac")
local is_linux = vim.fn.has("unix")
local is_windows = vim.fn.has("win32")
local is_wsl = vim.fn.has("wsl")

if is_mac == 1 then
    vim.opt.clipboard:append({ "unnamedplus" })
elseif is_linux == 1 then
    vim.opt.clipboard:append({})
elseif is_windows == 1 then
    vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
elseif is_wsl == 1 then
    vim.cmd([[
      augroup Yank
      autocmd!
      autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
      augroup END
    ]])
end
