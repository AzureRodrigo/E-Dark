function onUpdate ( time )
	vel = 3
	local x, y = self:getPos ()
	if moving then
		if right then
			if x+ vel < g.extra + 160 then
				self:addPos ( vel, 0 )
			end
		else
			if x - vel > g.extra  - 160 then
				self:addPos ( -vel, 0 )
			end
		end
		if up then
			if y + vel < 160 then
				self:addPos ( 0, vel )
			end
		elseif down then
			if y - vel > -160 then
				self:addPos ( 0, -vel )
			end
		end
	end
	game:setPosCamera ( self:getPos () )
end