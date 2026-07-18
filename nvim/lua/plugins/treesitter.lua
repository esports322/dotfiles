return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", 
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "cpp", "c", "java", "lua", "make", "markdown", "json" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
