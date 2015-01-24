--[[ Struct GameObject  ]]
function onStart ()
	self:setGravityScale (0)
end

function onUpdate ( frameTime )
	game:setPosCamera  ( self:getPos ("x"), self:getPos ("y") )
	local x, y   = self:getPos  ()
	local xI, yI = g.bg:getSize ()
	if x > xI/2 or x < -xI/2 then
		g.over = true
	end
	if y > yI/2 or y < -yI/2 then
		g.over = true
	end

	if g.over then
		smallDeath ()
	end
end

function onAccelerometer ( x, y, z )
	if not g.finish or g.over then
		if y > limitAccel then
			self:addPos ( 0, -velocity )
		elseif y < - limitAccel then
			self:addPos ( 0, velocity )
		end
		if x > limitAccel then
			self:addPos ( velocity, 0 )
		elseif x < - limitAccel then
			self:addPos ( -velocity, 0 )
		end
	end
end

function onCollision ( objA, objB, type )
	if not g.finish or g.over then
		if objB ~= nil and type == "collision BEGIN" then
			if objB.tag == "bullet" then
				if not objB:getRemove () then
					if objB.colorID  == g.color[g.count +1] then
						g.count = g.count  + 1
						objB:remove ()
						if g.count == #g.color then
							g.finish = true
						end
					else
						-- g.count = 0
					end
				end
			end
		end
	end
end

function smallDeath ()
	scale = 1
	for i = 1, 11, 1 do
		self:addEvent ( 100 * i, function ()
			if scale > 0.1 then
				scale = scale -.1
				self:setScale ( scale, scale )
			else
				self:setPos   ( 0, 0 )
				self:setSize ( 50, 50 ) 
				g.count = 0
				g.over  = false
			end
		end )
	end
end
