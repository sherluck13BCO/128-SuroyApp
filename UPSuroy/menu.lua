local widget = require( "widget" )
local M = {}
local composer = require("composer")
local myMap = require("mymap")
local sceneGroup

local scene = composer.newScene()
system.activate("multitouch")
function scene:create(event)
	sceneGroup = self.view

	local bgGroup = display.newGroup()
	--local mapGroup = display.newGroup()
	-- menuGroup = display.newGroup()

	local background = display.newImage(bgGroup, "bg.png", false)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
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
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(menuButton)
	sceneGroup:insert(huhButton)
end
function scene:show(event)
	local sceneGroup = self.view
end
function scene:hide(event)
	local sceneGroup = self.view
end
function scene:destroy(event)
	local sceneGroup = self.view
	-- body
end
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)




menuUp = false
huhpressed = false
function testfunc(event)
	if event.phase =='began' then 
		print("testfunc")
	end
end 
function menuPress( event )
	print("menu")
	if event.phase == "began" then
		print("menupress began")
	end
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
		sceneGroup:insert(menubg)
		sceneGroup:insert(vmButton)
		sceneGroup:insert(vtButton)
		sceneGroup:insert(ctButton)
		sceneGroup:insert(infoButton)
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

function myMap.showScreen1()
	print('before')
	-- menubg:removeSelf()
	-- 	vmButton:removeSelf()
	-- 	ctButton:removeSelf()
	-- 	vtButton:removeSelf()
	-- 	infoButton:removeSelf()
	-- 	background:removeSelf()
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







return scene
