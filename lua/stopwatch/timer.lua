local UPDATE_INTERVAL = 100

local M = {}

local timer
local start_time = -1
local pause_time = -1

local function stop_timer(state)
	state = state or "pause"

	if timer then
		timer:stop()
		timer:close()
	end

	local elapsed = 0
	if state == "pause" then
		elapsed = (vim.loop.hrtime() - start_time) / 1e9
	end

	vim.defer_fn(function()
		require("stopwatch.ui").update(elapsed, state)

		if state == "stop" then
			start_time = -1
		end
	end, UPDATE_INTERVAL)

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
				UPDATE_INTERVAL,
				vim.schedule_wrap(function()
					local elapsed = (vim.loop.hrtime() - start_time) / 1e9
					require("stopwatch.ui").update(elapsed, "play")
				end)
			)
		end
	else
		pause_time = vim.loop.hrtime()
		stop_timer()
	end
end

M.reset = function()
	stop_timer("stop")
end

return M
