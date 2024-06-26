-- Factory:
local NodeFactory = require("mindmap.factory.NodeFactory")
local EdgeFactory = require("mindmap.factory.EdgeFactory")
local AlgFactory = require("mindmap.factory.AlgFactory")
-- Node:
local BaseNode = require("mindmap.node.BaseNode")
-- local SimpleNode = require("mindmap.node.SimpleNode")
-- local HeadingNode = require("mindmap.node.HeadingNode")
-- local ExcerptNode = require("mindmap.node.ExcerptNode")
-- Edge:
local BaseEdge = require("mindmap.edge.BaseEdge")
-- local SimpleEdge = require("mindmap.edge.SimpleEdge")
-- local SelfLoopContentEdge = require("mindmap.edge.SelfLoopContentEdge")
-- local SelfLoopSubheadingEdge = require("mindmap.edge.SelfLoopSubheadingEdge")
-- Alg:
local BaseAlg = require("mindmap.alg.BaseAlg")
-- local AnkiAlg = require("mindmap.alg.AnkiAlg")
-- local SimpleAlg = require("mindmap.alg.SimpleAlg")
-- local SM2Alg = require("mindmap.alg.SM2Alg")
-- Logger:
-- local Logger = require("mindmap.graph.Logger")
-- Graph:
-- local Graph = require("mindmap.graph.Graph")
-- Utils:
-- local utils = require("mindmap.utils")
-- local ts_utils = require("mindmap.ts_utils")

local plugin_data = {}

--------------------
-- Class plugin_data.config
--------------------

---@class plugin_data.config
---Node:
---@field base_node BaseNode Base node class.
---@field node_factory NodeFactory Factory of the node.
---Edge:
---@field base_edge BaseEdge Base edge class.
---@field edge_factory EdgeFactory Factory of the edge.
---Alg:
---@field base_alg BaseAlg Base algorithm class.
---@field alg_factory AlgFactory Factory of the algorithm.
---@field alg_type string Type of the algorithm. Default: `"SimpleAlg"`.
---Logger:
---@field log_level string Log level of the graph. Default: `"INFO"`.
---@field show_log_in_nvim boolean Show log in Neovim. Default: `true`.
---Behavior configuration:
---  Default behavior:
---@field enable_default_keymap boolean Enable default keymap. Default: `true`.
---@field keymap_prefix string Prefix of the keymap. Default: `"<localleader>m"`.
---@field enable_shorten_keymap boolean Enable shorten keymap. Default: `false`.
---@field shorten_keymap_prefix string Prefix of the shorten keymap. Default: `"m"`.
---@field enable_default_autocmd boolean Enable default autocmd. Default: `true`.
---@field undo_redo_limit integer Maximum number of undo and redo operations. Default: `3`.
---@field thread_num integer Number of threads to use. Default: `3`.
---  Automatic behavior:
---@field show_excerpt_after_add boolean Show excerpt after adding a node.
---@field show_excerpt_after_bfread boolean Show excerpt after reading a buffer.
plugin_data.config = {
	-- Node:
	base_node = BaseNode,
	node_factory = NodeFactory,
	-- Edge:
	base_edge = BaseEdge,
	edge_factory = EdgeFactory,
	-- Alg:
	base_alg = BaseAlg,
	alg_factory = AlgFactory,
	alg_type = "SimpleAlg",
	-- Logger:
	log_level = "INFO",
	show_log_in_nvim = true,
	-- Behavior configuration:
	--   Default behavior:
	enable_default_keymap = true,
	keymap_prefix = "<localleader>m",
	enable_shorten_keymap = false,
	shorten_keymap_prefix = "m",
	enable_default_autocmd = true,
	--   Automatic behavior:
	show_excerpt_after_add = true,
	show_excerpt_after_bfread = true,
}

--------------------
-- Class plugin_data.cache
--------------------

---@class plugin_data.cache
---@field graphs table<string, Graph> Graphs of different repos.
---@field namespaces table<string, integer> Namespaces of different virtual texts.
plugin_data.cache = {
	graphs = {},
	namespaces = {},
}

--------------------

return plugin_data
