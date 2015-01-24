-- [[ config GameObject ]]
image = 'button'

if config[2] ~= nil then
	size = { config[2], config[3] }
	-- static, kinematic, dynamic
 local offX, offY = 210, 180
	 tag = "não é bolinha"
	bodyInfo = {
		-- [[Dados base]]
		type 		= "kinematic",
		sensor 		= false,
		mass 	  	= 150,
		restitution = 100,
		friction 	= 30,
		density		= 70,
		-- [[ corpos de colisão ]]
		shape = {
			box     = { -config[2]/2, -config[3]/2, config[2]/2, config[3]/2 },
			circle  = { 50, 0 },
			polygon = nil
		},
		-- [[ filtros de colisão ]]
		filter = {
			box     = Bit.Category_01,
			circle  = Bit.Category_04,
			polygon = Bit.Category_05,
		},
		-- [[ maskaras de colisão ]]
		mask   = {
			box     = Bit.Category_01, 
			circle  = Bit.Category_01, 
			polygon = Bit.Category_01, 
		}
	}
else
	size  = { 20, 20 }
	tag = "bolinha"
	bodyInfo = {
		-- [[Dados base]]
		type 		= "dynamic",
		sensor 		= false,
		mass 	  	= 5,
		restitution = 100,
		friction 	= 0,
		density		= 0,
		-- [[ corpos de colisão ]]
		shape = {
			box     = nil,
			circle  = {10},
			polygon = nil,
		},
		-- [[ filtros de colisão ]]
		filter = {
			box     = nil,
			circle  = Bit.Category_01,
			polygon = nil,
		},
		-- [[ maskaras de colisão ]]
		mask   = {
			box     = nil, 
			circle  = Bit.Category_04 + Bit.Category_01, 
			polygon = nil, 
		}
	}
end

move = config[1]










