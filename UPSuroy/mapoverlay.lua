local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local myMap = require("mymap")
local widgetExtras = require("widget-extras")

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local imgNum = nil
local images = nil
local touchListener, nextImage, prevImage, cancelMove, initImage, jumpToImage
local background
local imageNumberText, imageNumberTextShadow
local backbutton
local navBar
local pins
local index
local descPressed = 0
--widget.theme = myMap.theme

local function goBack( event )
	print(event.phase)
	if event.phase == "ended" then
		composer.hideOverlay( "fade", 250 )
	end
	return true
end
local function showPanel( event )
    	if event.phase == "ended" then
    		sharingPanel:show()
    	end
    	return true
    end
local function setSlideNumber()
		
		navBar:setLabel(pins[index].label)
		--imageNumberTextShadow.text = imgNum .. " of " .. #images
	end
--function new( imageSet, slideBackground, top, bottom )	
function scene:create( event )
	local sceneGroup = self.view
	print("create")
	local pad = 0
	local top = top or 0
	local bottom = bottom or 0

	local start = 1
	if event.params and event.params.start then
		start = event.params.start
	end
	pins = event.params.pinDetails
	 index = event.params.index
	assert(pins, "Error: pins list not set")

	viewableScreenW = display.contentWidth
	viewableScreenH = display.contentHeight - 120 -- status bar + top bar + tabBar
		
    local background = display.newRect(0,0,display.contentWidth, display.contentHeight +30)
    --background:setFillColor( 0.95, 0.95, 0.95 )
    background.x = display.contentWidth / 2
    background.y = display.contentHeight / 2
    background.id = 'background'
    sceneGroup:insert(background)

   -- sharingPanel = widget.newSharingPanel({
    --	})

    
    local descPress = function( event )
    if descPressed == 0 then
		 textbox = native.newTextBox(display.contentWidth/2, 70, display.contentWidth,100)
		textbox.size = 16
		textbox.text = pins[index].text
		textbox.isEditable = false
		sceneGroup:insert(textbox)
		descPressed = 1
	else
		textbox:removeSelf()
		descPressed = 0 
	end
	return true;
	end 
	local picsPress = function(event)
		local options =
{
	    effect = "fade",
	    time = 100,
	    params = {
	        pin = pins[index],
	    }
	}
		composer.gotoScene("picsScene", options)
	end
	local floorplanPress = function( event )
			--print("floorplansPress,",tostring(event.target))
		if(pins[index].hasFP == 1) then 
			composer.showOverlay("picsoverlay", {time=100, effect="crossFade", params={FP= pins[index].FP}})
			local fpimage = display.newImageRect("floorplans/NA.png",display.contentWidth*1.5, display.contentHeight*0.75) 
		fpimage.x = display.contentWidth/2;fpimage.y = display.contentHeight/2 -55
		--fpimage:addEventListener( "touch", onTouch )
		sceneGroup:insert(fpimage)

		end
		return true;
	end

	local leftButton = {
		onEvent = goBack,
		width = 59,
		height = 32,
		defaultFile = "images/backbutton7_white.png",
		overFile = "images/backbutton7_white.png"
	}

	local rightButton = {
		onEvent = showPanel,
		width = 40,
		height = 48,
		defaultFile = "images/sendToButton.png",
		overFile = "images/sendToButtonOver.png",
	}
	--local button =widget.newButton()
    navBar = widget.newNavigationBar({
        title = "VR MAP",
        backgroundColor = { 138/255, 13/255, 39/255 },
        titleColor = {1, 1, 1},
        --font = myApp.fontBold,
        leftButton = leftButton,
        rightButton = rightButton
    })
    navBar.y = -40
    sceneGroup:insert(navBar)
	setSlideNumber()
	images = {}
	
		local p = display.newImage(pins[index].image)
		local h = viewableScreenH-(top+bottom)
		if p.width > viewableScreenW or p.height > h then
			if p.width/viewableScreenW > p.height/h then 
					p.xScale = viewableScreenW/p.width
					p.yScale = viewableScreenW/p.width
			else
					p.xScale = h/p.height
					p.yScale = h/p.height
			end		 
		end
		p.x = screenW*.5
		p.y = h*.5 + 20 + 50
		sceneGroup:insert(p)
	    
	
		floorplanButton = widget.newButton
		{
			defaultFile = "Button_floorplan.png",
			overFile = "Button_floorplanPressed.png",
			onPress = floorplanPress,
			--onRelease = button1Release,
		}
		floorplanButton.x = display.contentWidth/2; floorplanButton.y = 400
		sceneGroup:insert(floorplanButton)
		
		videoButton = widget.newButton
		{
			defaultFile = "Button_videos.png",
			overFile = "Button_videosPressed.png",
			--onPress = vtPress,
			--onRelease = button1Release,
		}
		videoButton.x = display.contentWidth/2; videoButton.y = 440
		sceneGroup:insert(videoButton)
		
		picsButton = widget.newButton
		{
			defaultFile = "Button_desc.png",
			overFile = "Button_descPressed.png",
			onPress = picsPress,
			--onRelease = button1Release,
		}
		picsButton.x = display.contentWidth/2; picsButton.y = 480
		sceneGroup:insert(picsButton)

	
	sceneGroup.x = 0
	sceneGroup.y = top + display.screenOriginY
			
	
	function background:touchListener(self, event) 
	print(event.id)
	return true
end
	
	


	background.touch = touchListener
	background:addEventListener( "touch", background )

	------------------------
	-- Define public methods



end


function scene:show( event )
    local sceneGroup = self.view
    
end

function scene:hide( event )
    local sceneGroup = self.view

    --
    -- Clean up any native objects and Runtime listeners, timers, etc.
    --
    
end

function scene:destroy( event )
    local sceneGroup = self.view
    
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene

