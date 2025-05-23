return {
    {
        -- file explorer
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        keys = {
            { "<C-b>", ":Neotree<Return>", silent = true },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                hijack_netrw_behavior = "open_current",
            },
            window = { mappings = { ["<space>"] = "none", ["l"] = "none", ["q"] = "none" } },
        },
    },
    {
        -- status bar
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "wombat", globalstatus = true },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "filename", path = 3 } },
                    lualine_c = { "diagnostics" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "filetype" },
                },
            })
        end,
    },
    {
        -- start screen
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
                dashboard.button("n", "  New file", ":ene <BAR> startinsert <Return>"),
                dashboard.button("o", "  Find text", ":Telescope live_grep <Return>"),
                dashboard.button("f", "  Find file", ":Telescope find_files <Return>"),
                dashboard.button("r", "  Recent file", ":Telescope oldfiles <Return>"),
                dashboard.button("p", "󰂖  Plugins", ":Lazy<Return>"),
                dashboard.button("s", "  Settings", ":Neotree position=current ~/.config/nvim<Return>"),
                dashboard.button("q", "󰅚  Quit", ":qa<Return>"),
            }
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end,
    },
}
