local WIN_TITLE = " Stopwatch "

local WIN_WIDTH = 16
local WIN_HEIGHT = 3

local WIN_COL_OFFSET = 3
local WIN_ROW_OFFSET = 2

local TEXT_COL_OFFSET = 3
local TEXT_ROW_OFFSET = 1

local timer_state = {
	play = {
		icon = "",
		hl_group = "Function",
	},
	pause = {
		icon = "",
		hl_group = "String",
	},
	stop = {
		icon = "",
		hl_group = "Normal",
	},
}

local M = {}

local buf
local opts = {}
local win
local is_toggled = false

local function format_time(time)
	local h = math.floor(time / 3600)
	time = time % 3600
	local m = math.floor(time / 60)
	time = time % 60
	local s = math.floor(time)

	return string.format("%02d:%02d:%02d", h, m, s)
end

M.setup = function()
	opts = {
		title = WIN_TITLE,
		width = WIN_WIDTH,
		height = WIN_HEIGHT,
		row = WIN_ROW_OFFSET,
		col = vim.api.nvim_list_uis()[1].width - WIN_WIDTH - WIN_COL_OFFSET,
		style = "minimal",
		relative = "editor",
		border = "rounded",
		title_pos = "center",
		focusable = false,
	}

	buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "                ", "                ", "                " })
	M.update(0, "stop")
end

M.open = function()
	if not is_toggled then
		if not buf then
			M.setup()
		end

		win = vim.api.nvim_open_win(buf, false, opts)

		is_toggled = true
	end
end

M.close = function()
	if is_toggled then
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
			win = nil
		end

		is_toggled = false
	end
end

M.toggle = function()
	if not is_toggled then
		M.open()
	else
		M.close()
	end
end

local ns = vim.api.nvim_create_namespace("stopwatch")

M.update = function(elapsed, state)
	state = timer_state[state]

	if not state then
		state = timer_state["stop"]
		vim.notify("Invalid timer state, defaulting to 'stop'", vim.log.levels.WARN)
	end

	if not buf then
		return
	end

	local text = state.icon .. " " .. format_time(elapsed)

	vim.bo[buf].modifiable = true

	vim.api.nvim_buf_set_text(buf, TEXT_ROW_OFFSET, TEXT_COL_OFFSET, -1, -1, { "" })
	vim.api.nvim_buf_set_text(buf, TEXT_ROW_OFFSET, TEXT_COL_OFFSET, -1, -1, { text })
	vim.api.nvim_buf_set_extmark(buf, ns, TEXT_ROW_OFFSET, TEXT_COL_OFFSET, {
		end_col = TEXT_COL_OFFSET + #text,
		hl_group = state.hl_group,
	})

	vim.bo[buf].modifiable = false
end

return M
