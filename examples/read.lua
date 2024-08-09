local Logger = require("logger")
local inspect = require("inspect") --https://github.com/kikito/inspect.lua

local luaTable = Logger:read("myLog.log")
print(inspect(luaTable)) -- You can read log files (log_Object.logs) in lua table like this.
