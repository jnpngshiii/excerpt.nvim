local class_database = require("excerpt.class_database")
local class_log = require("excerpt.class_log")
local misc = require("excerpt.misc")

local M = {}

--------------------
-- Class ExcerptItem
--------------------

---@class ExcerptItem:Item
---@field proj_name string Name of the project where the excerpt is from.
---@field path_to_root string Relative path to the project root of the file where the excerpt is from.
---@field file_name string Name of the file where the excerpt is from.
---@field start_row number Start row of the excerpt.
---@field start_col number Start column of the excerpt.
---@field end_row number End row of the excerpt.
---@field end_col number End column of the excerpt.
---@field context string[] Context list per line of the excerpt.
M.ExcerptItem = class_database.Item:new({
	proj_name = "",
	path_to_root = "",
	file_name = "",
	start_row = -1,
	start_col = -1,
	end_row = -1,
	end_col = -1,
	context = "",
})

----------
-- Class Method
----------

--- Create a new ExcerptItem using the latest visual selection.
---@return ExcerptItem
function M.ExcerptItem.create_using_latest_visual_selection()
	local file_path = vim.api.nvim_buf_get_name(0)
	local proj_root = misc.get_current_proj_path()

	local timestamp = "excerpt" .. os.time()
	local proj_name = misc.split_path(proj_root)[#misc.split_path(proj_root)]
	local path_to_root = misc.get_rel_path(file_path, proj_root)
	local file_name = misc.get_current_file_name()
	local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
	local start_col = vim.api.nvim_buf_get_mark(0, "<")[2]
	local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
	local end_col = vim.api.nvim_buf_get_mark(0, ">")[2]
	local context = misc.get_context(file_path, start_row, start_col, end_row, end_col)

	return M.ExcerptItem:new({
		timestamp = timestamp,
		proj_name = proj_name,
		path_to_root = path_to_root,
		file_name = file_name,
		start_row = start_row,
		start_col = start_col,
		end_row = end_row,
		end_col = end_col,
		context = context,
	})
end

--- Save an ExcerptItem to a table.
--- Only save string, number, and boolean type fields.
---@param excerpt ExcerptItem
---@return table
function M.ExcerptItem.to_table(excerpt)
	-- Do not check health here.
	return misc.remove_table_field(excerpt)
end

--- Create an ExcerptIte from a table.
---@param tbl table
---@return ExcerptItem
function M.ExcerptItem.from_table(tbl)
	-- Do not check health here.
	-- TODO: Check if tbl is a table.
	-- TODO: Check health?
	return M.ExcerptItem:new(tbl)
end

----------
-- Instance Method
----------

--- Check health of an ExcerptItem.
---@return boolean
function M.ExcerptItem:check_health()
	if
		self.proj_name == ""
		or self.path_to_root == ""
		or self.file_name == ""
		or self.start_row == -1
		or self.start_col == -1
		or self.end_row == -1
		or self.end_col == -1
		or self.context == ""
	then
		return false
	else
		return true
	end
end

function M.ExcerptItem:show_in_nvim_out_write()
	local info = ""
	info = info .. "===== ExcerptItem Start =====" .. "\n"
	info = info .. "timestamp: " .. self.timestamp .. "\n"
	info = info .. "proj_name: " .. self.proj_name .. "\n"
	info = info .. "path_to_root: " .. self.path_to_root .. "\n"
	info = info .. "file_name: " .. self.file_name .. "\n"
	info = info .. "start_row: " .. self.start_row .. "\n"
	info = info .. "start_col: " .. self.start_col .. "\n"
	info = info .. "end_row: " .. self.end_row .. "\n"
	info = info .. "end_col: " .. self.end_col .. "\n"
	info = info .. "context:\n" .. table.concat(self.context, "\n") .. "\n"
	info = info .. "===== ExcerptItem End =====" .. "\n"
	vim.api.nvim_out_write(info)
end

--------------------
-- Class ExcerptDatabase
--------------------

---@class ExcerptDatabase:Database
---@field cache ExcerptItem[]
---@field json_path string Path to the JSON file used to store the database.
---@field logger any Logger of the database. NOTE: Logger should have a method log(msg, msg_level).
M.ExcerptDatabase = class_database.Database:init({
	cache = {},
	json_path = "",
	logger = nil,
})

function M.ExcerptDatabase:init(obj)
	obj = obj or {}
	obj.cache = obj.cache or self.cache
	obj.json_path = obj.json_path or self.json_path
	obj.logger = obj.logger or self.logger
	if obj.logger then
		obj.logger:log("[Logger] Init logger.", "info")
	end

	setmetatable(obj, self)
	self.__index = self

	-- self:load()

	return obj
end

----------
-- Class Method
----------

----------
-- Instance Method
----------

--- Save the database to a JSON file.
---@return nil
function M.ExcerptDatabase:save()
	local json_context = {}
	for _, excerpt in pairs(self.cache) do
		if excerpt:check_health() then
			json_context[#json_context + 1] = excerpt.to_table(excerpt)
		end
	end
	json_context = vim.fn.json_encode(json_context)

	local json, err = io.open(self.json_path, "w")
	if not json then -- TODO:
		self:log("[Database] Could not save database at: " .. self.json_path, "error")
		error("Could not open file: " .. err)
	end

	json:write(json_context)
	json:close()
end

--- Load the database from a JSON file.
---@return nil
function M.ExcerptDatabase:load()
	local json_context = {}
	local json, _ = io.open(self.json_path, "r")
	if not json then
		-- Use save() to create a json file.
		self:save()
		self:log("[Database] Database not found at: " .. self.json_path .. ". Created a new one.", "info")
		return
	end
	json_context = vim.fn.json_decode(json:read("*a"))

	for _, table in pairs(json_context) do
		if type(table) == "table" then
			local excerpt = M.ExcerptItem.from_table(table)
			self.cache[excerpt.timestamp] = excerpt
		end
	end

	self:log("[Database] Database loaded at: " .. self.json_path, "info")
	json:close()
end

--- Call log method of the logger, or call fallback method.
---@param msg string Log message.
---@param msg_level string Log message level.
---@return nil
function M.ExcerptDatabase:log(msg, msg_level)
	if self.logger then
		self.logger:log(msg, msg_level) -- Use __call?
	else
		local formatted_timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
		msg = formatted_timestamp .. " " .. string.upper(msg_level) .. " " .. msg .. "\n"
		if package.loaded["vim.api"] then
			vim.api.nvim_out_write(msg)
		else
			print(msg)
		end
	end
end

--------------------

return M