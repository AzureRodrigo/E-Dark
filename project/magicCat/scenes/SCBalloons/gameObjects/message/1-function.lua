function onUpdate (time)
	check ()
	if isAnimated == true then
		timeanimation = timeanimation + time
		if timeanimation > 300 then
			if self.isCorrect == true then
				if self: getSprite() > 4 then 
					self:addSprite (1)
					if self:getSprite () == 3
						isAnimated = false
					end
				end
			else
				self:addSprite (1)
				if self:getSprite () == 6 then
					isAnimated = false
				end
			end
			timeanimation = 0
		end
	end	
end

function check ()
	if isAnimated == true then
		self:setSprite (1)
	else
		self:setSprite (4)
	end
end