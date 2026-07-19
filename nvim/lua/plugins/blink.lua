return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*", -- Use a release tag to download pre-built binaries

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for everyday users, 'super-tab' for those who love tab completion
			keymap = { preset = "default" },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			-- Default sources to enable
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
}
