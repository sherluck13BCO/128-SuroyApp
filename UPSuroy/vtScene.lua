local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local bg = display.newImage("buttonbg.png", false)
	  bg.x = display.contentCenterX
	  bg.y = display.contentCenterY + 31
	  
	  
	  
local text1 = display.newText( "view tours scene", 0, 0, native.systemFontBold, 24 )
	text1:setFillColor( 255 )
	text1.x, text1.y = display.contentWidth * 0.5, 50

return scene