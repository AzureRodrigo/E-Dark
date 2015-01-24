function onUpdate ()
	self:addPos ( 0, 3 )
	if self:getPos ( "y" ) > 250 then 
		if not self:getRemove () then
			if g.baloon > 0 then 
				g.baloon = g.baloon - 1
			end
			self:remove ()
		end
	end 
end

function onTouchDown ( id, pointerPos, screenPos, time )

end

function onCollision ( objA, objB, type )

end

function removeBallon ()
	if not self:getRemove () then
		if g.baloon > 0 then 
			g.baloon = g.baloon - 1
		end
		self:remove ()
	end
end
