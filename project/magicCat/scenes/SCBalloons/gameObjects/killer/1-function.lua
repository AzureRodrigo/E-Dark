function shoot ( target )
	_time = 0
	_shotting = true
	_target = target
	self:setSprite (1)

	if self:getPos (1) < target:getPos (1) then
		self:setFlip ( "right" )
		_left   = false
	else
		self:setFlip ( "left" )
		_left   = true
	end
end

function onUpdate ( frameTime )
	if _shotting then
		if self:getSprite () < 4 then
			_time = _time + frameTime
			if _time >= 90 then
				_time = 0
				self:addSprite ( 1 )
			end
		else
			if _left then dir = -1
			else dir = 1 end
			scene:addGameObject ( "knife", 4, 25 * dir, -105, { _target, _left } )
			_shotting = false
		end
	else
		shootEnd ()
	end
end

function shootEnd ()
	if self:getSprite () ~= 5 then
		self:setSprite (5)
	end
end