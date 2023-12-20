return {
    {
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
                hijack_netrw_behavior = "open_current",
                follow_current_file = { enabled = true },
            },
            window = { mappings = { ["<space>"] = "none", ["l"] = "none", ["q"] = "none" } },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        require("neo-tree").close_all()
                    end,
                },
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        keys = {
            { "<C-p>", ":Telescope find_files<Return>", silent = true },
            { "<C-o>", ":Telescope live_grep<Return>", silent = true },
        },
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
