-- [[ config GameObject ]]
image = 'balloonKnife'
size = { 15,25 }
limitX = config.limitX
limitY = config.limitY

-- [[ GameObject Body Info  ]]
bodyInfo = {
	type 		= "kinematic",
	sensor 		= false,
	mass 	  	= 0,
	restitution = 0,
	friction 	= 0,
	density		= 0,

	shape = {
		box     = { -size[1]/2, -size[2]/2, size[1]/2, size[2]/2 },
		circle  = nil,
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