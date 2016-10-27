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
--widget.theme = myMap.theme

local function goBack( event )
	print("goBack", event.phase)
	if event.phase == "ended" then
		composer.hideOverlay( "crossFade", 250 )
	end
	return true
end
function showPanel( event )
    	print("showPanel")
    	if event.phase == "ended" then
    		print("showPanel")
    		sharingPanel:show()
    	end
    	return true
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
	local fp = event.params.FP
	assert(fp, "Error: pins list not set")

	viewableScreenW = display.contentWidth
	viewableScreenH = display.contentHeight - 120 -- status bar + top bar + tabBar
		
    local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
    background:setFillColor( 0.95, 0.95, 0.95 )
    background.x = display.contentWidth / 2
    background.y = display.contentHeight / 2

    sceneGroup:insert(background)

   -- sharingPanel = widget.newSharingPanel({
    --	})


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

    navBar = widget.newNavigationBar({
        title = "Photo Gallery",
        backgroundColor = { 138/255, 13/255, 39/255 },
        titleColor = {1, 1, 1},
        --font = myApp.fontBold,
        leftButton = leftButton,
        rightButton = rightButton,
    })
    sceneGroup:insert(navBar)
	
	images = {}

	for i = 1,#fp do
		local p = display.newImage(fp[i])
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
		sceneGroup:insert(p)
	    
		if (i > 1) then
			p.x = screenW*1.5 + pad -- all images offscreen except the first one
		else 
			p.x = screenW*.5
		end
		
		p.y = h*.5 + 20 + 50

		images[i] = p
	end
	
	local defaultString = "1 of " .. #images
	
	imgNum = 1
	
	sceneGroup.x = 0
	sceneGroup.y = top + display.screenOriginY
			
	function touchListener (self, touch) 
		local phase = touch.phase
		print("slides", phase)
		if ( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the contentBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos = touch.x
			prevPos = touch.x
			
        elseif( self.isFocus ) then
        
			if ( phase == "moved" ) then
						
				if tween then transition.cancel(tween) end
	
				print(imgNum)
				
				local delta = touch.x - prevPos
				prevPos = touch.x
				
				images[imgNum].x = images[imgNum].x + delta
				
				if (images[imgNum-1]) then
					images[imgNum-1].x = images[imgNum-1].x + delta
				end
				
				if (images[imgNum+1]) then
					images[imgNum+1].x = images[imgNum+1].x + delta
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = touch.x - startPos
				print("dragDistance: " .. dragDistance)
				
				if (dragDistance < -40 and imgNum < #images) then
					nextImage()
				elseif (dragDistance > 40 and imgNum > 1) then
					prevImage()
				else
					cancelMove()
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
														
			end
		end
					
		return true
		
	end
	
	function setSlideNumber()
		print("setSlideNumber", imgNum .. " of " .. #images)
		navBar:setLabel(imgNum.."of" .. #images)
		--imageNumberTextShadow.text = imgNum .. " of " .. #images
	end
	
	function cancelTween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	
	function nextImage()
		tween = transition.to( images[imgNum], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum + 1
		initImage(imgNum)
	end
	
	function prevImage()
		tween = transition.to( images[imgNum], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum - 1
		initImage(imgNum)
	end
	
	function cancelMove()
		tween = transition.to( images[imgNum], {time=400, x=screenW*.5, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
	end
	
	function initImage(num)
		if (num < #images) then
			images[num+1].x = screenW*1.5 + pad			
		end
		if (num > 1) then
			images[num-1].x = (screenW*.5 + pad)*-1
		end
		setSlideNumber()
	end

	background.touch = touchListener
	background:addEventListener( "touch", background )

	------------------------
	-- Define public methods
	
	function jumpToImage(num)
		local i
		print("jumpToImage")
		print("#images", #images)
		for i = 1, #images do
			if i < num then
				images[i].x = -screenW*.5;
			elseif i > num then
				images[i].x = screenW*1.5 + pad
			else
				images[i].x = screenW*.5 - pad
			end
		end
		imgNum = num
		initImage(imgNum)
	end

	jumpToImage(start)

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

