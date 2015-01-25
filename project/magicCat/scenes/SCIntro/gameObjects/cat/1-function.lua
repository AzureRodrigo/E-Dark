function onStart ()
	fadeOff ( 200 )
end

function fadeIn ( time )
	if self:getAlpha () < 0.9 then
		self:addAlpha ( .08 )
		self:addEvent ( time, function ()
			fadeIn ( time, func )
		end )
	else
		self:setAlpha ( 1 )
		fadeOff (150)
	end
end

function fadeOff ( time )
	if self:getAlpha () > 0.4 then
		self:addAlpha ( -.08 )
		self:addEvent ( time, function ()
			fadeOff ( time, func )
		end )
	else
		self:setAlpha ( 0.4 )
		fadeIn (150)
	end
end