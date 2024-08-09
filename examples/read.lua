local Logger = require("logger")
local inspect = require("inspect") --https://github.com/kikito/inspect.lua

local luaTable = Logger:read("myLog.log")
print(inspect(luaTable)) -- You can convert log files to log_Object like this.


