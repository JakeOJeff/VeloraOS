local console = require 'src.console'

local commands = {
    __exec = function(args)
        local output = table.concat(args, " ")

        if output ~= "" then
            console:print("Unknown Command " .. "'" .. output .. "'")
        end
    end

}

commands["get"] = {
    ["version"] = function()
        return "1.0"
    end,
    ["system"] = {
        ["version"] = function()
            return "1.0.0"
        end,
        ["sysTime"] = function()
            return sysTime
        end,
        ["os"] = function()
            return osName
        end,
        ["cores"] = function()
            return cores
        end,
        ["lua"] = function()
            return luaVer
        end,
        ["luajit"] = function()
            return jitVer
        end,
        ["dpi"] = function()
            return dpi
        end,
        ["memory"] = function()
            return mem
        end,
        ["uptime"] = function()
            return uptime
        end,
        ["joysticks"] = function()
            return jsCount
        end,
        ["graphics"] = {
            ["renderer"] = function()
                return renderer
            end,
            ["vendor"] = function()
                return vendor
            end,
            ["version"] = function()
                return version
            end
        }

    }
}

commands["set"] = {
    ["fullscreen"] = function()
        love.window.setFullscreen(true)
        console:print("Set Fullscreen Successfully")
    end,
    ["desktop"] = function()
        love.window.setFullscreen(false)
        console:print("Set Desktop Successfully")
    end
}

commands["echo"] = {
    __exec = function(args)
        local output = table.concat(args, " ")
        console:print(output)
    end
}

commands["clear"] = function()
    console.currentLine = 0
    console.lines = {}
    console.cursorPos = 0
end

commands["quit"] = function()
    love.event.quit()
end

commands["refresh"] = function()
    love.event.quit("restart")
end

commands["ls"] = function()
    local dir = console:goToDirectory(console.currentDirectory)
    if dir then
        for name, _ in pairs(dir) do
            console:print(name)
        end
    else
        console:print("Directory not found")
    end
end

commands["cat"] = {
    __exec = function(args)
        local destination = table.concat(args, "")
        local dir = console:goToDirectory(destination)
        local inDir = console:goToDirectory(console.currentDirectory.."/"..destination)
        if type(dir) == "string" then
            console:print(dir)
        elseif type(inDir) == "string" then
            console:print(inDir)
        end
    end
}

commands["cd"] = {
    __exec = function(args)
        local destination = table.concat(args, "")
        local dir = console:goToDirectory(destination)
        local inDir = console:goToDirectory(console.currentDirectory..destination)
        if dir and type(dir) == "table" then
            console.currentDirectory = destination
        
        elseif inDir and type(inDir) then 
            console.currentDirectory = console.currentDirectory..destination
        else
            console:print("Invalid directory: " .. destination)
        end
    end
}

return commands
