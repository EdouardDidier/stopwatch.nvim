local M = {}

local timer
local start_time = -1
local pause_time = -1

local function format_time(time)
	local h = math.floor(time / 3600)
	time = time % 3600
	local m = math.floor(time / 60)
	time = time % 60
	local s = math.floor(time)

	return string.format("%02d:%02d:%02d", h, m, s)
end

local function stop_timer()
	timer:stop()
	timer:close()

	local elapsed = (vim.loop.hrtime() - start_time) / 1e9
	vim.defer_fn(function()
		require("stopwatch.ui").update(" " .. format_time(elapsed), "String")
	end, 100)

	timer = nil
end

M.trigger = function()
	if not timer then
		if start_time == -1 then
			start_time = vim.loop.hrtime()
		else
			start_time = start_time + vim.loop.hrtime() - pause_time
		end

		timer = vim.loop.new_timer()

		if timer then
			timer:start(
				0,
				100,
				vim.schedule_wrap(function()
					local elapsed = (vim.loop.hrtime() - start_time) / 1e9
					require("stopwatch.ui").update(" " .. format_time(elapsed), "Function")
				end)
			)
		end
	else
		pause_time = vim.loop.hrtime()
		stop_timer()
	end
end

M.reset = function()
	if timer then
		stop_timer()
	end

	vim.defer_fn(function()
		require("stopwatch.ui").update(" 00:00:00")
		start_time = -1
	end, 100)
end

return M
