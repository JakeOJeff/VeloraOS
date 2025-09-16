local SceneryInit = require("src.libs.scenery")

-- Incorporating Libraries
tween = require 'src.libs.tween'

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



-- Scenery System

local scenery = SceneryInit(

)


scenery:hook(love)