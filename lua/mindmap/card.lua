local prototype = require("mindmap.prototype")
local misc = require("mindmap.misc")

local M = {}

--------------------
-- Class Card
--------------------

---@class Card : SimpleItem
---@field due_at integer Due time of the card.
---@field ease integer Ease of the card.
---@field interval integer Interval of the card.
M.Card = prototype.SimpleItem:new()

----------
-- Instance Method
----------

---@param tbl table?
---@return table
function M.Card:new(tbl, sub_item_class, load)
	tbl = tbl or {}
	tbl.type = "crd"
	tbl = prototype.SimpleItem:new(tbl, sub_item_class, load)

	tbl.created_at = tbl.created_at or tonumber(os.time())
	tbl.updated_at = tbl.updated_at or tonumber(os.time())
	tbl.due_at = tbl.due_at or 0
	tbl.ease = tbl.ease or 250
	tbl.interval = tbl.interval or 1 -- TODO: Needs investigation.

	setmetatable(tbl, self)
	self.__index = self

	return tbl
end

function M.Card.ttt()
	print("Hello")
end

----------
-- Class Method
----------

if true then
	local a = M.Card:new({
		id = "0000",
		created_at = 1,
	}, M.Card, true)
	-- print("a.id: " .. a.id)
	-- print("a.type: " .. a.type)
	-- print("a.created_at: " .. a.created_at)
	-- print("a.updated_at: " .. a.updated_at)
	-- print("a.save_path: " .. a.save_path)

	a:ttt()

	local b = M.Card:new({
		created_at = 2,
	})
	a:add(b)

	local c = M.Card:new({
		created_at = 3,
	})
	b:add(c)

	a:save()
end

--------------------

return M
