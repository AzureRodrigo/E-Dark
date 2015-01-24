image = "meteorPlayer"
size  = { 50, 50 }

velocity 	= 3
limitScreen = {}
limitAccel	= .2
tag = "player"

bodyInfo = {
	type 		= "dynamic",
	sensor 		= false,
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