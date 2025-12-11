local M = {}

local buf
local opts = {}
local win
local is_toggled = false

M.setup = function()
	buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "                ", "                ", "                " })
	vim.api.nvim_buf_set_text(buf, 1, 3, -1, -1, { " 00:00:00" })

	-- vim.bo[buf].readonly = true
	vim.bo[buf].modifiable = false

	local width = 16
	local height = 3

	local ui = vim.api.nvim_list_uis()[1]
	local row = 2
	local col = ui.width - width - 3

	opts = {
		style = "minimal",
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		title = " Stopwatch ",
		title_pos = "center",
		focusable = false,
	}
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
		if win then
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

M.update = function(text, hl_group)
	hl_group = hl_group or "Normal"

	if not buf then
		return
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_text(buf, 1, 3, -1, -1, { "" })
	vim.api.nvim_buf_set_text(buf, 1, 3, -1, -1, { text })
	vim.api.nvim_buf_set_extmark(buf, ns, 1, 3, {
		end_col = 3 + #text,
		hl_group = hl_group,
	})
	vim.bo[buf].modifiable = false
end

return M
