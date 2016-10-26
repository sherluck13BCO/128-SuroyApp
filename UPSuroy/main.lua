-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer")

math.randomseed(os.time())

local welcome = display.newImage("welcome.png", display.contentCenterX, display.contentCenterY)
local function closeSplash()
    display.remove(welcome)
   welcome = nil
    composer.gotoScene("menu")
end

timer.performWithDelay(1500, closeSplash)