local console = {}

function console:load()
    self.currentLine = 1
    self.lines = {{
        content = {}
    }}
    self.cursorPos = 0
    self.blinkTimer = 0
    self.cursorVisible = true
    self.currentDirectory = "C:/"
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
        local lineStr = self.lines[i].content
        local y = 10 + (i * fontBaS:getHeight() + 5)

        -- draw line number prefix
        love.graphics.setColor(1, 1, 1) -- white
        local prefix = "["..self.currentDirectory .. "] "
        love.graphics.print(prefix, 10, y)
        local x = 10 + fontBaS:getWidth(prefix)

        -- split content into words
        local words = self:splitContent(table.concat(lineStr))

        for wi, word in ipairs(words) do
            if self:isCommand(word) then
                love.graphics.setColor(0.3, 0.8, 1) -- cyan for recognized commands
            elseif self:isSubCommand(word) then
                love.graphics.setColor(0.8, 0.8, 0)
            else
                love.graphics.setColor(1, 1, 1) -- normal white text
            end

            love.graphics.print(word, x, y)
            x = x + fontBaS:getWidth(word .. " ")
        end

        -- reset color
        love.graphics.setColor(1, 1, 1)

        -- Draw cursor (only for current line)
        if i == self.currentLine and self.cursorVisible then
            local beforeCursor = table.concat(lineStr, "", 1, self.cursorPos)
            local cursorX = 10 + fontBaS:getWidth(prefix .. beforeCursor)
            love.graphics.print("_", cursorX, y)
        end
    end
end

function console:execute()
    local words = self:splitContent(table.concat(self.lines[self.currentLine].content))
    local buildCommand = commands
    local args = {}
    local index = 1

    while words[index] and buildCommand[words[index]] do
        buildCommand = buildCommand[words[index]]
        index = index + 1
    end

    -- Collect leftover words as args
    for i = index, #words do
        table.insert(args, words[i])
    end

    if type(buildCommand) == "function" then
        local result = buildCommand()
        if result then
            console:print(tostring(result))
        end

    elseif type(buildCommand) == "table" and buildCommand.__exec then
        buildCommand.__exec(args)
    end

    -- Prepare next line
    self.currentLine = self.currentLine + 1
    table.insert(self.lines, {
        content = {}
    })
    self.cursorPos = 0
end

function console:splitContent(str)
    local splitWords = {}
    for word in string.gmatch(str, "%S+") do
        table.insert(splitWords, word)
    end
    return splitWords
end
function console:splitDirectory(str)
    local splitWords = {}
    -- Match drive letter (e.g., C:)
    local drive, rest = string.match(str, "^([A-Za-z]:)[/\\]?(.*)")
    if drive then
        table.insert(splitWords, drive)
        -- Split the rest by / or \
        for part in string.gmatch(rest, "[^/\\]+") do
            table.insert(splitWords, part)
        end
    else
        -- If no drive letter, just split by / or \
        for part in string.gmatch(str, "[^/\\]+") do
            table.insert(splitWords, part)
        end
    end
    return splitWords
end
function console:goToDirectory(pos)
    local locSplits = self:splitDirectory(pos)
    local dir = directories

    while locSplits ~= nil and dir[locSplits[1]].data do
        dir = dir[locSplits[1]].data
        print(locSplits[1])
        table.remove(locSplits, 1)
    end
    if not dir.data then
        return false
    end

    return dir
end
function console:print(str)
    local contentStr = {'>', '>'} -- prefix characters
    for i = 1, #str do
        local ch = string.sub(str, i, i)
        table.insert(contentStr, ch)
    end
    self.currentLine = self.currentLine + 1
    table.insert(self.lines, {
        content = contentStr
    })
    self.cursorPos = #contentStr
end

function console:isCommand(key)
    return commands[key] ~= nil
end

function console:isSubCommand(key)
    -- local words = self:splitContent(table.concat(self.lines[self.currentLine].content))
    -- local buildCommand = commands
    -- local args = {}
    -- local index = 1

    -- while words[index] and buildCommand[words[index]] do
    --     buildCommand = buildCommand[words[index]]

    --     if key == words[index] then

    --         return true
    --     end
    --      if type(buildCommand) == "function" then
    --         break
    --     end
    --     index = index + 1
    -- end

    local function search(tbl)
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                -- direct match inside a command table
                if v[key] ~= nil then
                    if type(v[key]) == "function" then
                        return true
                    end
                end
                -- recursively check deeper
                if search(v) then
                    return true
                end
            end
        end
        return false
    end

    return search(commands)
end

return console
