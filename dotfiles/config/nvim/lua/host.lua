local is_mac = vim.fn.has("mac")
local is_windows = vim.fn.has("win32")

if is_mac == 1 then
    vim.opt.clipboard:append({ "unnamedplus" })
elseif is_windows == 1 then
    vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
end
