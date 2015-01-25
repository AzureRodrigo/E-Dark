function onUpdate ()
	self:addPos ( -.5 + config[1]/10, 0 )
	if limitScreenOff ( self ) then
		local pos = self:getSize ( "x" ) * 2.5
		self:addPos ( pos, 0 )
	end
end