function onStart ()
	self:setBullet (true)
	self:setGravityScale (0)
	angle = lookAt ( self, _target )
	self:setAngle ( angle )
end

onStart ()

future = 50

function onUpdate ()	
	angle = lookAt ( self, _target )
	self:setAngle ( angle )

	_x, _y =  _target:getPos (1) - self:getPos (1), _target:getPos (2) + future  - self:getPos (2) 
	local pX, pY = (100 * _x) / 500 , (100 * _y) / 500 
	
	self:setLinearVelocity ( _velocity * pX,  _velocity * pY )		
end
