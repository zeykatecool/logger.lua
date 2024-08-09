local Logger = {}
Logger.__index = Logger

Logger.levels = {
    ["DEBUG"] = 0,
    ["INFO"] = 1,
    ["NOTICE"] = 2,
    ["WARNING"] = 3,
    ["ERROR"] = 4,
    ["CRITICAL"] = 5,
    ["FATAL"] = 6,
}

local levels = {
    [0] = "DEBUG",
    [1] = "INFO",
    [2] = "NOTICE",
    [3] = "WARNING",
    [4] = "ERROR",
    [5] = "CRITICAL",
    [6] = "FATAL",
}
function Logger:newLogger(file)
        local log_Object = {
        type = "log_Object",
        logs = {},
        file = file,
    }
    function log_Object:log(message, description, level)
        return Logger:log(log_Object, message, description, level)
    end
    setmetatable(log_Object, Logger)
    return log_Object
end

function Logger:log(log_Object, message, description, level)
    if log_Object.type ~= "log_Object" then
        print("Logger: expected log_Object, got " .. type(log_Object))
        return
    end
    level = level or 0
    message = message or ""
    description = description or ""
    table.insert(log_Object.logs, {
        level = level,
        message = message,
        description = description,
        time = os.time()
    })
    coroutine.wrap(function()
    local file = io.open(log_Object.file, "a")
    if file then
        file:write(string.format(
            "[%s] [%s] %s\n",
            os.date("%Y-%m-%d %H:%M:%S"),
            levels[level],
            message
        ))
        if description ~= "" then
            file:write("└──" .. description .. "\n")
        end
        file:close()
        return log_Object
    else
        return false
    end
    end)()
end

function Logger:read(file)
    local lua_table = {}
    local f = io.open(file, "r")
    if not f then
        return nil
    end
    local line_pattern = "%[(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d)%] %[(%w+)%] (.+)"
    local desc_pattern = "└──(.+)"
    local current_log = nil

    for line in f:lines() do
        local timestamp, level, message = line:match(line_pattern)
        if timestamp and level and message then
            level = level:lower()
            if not Logger.levels[level] then
                level = "debug"
            end
            if current_log then
                table.insert(lua_table, current_log)
                current_log = nil
            end
            current_log = {
                time = timestamp,
                level = Logger.levels[level],
                message = message,
                description = ""
            }
        elseif line:match("^└──") then
            local description = line:match(desc_pattern)
            if current_log then
                current_log.description = description or ""
            end
        end
    end
    if current_log then
        table.insert(lua_table, current_log)
    end
    f:close()
    return lua_table
end

function Logger:print(log_Object)
    for i = 1, #log_Object.logs do
        local log = log_Object.logs[i]
        print(string.format(
            "[%s] [%s] %s",
            os.date("%Y-%m-%d %H:%M:%S", log.time),
            levels[log.level],
            log.message
        ))
        if log.description ~= "" then
            print("---" .. log.description .. "\n")
        end
    end
end

function Logger:filterLevel(log_Object, level)
    local filtered = {}
    for i = #log_Object.logs, 1, -1 do
        local log = log_Object.logs[i]
        if log.level >= level then
            table.insert(filtered, log)
        end
    end
    return filtered
end

function Logger:write(log_Object)
    local file = io.open(log_Object.file, "w")
    if file then
        for i = 1, #log_Object.logs do
            local log = log_Object.logs[i]
            file:write(string.format(
                "[%s] [%s] %s\n",
                os.date("%Y-%m-%d %H:%M:%S", log.time),
                levels[log.level],
                log.message
            ))
            if log.description ~= "" then
                file:write("└──" .. log.description .. "\n")
            end
        end
        file:close()
        return log_Object
    else
        return false
    end
end

return Logger
