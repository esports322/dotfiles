return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                cpp = { "clang-format" },
                c = { "clang-format" },
                java = { "google-java-format" },
                lua = { "stylua" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
