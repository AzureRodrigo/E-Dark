up = false
function onUpdate ( _time )
	if self:getAlpha () > .9 then
		up = false
	elseif self:getAlpha () < .4 then
		up = true
	end

	if up then
		self:addAlpha ( .01 )
	else
		self:addAlpha ( -.01 )
	end

end