-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local widget = require( "widget" )
local M = {}
local composer = require("composer")
local myMap = require("mymap")

local bgGroup = display.newGroup()
local mapGroup = display.newGroup()
menuGroup = display.newGroup()

local background = display.newImage(bgGroup, "bg.png", false)
background.x = display.contentCenterX
background.y = display.contentCenterY

menuUp = false
huhpressed = false

system.activate("multitouch")



-- local pin = {}
-- pin[1] = {
-- 	text = "Undergrad Building",
-- 	--x = 1326,
-- 	--y = 411,
-- 	x = 50,
-- 	y = 50

-- }

-- pin[2] = {
-- 	text = "Volleyball Court",
-- 	x = 1726,
-- 	y = 491,

-- }
--pin[3] = "Basketball Court"
-- pin[4] = "Management"
-- pin[5] = "Clinic"
-- pin[6] = "Dorms"
-- pin[7] = "Canteen"
-- pin[8] = "Admin Building"
-- pin[9] = "Oble Square"
-- pin[10] = "Guest House"
-- pin[11] = "Library"
-- pin[12] = "Admin Field"
-- pin[13] = "CCC"
-- pin[14] = "AS Field"
-- pin[15] = "AS Buildings"

-- pin[1].x = display.contentCenterX
-- pin[1].y = display.contentCenterY


-- returns the distance between points a and b

function myMap.showScreen1()
	print('before')
	menubg:removeSelf()
		vmButton:removeSelf()
		ctButton:removeSelf()
		vtButton:removeSelf()
		infoButton:removeSelf()
		background:removeSelf()
	composer.removeHidden()
 composer.gotoScene('mapscene',  {time=250, effect="crossFade"})
 print('done doing')
 return true
end



local function fitImage( displayObject, fitWidth, fitHeight, enlarge )
	--
	-- first determine which edge is out of bounds
	--
	local scaleFactor = fitHeight / displayObject.height 
	local newWidth = displayObject.width * scaleFactor
	if newWidth < fitWidth then
		scaleFactor = fitWidth / displayObject.width 
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
	displayObject:scale( scaleFactor, scaleFactor )
end
local pins
local viewMap = function( event )

-- local myGroup = display.newGroup()

-- 		map = display.newImage("map.png", false)
-- 		-- = display.newImage("pins.png", false)

-- 		fitImage(map,500,250,false)
-- 		--fitImage(pins,4000,2500,false)
-- 		map.x = display.contentCenterX
-- 		map.y = display.contentCenterY+40
		

		


-- myGroup:insert(map)
local pins = {}
-- for i = 1, #pin do
-- 	print("pinsss")
-- 				pins[i] = display.newImage("huhbutton.png", false)
-- 				pins[i].x = pin[i].x
-- 				pins[i].y = pin[i].y
-- 				myGroup:insert(pins[i])
-- 			end

	--myGroup:insert(pins)	
-- 		
-- 		local item = display.newImageRect('pin.png',70,70)
-- item.x = pin[1].x
-- item.y = 50

-- local text = display.newText( pin[1].text, 0, 0, "Helvetica", 18 )
-- text:setTextColor( 0, 0, 0, 255 )

-- insert items into group, in the order you want them displayed:
-- myGroup:insert( item )
-- myGroup:insert( text )

	--	map.x = display.contentCenterX
	--	map.y = display.contentCenterY+40
		
		--pins:addEventListener("touch")
	--	myGroup:addEventListener( "touch", onTouch )
		--map:addEventListener("touch", onTouch)
end

local menuPress = function( event )
	if (menuUp == false) then
		menubg = display.newImage("menu.png", false)
		menubg.x = display.contentCenterX
		menubg.y = display.contentCenterY+40
		
		vmButton = widget.newButton
		{
			defaultFile = "Button_vm.png",
			overFile = "Button_vmPressed.png",
			onPress =  myMap.showScreen1
		}
		vmButton.x = display.contentCenterX; vmButton.y = 70
		
		vtButton = widget.newButton

		{
			defaultFile = "Button_vt.png",
			overFile = "Button_vtPressed.png",
			--onPress = button1Press,
			--onRelease = button1Release,
		}
		vtButton.x = display.contentCenterX; vtButton.y = vmButton.y + 80
		
		ctButton = widget.newButton
		{
			defaultFile = "Button_ct.png",
			overFile = "Button_ctPressed.png",
			--onPress = button1Press,
			--onRelease = button1Release,
		}
		ctButton.x = display.contentCenterX; ctButton.y = vtButton.y + 80
		
		infoButton = widget.newButton
		{
			defaultFile = "Button_info.png",
			overFile = "Button_infoPressed.png",
			--onPress = button1Press,
			--onRelease = button1Release,
		}
		infoButton.x = display.contentCenterX; infoButton.y = ctButton.y + 85
		
		menuUp = true
	else
		--local background = display.newImage(bgGroup, "Button_info.png", false)
		--background.x = display.contentCenterX
		--background.y = display.contentCenterY
		menubg:removeSelf()
		vmButton:removeSelf()
		ctButton:removeSelf()
		vtButton:removeSelf()
		infoButton:removeSelf()
		menuUp = false
	end
end

local huhPress = function( event )
	if (huhpressed == false) then
		helpScreen = display.newImage("helpScreen.png", false)
		helpScreen.x = display.contentCenterX
		helpScreen.y = display.contentCenterY+40
		
		huhpressed = true
	else
		helpScreen:removeSelf()

		huhpressed = false
	end
end



local menuButton = widget.newButton
{
	defaultFile = "menubutton.png",
	overFile = "menubuttonPressed.png",
	onPress = menuPress,
	--onRelease = button1Release,
}
menuButton.x = 40; menuButton.y = -5

local huhButton = widget.newButton
{
	defaultFile = "huhbutton.png",
	overFile = "huhbuttonPressed.png",
	onPress = huhPress,
	--onRelease = button1Release,
}
huhButton.x = 280; huhButton.y = -5






