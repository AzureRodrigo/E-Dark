function onUpdate ( time )
	self:addPos ( -1, 0 )
	if limitScreenOff ( self ) then
		local pos = self:getSize ( "x" ) * 2
		self:addPos ( pos, 0 )
	end
end