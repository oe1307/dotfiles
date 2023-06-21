return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        keys = { { "<C-b>", ":NvimTreeToggle<Return>", silent = true } },
        config = function()
            vim.api.nvim_set_var("loaded_netrw", 1)
            vim.api.nvim_set_var("loaded_netrwPlugin", 1)
            require("nvim-tree").setup({
                actions = {
                    open_file = {
                        quit_on_open = true,
                        window_picker = { enable = false },
                    },
                },
                view = {
                    float = {
                        enable = true,
                        open_win_config = { width = 150, height = 30, row = 10, col = 15 },
                    },
                },
                update_focused_file = { enable = true, update_cwd = true },
                filters = {
                    dotfiles = true,
                },
                renderer = {
                    highlight_git = true,
                    highlight_opened_files = "name",
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = "★",
                                renamed = "»",
                                untracked = "?",
                                deleted = "-",
                                staged = "✓",
                                unmerged = "",
                                ignored = "◌",
                            },
                        },
                    },
                },
                diagnostics = { enable = true },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        keys = {
            { "<C-p>", ":Telescope find_files<Return>", silent = true },
            { "<C-o>", ":Telescope live_grep<Return>", silent = true },
        },
        tag = "0.1.1",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    path_desplay = { "smart" },
                    mappings = {
                        i = {
                            ["<esc>"] = "close",
                            ["<C-p>"] = "close",
                            ["<C-o>"] = "close",
                        },
                    },
                },
            })
            require("telescope").load_extension("lazygit")
        end,
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = { mode = "tabs" },
            })
        end,
    },
    {
        -- status bar
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "wombat" },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "filename", path = 1 } },
                    lualine_c = { "diagnostics" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "filetype" },
                },
            })
        end,
    },
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
                dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("r", "  Recently opened files", ":Telescope oldfiles <CR>"),
                dashboard.button("o", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.vim<CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
            }
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end,
    },
}
