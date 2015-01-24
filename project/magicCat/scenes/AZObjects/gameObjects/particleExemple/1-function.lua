function onStart ()
	limit = 200
	vel   = 5
	self:moveToPos ( 0, 100, 3, function ()
			move = true
	end )
end

function onUpdate ()
	if move then
		if self:getPos (1) >= limit then
			vel = -math.abs(vel)
		elseif self:getPos (1) <= -limit then
			vel = math.abs(vel)
		end

		self:addPos ( vel, 0 )
	end
end

function onRemove ()
	print ("morrendo")
end