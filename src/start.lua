local start = {}
local osInfoImg = lg.newImage("assets/start.png")


function start:load()
    self.timer = 0
    self.screen = {}
    self.screen.img = osInfoImg

    self.screen.width = self.screen.img:getWidth()
    self.screen.height = self.screen.img:getHeight()
    self.screen.x = wW / 2 - self.screen.width / 2
    self.screen.y = wH / 2 - self.screen.height / 2
    self.screen.tween = {
        started = false,
        src = tween.new(2, self.screen,
            { width = self.screen.img:getWidth() / 1.5, height = self.screen.img:getHeight() / 1.5, y = 50 * scale })
    }

    self.timerManager = Timer:new()


    self.textWall = {}
    self.textWall.text = {
       "Initializing kernel...",
        "Loading graphics driver v%s...",
        "Mounting filesystem [%s]...",
        "Checking memory: %d MB OK",
        "Connecting to system bus...",
        "Driver [%s] initialized",
        "Module [%s]... SUCCESS",
        "Scanning PCI devices... %d found",
        "Starting background daemon [%s]",
        "Authentication services... READY",
        "System entropy pool seeded",
        "Launching user interface..."
    }

    self.drivers = { "TWEEN", "TIMER", "SCENERY", "PHYSICS", "AUDIO", "NET", "INPUT" }
    self.fs = { "ext4", "fat32", "ntfs", "customfs" }
    self.daemons = { "watchdog", "sync", "power", "gfxd", "audiod", "netd" }
    
    math.randomseed(os.time())
    for i = 1, 25 do
        local msg = self.textWall.text[math.random(#self.textWall.text)]
        msg = msg:gsub("%%s", function()
            local pick = ({self.drivers, self.fs, self.daemons})[math.random(3)]
            return pick[math.random(#pick)]
        end)
        msg = msg:gsub("%%d", tostring(math.random(0, collectgarbage("count"))))
        table.insert(self.textWall.text, msg)
    end
    table.insert(self.textWall.text, "=== SYSTEM LOADED SUCCESSFULLY ===")

    -- Credits scrolling setup
    self.textWall.scrollY = wH + 50 * scale -- start below screen
    self.textWall.speed = 75 * scale       -- pixels per second
    self.textWall.started = false


    self.timerManager:after(1, function()
        self.screen.tween.started = true
    end)
    self.timerManager:after(25, function ()

        self.pauseEnabled = true
        self.textWall.speed = -150 * scale
    end)
end

function start:update(dt)
    self.timerManager:update(dt)

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

end

function start:draw()
    -- Draw scrolling text credits BEHIND gameover screen
    lg.setScissor(0, self.screen.y + self.screen.height + 50 * scale, wW, wH - self.screen.y * scale)
    lg.setFont(fontBaM)
    if self.textWall.started then
        for i, line in ipairs(self.textWall.text) do
            local textY = self.textWall.scrollY + (i * fontBaM:getHeight() + 10)
            lg.printf(line, 0, textY, wW, "center")
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
