function onUpdate ( _time )
	time = time + _time
	if time > 300 then
		time = 0
		self:addSprite ( 1 )
	end
end