return {
    {
        -- nvim-cmp
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            "hrsh7th/vim-vsnip-integ",
            "Exafunction/windsurf.nvim",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "buffer" },
                    { name = "codeium" },
                }),
            })
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                }),
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
