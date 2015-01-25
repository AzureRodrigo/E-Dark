image = "meteorFireBall"
scale = .1
size  = { 355 * scale, 635 * scale }
tag	  = "bullet"
velocity = 5
colorID  = config.color
red, blue, green = nil


if colorID  == 1 then
	red,green,blue = hexToRgb ( Color.Red )
elseif colorID  == 2 then
	red,green,blue = hexToRgb ( Color.Blue )
elseif colorID  == 3 then
	red,green,blue = hexToRgb ( Color.Green )
else
	red,green,blue = hexToRgb ( Color.Purple )
end

self:setColor ( red/2, green/2, blue/2, 30 )

bodyInfo = {
	type 		= "dynamic",
	sensor 		= true,
	mass 	  	= 0,
	restitution = 0,
	friction 	= 0,
	density		= 0,

	shape = {
		box     = nil,
		circle  = { 20, 0 },
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