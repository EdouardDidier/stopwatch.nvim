---@class stopwatch
local stopwatch = {}

function stopwatch.setup(opts)
	opts = opts or {}

	vim.api.nvim_create_user_command("Stopwatch", function()
		print("Hello Word from stopwatch.nvim")
	end, {})
end

return stopwatch
