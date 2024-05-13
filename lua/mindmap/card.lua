local misc = require("mindmap.misc")

local M = {}

--------------------
-- Class Card
--------------------

---@class Card
---@field type string Type of the card.
---@field created_at string Time when the card was created.
---@field updated_at string Time when the card was last updated.
---@field due_at string Time when the card is due.
---@field ease number Ease of the card.
---@field interval number Interval of the card.
M.Card = {
	type = "",
	created_at = "",
	updated_at = "",
	due_at = "",
	ease = 0,
	interval = 0,
}

----------
-- Instance Method
----------

---@param obj table?
---@return table
function M.Card:new(obj)
	obj = obj or {}
	obj.type = obj.type or self.type
	obj.created_at = obj.created_at or self.created_at
	obj.updated_at = obj.updated_at or self.updated_at
	obj.due_at = obj.due_at or self.due_at
	obj.ease = obj.ease or self.ease
	obj.interval = obj.interval or self.interval

	setmetatable(obj, self)
	self.__index = self

	return obj
end

---Check health of an Card.
---@return boolean
function M.Card:check_health()
	if
		self.type == ""
		or self.created_at == ""
		or self.updated_at == ""
		or self.due_at == ""
		or self.ease == 0
		or self.interval == 0
	then
		return false
	else
		return true
	end
end

---Show info of an Card in nvim_out_write.
---@return nil
function M.Card:show_in_nvim_out_write()
	local info = ""
	info = info .. "===== Card Start =====" .. "\n"
	info = info .. "Type: " .. self.type .. "\n"
	info = info .. "Created At: " .. self.created_at .. "\n"
	info = info .. "Updated At: " .. self.updated_at .. "\n"
	info = info .. "Due At: " .. self.due_at .. "\n"
	info = info .. "Ease: " .. self.ease .. "\n"
	info = info .. "Interval: " .. self.interval .. "\n"
	info = info .. "=====  Card End  =====" .. "\n"
	vim.api.nvim_out_write(info)
end

----------
-- Class Method
----------

--------------------

return M