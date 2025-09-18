local console = {}

function console:load()
    self.currentLine = 1
    self.lines = {{
        content = {}
    }}

end

function console:update(dt)

end

function console:textinput(t)

    table.insert(self.lines[self.currentLine].content, t)

end

function console:keypressed(key)
    if key == "backspace" then
        self.lines[self.currentLine].content = string.sub(self.lines[self.currentLine].content, 1, -2)
    end
end

function console:draw()
    lg.setFont(fontBaS)
    for i = 1, #self.lines do
        love.graphics.print("1. " .. table.concat(self.lines[i].content))
    end

end

return console
