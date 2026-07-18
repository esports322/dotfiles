local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Updated vim.loop to vim.uv for modern Neovim versions
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Ensure these files live inside your ~/dotfiles/nvim/lua/ directory!
require("options")
require("keymaps")

-- Looks for plugin specs inside ~/dotfiles/nvim/lua/plugins/
require("lazy").setup("plugins")
