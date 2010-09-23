package = "LuaMatrix"
version = "[VERSION]"
source = {
   url = "[URL]",
}
description = {
   summary    = "Matrices and matrix operations implemented in pure Lua.",
   detailed   = [[
      This supports operations on matrices and vectors whose elements are
      real, complex, or symbolic.  Implemented entirely in Lua as tables.
      Includes a complex number data type too.
   ]],
   license    =  "MIT/X11",
   homepage   = "http://luamatrix.luaforge.net/",
   maintainer = "David Manura <http://lua-users.org/wiki/DavidManura>",
}
dependencies = {
   "lua >= 5.1",
}
build = {
   type = "none",
   install = {
      lua = {
         ["complex"] = "lua/complex.lua",
         ["matrix"]  = "lua/matrix.lua",
      }
   },
   copy_directories = {"doc", "samples", "tests"},
}
-- test: tests/test.lua

