return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies for icons
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup({
				default_file_explorer = true, -- Replaces netrw
				view_options = {
					show_hidden = true, -- Show dotfiles by default
				},
			})

			-- Quick keymap to open Oil in the current directory
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
		end,
	},
}
