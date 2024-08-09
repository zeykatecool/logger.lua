local Logger = require("logger")

local myLog = Logger:newLogger("myLog.log")
Logger:log(myLog, "This is Message Of Log", "This is a Description Of Log", Logger.levels.DEBUG)
myLog:log("This is Message Of Log", "This is a Description Of Log", Logger.levels.DEBUG)
