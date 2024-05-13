local card = require("mindmap.card")
local excerpt = require("mindmap.excerpt")

---@alias card.Card Card
---@alias excerpt.Excerpt Excerpt

local M = {}

--------------------
-- Class Mindnode
--------------------

---@class Mindnode
---@field mindnode_id string ID of the mindnode. Example: "mnode-01234567890-0123".
---@field excerpt_tbl table<string, Excerpt> Excerpts in the mindnode.
---@field card_tbl table<string, Card> Cards in the mindnode.
M.Mindnode = {
	mindnode_id = "",
	excerpt_tbl = {},
	card_tbl = {},
}

----------
-- Instance Method
----------

---@param obj table?
---@return table
function M.Mindnode:new(obj)
	obj = obj or {}
	obj.mindnode_id = obj.mindnode_id or self.mindnode_id
	obj.excerpt_tbl = obj.excerpt_tbl or self.excerpt_tbl
	obj.card_tbl = obj.card_tbl or self.card_tbl

	setmetatable(obj, self)
	self.__index = self

	return obj
end

----------
-- Class Method
----------

--------------------

return M
