-- [[ config GameObject ]]
image = 'balloonKnife'
scale = .1
size = { 50 * scale ,220 * scale  }

_target   = config[1]
_left     = config[2]
_velocity = 25 
_tag 	  = "knife"

bodyInfo = {
	type 		= "dynamic",
	sensor 		= true,
	mass 	  	= 0,
	restitution = 0,
	friction 	= 0,
	density		= 0,

	shape = {
		box     = nil,
		circle  = { 5, 0, 5 },
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