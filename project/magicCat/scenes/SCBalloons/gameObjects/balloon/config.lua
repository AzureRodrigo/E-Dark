image = 'balloons'
scale = .1
size  = { 425 * scale, 956 * .09 }

_type = config.type
red, blue, green = nil
_time   		 = 0
_vel    		 = config.vel
_killMe 		 = false
if _type == 1 then
	red,green,blue = hexToRgb(Color.Red)
elseif _type == 2 then
	red,green,blue = hexToRgb(Color.Green)
else
	red,green,blue = hexToRgb(Color.Blue)
end

self:setColor ( red, green, blue, 100)

bodyInfo = {
	type 		= "dynamic",
	sensor 		= true,
	mass 	  	= 100,
	restitution = 0,
	friction 	= 0,
	density		= 0,

	shape = {
		box     = nil,
		circle  = { (425)/2 * scale, 0, 17 },
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
