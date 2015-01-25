function onStart ()
	_start = true
	gravity =  math.random ( 1, 6 )
	-- self:setGravityScale ( - gravity/10 )
	self:setGravityScale ( 0 )
end

function onUpdate ()
	if _start == nil then onStart () end
	if self:getPos ( "y" ) > 250 and _killMe == nil then 
		if not self:getRemove () then
			if g.baloon > 0 then 
				g.baloon = g.baloon - 1
			end
			self:remove ()
		end
	end 
end

function onTouchDown ( id, pointerPos, screenPos, time )
	if not g.killer._shotting and _killMe == nil then
		_killMe = true
		g.killer.shoot ( self )
	end
end

function onCollision ( objA, objB, type )
	print (objA,objA, type)
	-- if objB ~= nil then
	-- 	if not objB:getRemove () and objB.tag == "knife" then

	-- 	end
	-- end
end

function removeBallon ()
	if not self:getRemove () then
		if g.baloon > 0 then 
			g.baloon = g.baloon - 1
		end
		self:remove ()
	end
end
