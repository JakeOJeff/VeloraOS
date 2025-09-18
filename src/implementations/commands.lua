local commands = {

    
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
    end,
    ["desktop"] = function()
        love.window.setFullscreen(false)
    end
}


return commands