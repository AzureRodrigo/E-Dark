image = 'balloonBalloon'
size  = { 80, 120 }
typeColor = config.type
red = nil
green = nil
blue = nil
timeanimation = 0

if typeColor == 1 then
	red,green,blue = hexToRgb(Color.Red)
elseif typeColor == 2 then
	red,green,blue = hexToRgb(Color.Green)
else
	red,green,blue = hexToRgb(Color.Blue)
end

self:setColor ( red, green, blue, 1)

tagCollision = "balloon"
-- [[ GameObject Body Info  ]]
bodyInfo = {
	type 		= "kinematic",
	sensor 		= true,
	mass 	  	= 0,
	restitution = 0,
	friction 	= 0,
	density		= 0,

	shape = {
		box     = nil,
		circle  = {10,0},
		polygon = nil
	},
	filter = {
		box     = nil,
		circle  = nil,
		polygon = nil
	},
	mask   = {
		box     = nil, 
		circle  = nil, 
		polygon = nil
	}
}