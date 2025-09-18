local commands = {

    
}

local console = require 'src.console'
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



return commands