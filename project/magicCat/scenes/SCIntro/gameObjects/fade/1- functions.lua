function fadeIn ( time, func )
	if self:getAlpha () < 0.9 then
		self:addAlpha ( .1 )
		self:addEvent ( time, function ()
			fadeIn ( time, func )
		end )
	else
		self:setAlpha ( 1 )
		if func ~= nil then
			func ()
		end
	end
end

function fadeOff ( time, func )
	if self:getAlpha () > 0.1 then
		self:addAlpha ( -.1 )
		self:addEvent ( time, function ()
			fadeOff ( time, func )
		end )
	else
		self:setAlpha ( 0 )
		if func ~= nil then
			func ()
		end
	end
end