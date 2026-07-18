-- F5/F6/F7/F8 CP keymaps go here once the cp module exists (later step)
vim.keymap.set("n", "<F5>", function()
	require("cp").compile_and_run()
end, { desc = "Compile & run vs input.txt" })

vim.keymap.set("n", "<F6>", function()
	require("cp").run_tests()
end, { desc = "Run all sample tests" })

vim.keymap.set("n", "<F7>", function()
  vim.cmd("edit " .. vim.fn.expand("%:p:h") .. "/input.txt")
end, { desc = "Open input.txt" })

vim.keymap.set("n", "<F8>", function()
  vim.cmd("edit /tmp/cpnew_out.txt")
end, { desc = "Open last output" })
