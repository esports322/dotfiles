local M = {}
local Terminal = require("toggleterm.terminal").Terminal

local function problem_dir()
	return vim.fn.expand("%:p:h") -- directory of current file
end

local function run_in_terminal(cmd)
	local term = Terminal:new({ cmd = cmd, direction = "horizontal", close_on_exit = false })
	term:toggle()
end

function M.compile_and_run()
	local ft = vim.bo.filetype
	local dir = problem_dir()
	local input = dir .. "/input.txt"

	if ft == "cpp" then
		local src = vim.fn.expand("%:p")
		local bin = dir .. "/main"
		local cmd = string.format("g++ -std=c++17 -O2 -Wall -o %s %s && %s < %s", bin, src, bin, input)
		run_in_terminal(cmd)
	elseif ft == "java" then
		local cmd = string.format("cd %s && javac Main.java && java Main < %s", dir, input)
		run_in_terminal(cmd)
	else
		vim.notify("cp.nvim: unsupported filetype " .. ft, vim.log.levels.WARN)
	end
end

return M
