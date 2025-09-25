local start = {}
local osInfoImg = lg.newImage("assets/start.png")


function start:load()
    self.timer = 0
    self.screen = {
        img = osInfoImg
    }
    self.screen.width = self.screen.img:getWidth()
    self.screen.height = self.screen.img:getHeight()
    self.screen.x = wW / 2 - self.screen.width / 2
    self.screen.y = wH / 2 - self.screen.height / 2
    self.screen.tween = {
        started = false,
        src = tween.new(2, self.screen,
            { width = self.screen.img:getWidth() / 1.5,
              height = self.screen.img:getHeight() / 1.5,
              y = 50 * scale })
    }

    self.timerManager = Timer:new()
    

    -- Text wall is only REAL info
    self.textWall = {}
    self.textWall.text = self:buildSystemInfo()

  

    -- credits scrolling setup
    self.textWall.scrollY = wH + 50 * scale
    self.textWall.speed = 100 * scale
    self.textWall.started = false

    -- start tween after 1 second
    self.timerManager:after(1, function()
        self.screen.tween.started = true
    end)
end
function start:buildSystemInfo()
  

    return {
        string.format("System Time: %s", sysTime),
        string.format("Operating System: %s", osName),
        string.format("CPU Cores: %d", cores),
        string.format("Lua Version: %s", luaVer),
        string.format("LuaJIT: %s", jitVer),
        string.format("Graphics Renderer: %s", renderer),
        string.format("Graphics Vendor: %s", vendor),
        string.format("Graphics Version: %s", version),
        string.format("Window Size: %dx%d (fullscreen=%s)", winW, winH, tostring(flags.fullscreen)),
        string.format("DPI Scale: %.2f", dpi),
        string.format("FPS: %d", fps),
        string.format("Memory (Lua): %d KB", mem),
        string.format("Mouse Position: %d, %d", mx, my),
        string.format("Joysticks Connected: %d", jsCount),
        string.format("Clipboard Length: %d", clipLen),
        string.format("Uptime: %.2f seconds", uptime),
        "=== COLLECT REQUIRED DATA ==="
    }
end


function start:update(dt)
    self.timerManager:update(dt)
    reloadData()

    if self.screen.tween.started then
        self.screen.tween.src:update(dt)
        self.screen.x = wW / 2 - self.screen.width / 2

        -- Start scrolling credits after tween finishes
        if self.screen.tween.src.clock >= self.screen.tween.src.duration then
            self.textWall.started = true
        end
    end

    -- Scroll credits upward
    if self.textWall.started then
        self.textWall.scrollY = self.textWall.scrollY - self.textWall.speed * dt
    end
    if self.textWall.scrollY < -1 * #self.textWall.text * fontBaM:getHeight() then
        start.setScene("console")
    end

end

function start:draw()
    -- Draw scrolling text credits BEHIND gameover screen
    lg.setScissor(0, self.screen.y + self.screen.height + 50 * scale, wW, wH - self.screen.y * scale)
    lg.setFont(fontBaM)
    self.textWall.text = self:buildSystemInfo()
    if self.textWall.started then
        for i, line in ipairs(self.textWall.text) do
            local textY = self.textWall.scrollY + (i * fontBaM:getHeight() + 10)
            if textY <= wW/2 then
                lg.setColor(0, 1, 0)
            end
            lg.printf(line, 0, textY, wW, "center")
            lg.setColor(1,1,1)
        end
    end
    lg.setColor(0, 1, 0, 0.5)
    lg.rectangle("fill", 0, wH/2, wW, 40)
    lg.setColor(1,1,1)
    lg.setScissor()

    lg.draw(
        self.screen.img,
        self.screen.x,
        self.screen.y + math.sin(love.timer.getTime() * 5 + 10),
        0,
        self.screen.width / self.screen.img:getWidth(),
        self.screen.height / self.screen.img:getHeight()
    )


end

return start
