local console = require 'src.console'

local commands = {
    __exec = function(args)
                local output = table.concat(args, " ")

        if output ~= "" then
            console:print("Unknown Command ".."'"..output.."'")
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
        end
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

commands["echo"]= {
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
    
end

commands["cd"] = {
    __exec = function(args)
        local destination = table.concat(args, "")
        console.currentDirectory = destination
    end
}

return commands