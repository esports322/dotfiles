local lspconfig = require("lspconfig")

-- Diagnostic: show inline + populate the quickfix-style list
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

-- Jump to next/prev diagnostic (compiler error)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})

local on_attach = function(_, bufnr)
    local map = function(keys, fn) vim.keymap.set("n", keys, fn, { buffer = bufnr }) end
    map("gd", vim.lsp.buf.definition)
    map("K", vim.lsp.buf.hover)
    map("<leader>rn", vim.lsp.buf.rename)
    map("<leader>ca", vim.lsp.buf.code_action)
end

lspconfig.clangd.setup({ on_attach = on_attach })
lspconfig.jdtls.setup({ on_attach = on_attach })

