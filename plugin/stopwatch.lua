-- Define the commands
local commands = {
	trigger = function()
		require("stopwatch").trigger()
	end,
	reset = function()
		require("stopwatch").reset()
	end,
	toggle = function()
		require("stopwatch").toggle()
	end,
}

-- Register the user command
vim.api.nvim_create_user_command("Stopwatch", function(opts)
	local sub = opts.fargs[1]
	local handler = commands[sub]
	if handler then
		handler()
	else
		vim.notify("Invalid sub-command", vim.log.levels.ERROR)
	end
end, {
	nargs = 1,
	complete = function()
		return vim.tbl_keys(commands)
	end,
})
