return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
		})
	end,
}
