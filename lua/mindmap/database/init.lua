local Graph = require("mindmap.database.graph")

local prototype = require("mindmap.database.prototype")
local PrototypeNode = prototype.node
local PrototypeEdge = prototype.edge

local sub_class = require("mindmap.database.sub_class")
local sub_node_cls = sub_class.node
local sub_edge_cls = sub_class.edge

---@alias path string

---@class Database
---@field cache table<path, Graph> Cache of graphs in different repos.
local Database = {}

function Database:new()
	local database = {
		cache = {},
	}

	setmetatable(database, self)
	self.__index = self

	return database
end

---Add a graph to the database.
---@param graph Graph Graph to be added.
---@return nil _ This function does not return anything.
function Database:add_graph(graph)
	self.cache[graph.save_path] = graph
end

---Find a graph in the database using path.
---If not found, add a new graph to the database.
---@param save_path string Path to load and save the graph.
---@param log_level? string Logger log level of the graph.
---@param show_log_in_nvim? boolean Show log in Neovim when added.
---@return Graph graph Found or created graph.
function Database:find_graph(save_path, log_level, show_log_in_nvim)
	if not self.cache[save_path] then
		local created_graph = Graph:new(
			save_path,
			--
			log_level,
			show_log_in_nvim,
			--
			PrototypeNode,
			PrototypeEdge,
			sub_node_cls,
			sub_edge_cls
		)
		self:add_graph(created_graph)
	end

	return self.cache[save_path]
end

return Database
