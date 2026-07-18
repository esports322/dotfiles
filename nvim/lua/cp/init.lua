local M = {}
local Terminal = require("toggleterm.terminal").Terminal

local function problem_dir()
	return vim.fn.expand("%:p:h") -- directory of current file
end

local function run_in_terminal(cmd)
	local term = Terminal:new({ cmd = cmd, direction = "horizontal", close_on_exit = false })
	term:toggle()
end

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function list_tests(dir)
	local ins = vim.fn.globpath(dir .. "/tests", "*.in", false, true)
	local tests = {}
	for _, f in ipairs(ins) do
		local n = f:match("(%d+)%.in$")
		local out = dir .. "/tests/" .. n .. ".out"
		if n and vim.fn.filereadable(out) == 1 then
			table.insert(tests, { n = tonumber(n), input = f, expected = out })
		end
	end
	table.sort(tests, function(a, b)
		return a.n < b.n
	end)
	return tests
end

local function run_one(run_cmd, test)
	local timefile = "/tmp/cpnew_time.txt"
	local outfile = "/tmp/cpnew_out.txt"
	local full_cmd = string.format(
		"/usr/bin/time -f '%%e %%M' -o %s %s < %s > %s 2>/dev/null",
		timefile,
		run_cmd,
		test.input,
		outfile
	)
	vim.fn.system(full_cmd)
	local got = trim(table.concat(vim.fn.readfile(outfile), "\n"))
	local expected = trim(table.concat(vim.fn.readfile(test.expected), "\n"))
	local time_s, mem_kb = "?", "?"
	local tf = vim.fn.readfile(timefile)
	if tf[1] then
		time_s, mem_kb = tf[1]:match("([%d%.]+) (%d+)")
	end
	return {
		n = test.n,
		passed = (got == expected),
		got = got,
		expected = expected,
		time_s = time_s,
		mem_kb = mem_kb,
	}
end

local function render_results(results)
	local lines = { "Running tests...", "" }
	for _, r in ipairs(results) do
		local mark = r.passed and "✔" or "✗"
		table.insert(lines, string.format("%s Test %d (%.3fs, %s KB)", mark, r.n, tonumber(r.time_s) or 0, r.mem_kb))
		if not r.passed then
			table.insert(lines, "  Expected: " .. r.expected:gsub("\n", " | "))
			table.insert(lines, "  Got:      " .. r.got:gsub("\n", " | "))
		end
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	local width = math.min(80, vim.o.columns - 4)
	local height = math.min(#lines + 2, vim.o.lines - 4)
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		style = "minimal",
		border = "rounded",
		width = width,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
	})
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
end

-- Returns the binary path on success, or nil + error output on failure
local function compile(dir)
	local ft = vim.bo.filetype
	if ft == "cpp" then
		local src = vim.fn.expand("%:p")
		local bin = dir .. "/main"
		local result = vim.fn.system(string.format("g++ -std=c++17 -O2 -Wall -o %s %s 2>&1", bin, src))
		if vim.v.shell_error ~= 0 then
			return nil, result
		end
		return bin, nil
	elseif ft == "java" then
		local result = vim.fn.system(string.format("cd %s && javac Main.java 2>&1", dir))
		if vim.v.shell_error ~= 0 then
			return nil, result
		end
		return "java -cp " .. dir .. " Main", nil
	end
	return nil, "unsupported filetype: " .. ft
end

function M.run_tests()
	local dir = problem_dir()
	local bin_or_cmd, err = compile(dir)
	if not bin_or_cmd then
		vim.notify("Compile failed:\n" .. err, vim.log.levels.ERROR)
		return
	end
	local tests = list_tests(dir)
	if #tests == 0 then
		vim.notify("No tests found in tests/", vim.log.levels.WARN)
		return
	end
	local run_cmd = vim.bo.filetype == "cpp" and bin_or_cmd or bin_or_cmd
	local results = {}
	for _, t in ipairs(tests) do
		table.insert(results, run_one(run_cmd, t))
	end
	render_results(results)
end

function M.compile_and_run()
	local dir = problem_dir()
	local input = dir .. "/input.txt"
	local ft = vim.bo.filetype
	if ft == "cpp" then
		local src = vim.fn.expand("%:p")
		local bin = dir .. "/main"
		run_in_terminal(string.format("g++ -std=c++17 -O2 -Wall -o %s %s && %s < %s", bin, src, bin, input))
	elseif ft == "java" then
		run_in_terminal(string.format("cd %s && javac Main.java && java Main < %s", dir, input))
	else
		vim.notify("cp.nvim: unsupported filetype " .. ft, vim.log.levels.WARN)
	end
end

return M
