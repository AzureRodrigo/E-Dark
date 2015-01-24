function onUpdate ()	
	if self:getPos ("y") > limitY then
		if not self:getRemove () then
			self:getRemove ()
		end
	end
	if self:getPos ("x") < -limitX then
		if not self:getRemove () then
			self:getRemove ()
		end
	end
	if self:getPos ("x") > limitX then
		if not self:getRemove () then
			self:getRemove ()
		end
	end
end

function onCollision ( objA, objB, type )
	if objB ~= nil and objA ~= nil then
		if objB.tag == "balloon" and type == "collision BEGIN" then
			if objB.typeColor == g.correctColor then
				scene:addGameObject ( "message", 6, self:getPos ( "x" ), self:getPos ( "y" ), { isCorrect = true  } )
				g.score = g.score + 1
			else
				scene:addGameObject ( "message", 6, self:getPos ( "x" ), self:getPos ( "y" ), { isCorrect = false  } )
				g.score = 0
			end
			g.contBalloons = g.contBalloons - 1
			if not objA.textbox:getRemove () then
				objA.textbox:remove ()
			end
			if not objB.textbox:getRemove () then
				objB.textbox:remove ()
			end
		end
	end
end