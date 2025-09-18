local console = {}

function console:load()
    self.currentLine = 1
    self.lines = {{
        content = {}
    }}
    self.cursorPos = 0 -- cursor position inside the line (0 = before first char)
    self.blinkTimer = 0
    self.cursorVisible = true
    self:print("Use 'get help' to get started! ")
end

function console:update(dt)
    self.blinkTimer = self.blinkTimer + dt
    if self.blinkTimer >= 0.5 then
        self.cursorVisible = not self.cursorVisible
        self.blinkTimer = 0
    end
end

function console:textinput(t)
    local line = self.lines[self.currentLine].content
    table.insert(line, self.cursorPos + 1, t) -- insert at cursor
    self.cursorPos = self.cursorPos + 1
end

function console:keypressed(key)
    local line = self.lines[self.currentLine].content

    if key == "backspace" then
        if self.cursorPos > 0 then
            table.remove(line, self.cursorPos)
            self.cursorPos = self.cursorPos - 1
        end

    elseif key == "delete" then
        if self.cursorPos < #line then
            table.remove(line, self.cursorPos + 1)
        end

    elseif key == "left" then
        if self.cursorPos > 0 then
            self.cursorPos = self.cursorPos - 1
        end

    elseif key == "right" then
        if self.cursorPos < #line then
            self.cursorPos = self.cursorPos + 1
        end

    elseif key == "return" then
        self:execute()
    end
end

function console:draw()
    lg.setFont(fontBaS)
    for i = 1, #self.lines do
        local lineStr = table.concat(self.lines[i].content)
        local y = 10 + (i * fontBaS:getHeight() + 5)

        love.graphics.print(i .. ". " .. lineStr, 10, y)

        -- Draw cursor on the current line
        if i == self.currentLine and self.cursorVisible then
            local beforeCursor = table.concat(self.lines[i].content, "", 1, self.cursorPos)
            local cursorX = 10 + fontBaS:getWidth(i .. ". " .. beforeCursor)
            love.graphics.print("_", cursorX, y )
        end
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
    if buildCommand and buildCommand ~= commands then
        print(buildCommand())
    end

    self.currentLine = self.currentLine + 1
    table.insert(self.lines, {content = {}})
    self.cursorPos = 0
end

function console:splitContent(str)
    local splitWords = {}
    for word in string.gmatch(str, "%S+") do
        table.insert(splitWords, word)
    end
    return splitWords
end

function console:print(str)
    local contentStr = {'>', '>'} -- prefix characters
    for i = 1, #str do
        local ch = string.sub(str, i, i)
        table.insert(contentStr, ch)
    end
    self.currentLine = self.currentLine + 1
    table.insert(self.lines, {content = contentStr})
    self.cursorPos = #contentStr
end

return console
