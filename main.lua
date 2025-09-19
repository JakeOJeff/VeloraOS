local SceneryInit = require("src.libs.scenery")

-- Incorporating Libraries
tween = require 'src.libs.tween'


-- Classes
Timer = require 'src.classes.Timer'


-- commands
commands = require "src.implementations.commands"
directories = require "src.implementations.directories"

-- Setting global modules
lg = love.graphics
lk = love.keyboard
la = love.audio

-- Load sys data
function reloadData()
    osName = love.system.getOS()
    renderer, vendor, version = love.graphics.getRendererInfo()
    luaVer = _VERSION
    jitVer = jit and jit.version or "N/A"
    mem = collectgarbage("count")
    cores = love.system.getProcessorCount()
    winW, winH, flags = love.window.getMode()
    uptime = love.timer.getTime()
    fps = love.timer.getFPS()
    dpi = love.window.getDPIScale()

    clip = love.system.getClipboardText() or ""
    clipLen = #clip

    joysticks = love.joystick.getJoysticks()
    jsCount = #joysticks
    mx, my = love.mouse.getPosition()

    sysTime = os.date("%Y-%m-%d %H:%M:%S")
    print("RELOAD")
end
reloadData()
-- Setting base values

local baseWidth = 1280
local baseHeight = 720

wW = love.graphics.getWidth()
wH = love.graphics.getHeight()

scale = math.max(wW / baseWidth, wH / baseHeight)


-- fonts 

fontStyH = love.graphics.newFont("assets/fonts/fredrick-the-great.ttf", 75 )
fontStyM = love.graphics.newFont("assets/fonts/fredrick-the-great.ttf", 40 )
fontStyS = love.graphics.newFont("assets/fonts/fredrick-the-great.ttf", 25 )

fontBaH = love.graphics.newFont("assets/fonts/Barlow-Regular.ttf", 75)
fontBaM = love.graphics.newFont("assets/fonts/Barlow-Regular.ttf", 40)
fontBaS = love.graphics.newFont("assets/fonts/Barlow-Regular.ttf", 25)

-- Scenery System

local scenery = SceneryInit(
    { path = "src.start"; key = "start", default = true},
    { path = "src.console"; key = "console"}
)


scenery:hook(love)