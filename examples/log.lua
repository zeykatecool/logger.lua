local Logger = require("logger")

local myLog = Logger:newLogger("myLog.log") -- It will load data from myLog.log if file exist.If file does not exist,it will create a new one.
Logger:log(myLog, "This is Message Of Log", "This is a Description Of Log", Logger.levels.DEBUG) 
myLog:log("This is Message Of Log", "This is a Description Of Log", Logger.levels.DEBUG)
--There is 7 levels:
--[[
Logger.levels = {
    ["DEBUG"] = 0,
    ["INFO"] = 1,
    ["NOTICE"] = 2,
    ["WARNING"] = 3,
    ["ERROR"] = 4,
    ["CRITICAL"] = 5,
    ["FATAL"] = 6,
}
]]--
