function onUpdate ( _time )
	time = time + _time
	if time > 300 then
		time = 0
		idImage = idImage + 1
		if idImage > 3 then idImage = 1 end
		self:setImage ("introGrass"..idImage)
	end
end