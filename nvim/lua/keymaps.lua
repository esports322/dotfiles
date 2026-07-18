-- F5/F6/F7/F8 CP keymaps go here once the cp module exists (later step)
vim.keymap.set("n", "<F5>", function()
	require("cp").compile_and_run()
end, { desc = "Compile & run vs input.txt" })
