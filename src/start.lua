local END = {}
local gameoverimg = lg.newImage("assets/screens/gameover.png")
local pauseImg = lg.newImage("assets/screens/pause.png")
local theme = la.newSource("assets/audio/bg-theme.mp3", "stream")
local theme_rev = la.newSource("assets/audio/bg-theme-rev.mp3", "stream")

function END:load()
    self.timer = 0
    self.screen = {}
    self.screen.img = gameoverimg

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
        "Creative Producer : JIM BROWN",
        "Executive Producer : DAN BLACK",
        "Directed By : LOKH DAWN",
        "Apprentice Programmer : ERIC SON",
        "Property Master : HORST GRANDT",
        "Special FX : LAWD SPEAKS 'A 'LOT",
        "Lead Artist : MARIA SUNG",
        "Cinematic Designer : LUCAS HART",
        "Sound Engineer : TONY REEVES",
        "Composer : ELENA FROST",
        "Voice Acting : CAST OF THOUSANDS",
        "QA Lead : ANITA ROLL",
        "Testers : YOU, THE PLAYER",
        "Special Thanks : COFFEE",
        "Special Thanks : CATS OF THE INTERNET",
        "Made With Love2D <3",
    }

    -- Credits scrolling setup
    self.textWall.scrollY = wH + 50 * scale -- start below screen
    self.textWall.speed = 75 * scale       -- pixels per second
    self.textWall.started = false

    self.pauseImg = pauseImg
    self.pauseEnabled = false

    self.theme = theme
    self.theme_rev = theme_rev

    self.timerManager:after(1, function()
        self.screen.tween.started = true
    end)
    self.timerManager:after(25, function ()
        self.theme:stop()
        self.theme_rev:play()
        self.pauseEnabled = true
        self.textWall.speed = -150 * scale
    end)
    self.theme:play()
end

function END:update(dt)
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

    if self.pauseEnabled and self.textWall.scrollY > wH + 100 * scale then
        END.setScene("TRANSITION")
    end
end

function END:draw()
    -- Draw scrolling text credits BEHIND gameover screen
    lg.setScissor(0, self.screen.y + self.screen.height + 50 * scale, wW, wH - self.screen.y * scale)
    if self.textWall.started then
        lg.setFont(fontM) -- medium font for readability
        for i, line in ipairs(self.textWall.text) do
            local textY = self.textWall.scrollY + (i * 40)
            lg.printf(line, 0, textY, wW, "center")
        end
    end
    lg.setScissor()

    -- Draw gameover screen
    lg.setFont(fontHH)
    lg.draw(
        self.screen.img,
        self.screen.x,
        self.screen.y + math.sin(love.timer.getTime() * 5 + 10),
        0,
        self.screen.width / self.screen.img:getWidth(),
        self.screen.height / self.screen.img:getHeight()
    )

    if self.pauseEnabled then
        lg.setColor(41 / 255, 30 / 255, 22 / 255, 0.7)
        lg.rectangle("fill", 0, 0, wW, wH)
        lg.draw(self.pauseImg, wW / 2 - self.pauseImg:getWidth() / 2, wH / 2 - self.pauseImg:getHeight() / 2)
    end

end

return END
