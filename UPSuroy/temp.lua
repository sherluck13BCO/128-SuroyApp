local composer = require("composer")
local myMap = require("mymap")


local scene = composer.newScene()



function scene:create(event) 
	print('scene create')

end



scene:addEventListener("create", scene)

return scene