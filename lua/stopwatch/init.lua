local M = {}

M.trigger = function()
	require("stopwatch.ui").open()
	require("stopwatch.timer").trigger()
end

M.reset = function()
	require("stopwatch.ui").open()
	require("stopwatch.timer").reset()
end

M.toggle = function()
	require("stopwatch.ui").toggle()
end

return M
