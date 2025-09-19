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
    { path = "src.start"; key = "start"},
    { path = "src.console"; key = "console", default = true}
)


scenery:hook(love)