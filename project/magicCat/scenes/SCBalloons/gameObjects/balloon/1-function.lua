function onStart ()
	_start = true
	gravity =  math.random ( 1, 6 )
	self:setGravityScale ( - gravity/10 )
end

time = 0

function onUpdate ( _time )
	time = time + _time
	if time > 200 then
		time = 0
		self:addSprite ( 1 )
	end
	if not g.finish then
		if _start == nil then onStart () end
		if self:getPos ( "y" ) > 200 then 
			if _killMe then
				self:setGravityScale (0)
				self:setLinearVelocity (0,0)
			else
				removeBallon ()
			end
		end 
	end
end

function onTouchDown ( id, pointerPos, screenPos, time )
	if not g.killer._shotting and not _killMe and not g.finish then
		_killMe = true
		g.killer.shoot ( self )
	end
end

function onCollision ( objA, objB, type )
	if type == "collision BEGIN" then
		if objB ~= nil then
			if not objB:getRemove () and objB._tag == "knife" and objB._target == self then
				objB:remove ()
				G.effect_explode:play ()
				x,y = self:getPos ()
				scene:addGameObject ( "boom", self:getLayer () + 1 , x, y )
				if g.sequence [g.count + 1] == _type then
					g.count = g.count + 1
				else
					g.count    = 0	
					g.sequence = { 
						math.random ( 3 ),
						math.random ( 3 ),
						math.random ( 3 ),
						math.random ( 3 ),
						math.random ( 3 )
					}
				end
				g.score:setText ("score: "..g.count)
				textUpdate ()
				removeBallon ()
			end
		end
	end
end

function textUpdate ()
	if g.count < 5 then
		if g.sequence [g.count + 1]  == 1 then
			g.txt2   = '<c:'..Color.Blue..'>'   
			g.color  = "Green"
		elseif g.sequence [g.count + 1]  == 2 then
			g.txt2   = '<c:'..Color.Red..'>'   
			g.color  = "Blue"
		else
			g.txt2   = '<c:'..Color.Green..'>'
			g.color  = "Red"   
		end
		g.lbl:setText( g.txt1..g.txt2..g.color..'<c:'..Color.White..'>'.." Balloon")
	else
		g.finish = true
		g.lbl:setText( g.txt1.."Complete!" )
	end
end

function removeBallon ()
	g.baloon = g.baloon - 1
	if not self:getRemove () then
		self:remove ()
	end
end
