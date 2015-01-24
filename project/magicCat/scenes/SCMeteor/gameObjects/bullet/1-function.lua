--[[ Struct GameObject  ]]
function onStart ()
	self:setGravityScale (0)
	posx, posy = calcDist ( self, g.player, "all" )
	x, y =  g.player:getPos (1) - self:getPos (1), g.player:getPos (2) - self:getPos (2) 
	angle = lookAt ( self, g.player )
	self:setAngle ( angle )
	local pX, pY = (100 * x) / 500 , (100 * y) / 500 
	self:setLinearVelocity ( velocity * pX,  velocity * pY )
end

onStart ()

function onTouchDown ( id, pointerPos, screenPos, time )
	if click == nil and not self:getRemove ()  then
		click = true 
		self:remove ()
	end
end
