image = 'balloonBalloon'
size  = { 60, 80 }

_type = config.type
red, blue, green = nil
_time = 0
_vel  = config.vel
if _type == 1 then
	red,green,blue = hexToRgb(Color.Red)
elseif _type == 2 then
	red,green,blue = hexToRgb(Color.Green)
else
	red,green,blue = hexToRgb(Color.Blue)
end

self:setColor ( red, green, blue, 100)

tagCollision = "balloon"

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