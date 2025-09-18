local console = {}
local commands = require "src.implementations.commands"

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
    elseif key == "return" then
        self:execute()
    end
end

function console:draw()
    lg.setFont(fontBaS)
    for i = 1, #self.lines do
        love.graphics.print(i .. ". " .. table.concat(self.lines[i].content), 10, 10 + (i * fontBaS:getHeight() + 5))
    end

end

function console:execute()
    local words = self:splitContent(table.concat(self.lines[self.currentLine].content))
    local buildCommand = commands
    local index = 1
    while #words ~= 0 do
        buildCommand = buildCommand[words[index]]
        table.remove(words, 1)
    end
    if buildCommand then
        print(buildCommand())
    end
end

function console:splitContent(str)
    local splitWords = {}
    for word in string.gmatch(str, "%S+") do
        table.insert(splitWords, word)
    end
    return splitWords
end

return console
