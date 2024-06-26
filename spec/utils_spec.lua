local utils = require("../lua/mindmap/utils")

describe("utils", function()
  describe("get_abs_path", function()
    it("converts relative path to absolute path", function()
      local result = utils.get_abs_path("../a/b", "/c/d")
      assert.are.equal("/c/a/b", result)
    end)
  end)

  describe("get_rel_path", function()
    it("converts absolute path to relative path", function()
      local result = utils.get_rel_path("/a/b/c", "/a/b/d")
      assert.are.equal("../c", result)
    end)
  end)
end)
