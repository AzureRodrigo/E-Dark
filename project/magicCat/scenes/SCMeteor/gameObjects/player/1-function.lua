--[[ Struct GameObject  ]]
function onStart ()
	self:setGravityScale (0)
end

accel_x, accel_y, accel_z = 0, 0, 0
timeIddle = 0
timeRun   = 0
nx, ny 	  = 0, 0
sx, sy    = 0, 0
walking   = false

function onUpdate ( frameTime )
	if not g.finish and not g.over and g.start then
		game:setPosCamera  ( self:getPos ("x"), self:getPos ("y") )
		local x, y   = self:getPos  ()
		local xI, yI = g.bg:getSize ()
		if x + 10 > xI/2 or x -10 < -xI/2 then
			g.over = true
		end
		if y + 10 > yI/2 or y - 10 < -yI/2 then
			g.over = true
		end
		if accel_x > 3.5 then
			nx = -1
			sx = -1
		elseif accel_x < -2 then
			nx = 1
			sx = 1
		else --if accel_x > -1.5 and accel_x < 1.5 then
			sx = nx
			nx = 0
		end

		if accel_y > 2.5 then
			ny = 1
			sy = 1
		elseif accel_y < -2.5 then
			ny = -1
			sy = -1
		else --if accel_y > -0.5 and accel_y < -0.1 then
			sy = ny
			ny = 0
		end

		angle = lookAtPos ( self, { self:getPos ( "x" ) + sy, self:getPos ( "y" ) + sx } )
		self:setAngle ( angle )
		self:addPos ( velocity * ny, velocity * nx )
	elseif not g.finish and g.over then
		smallDeath ()
	end
end

function onDraw ( frameTime )
	if g.start and not g.finish then
		timeIddle = timeIddle + frameTime
		timeRun   = timeRun   + frameTime
		if sx == 0 and sy == 0 then
			if self:getSprite () == 3 or self:getSprite () == 4 then
				self:setSprite (1)
			end
			timeRun   = 0
			if timeIddle > 300 then
				timeIddle = 0
				if self:getSprite () < 2 then
					self:setSprite ( 2 )
				else
					self:setSprite ( 1 )
				end
			end
		else
			if self:getSprite () == 1 or self:getSprite () == 2 then
				self:setSprite (3)
			end
			timeIddle = 0
			if timeRun > 150 then
				timeRun = 0
				if self:getSprite () < 3 or self:getSprite () > 3 then
					self:setSprite ( 3 )
				else
					self:setSprite ( 4 )
				end
			end
		end
	elseif g.finish then
		self:setSprite (1)
	end
end

function onAccelerometer ( x, y, z )
	if g.start then 
		accel_x, accel_y, accel_z = x, y, z
	end
end

function onCollision ( objA, objB, type )
	if not g.finish and not g.over and g.start then
		if objB ~= nil and type == "collision BEGIN" then
			if objB.tag == "bullet" then
				if not objB:getRemove () then
					if objB.colorID  == g.color[g.count +1] then
						g.count = g.count  + 1
						g.score:setText ("score: "..g.count)
						objB:remove ()
						if g.count == #g.color then
							g.finish = true
						end
					else
						G.effect_damage:play ()
						g.count = 0
						g.score:setText ("score: "..g.count)
					end
				end
			end
		end
	end
end

function smallDeath ()
	_scale = 1
	if _fall == nil then
		_fall = true
		G.effect_fall:play()
	end
	for i = 1, 11, 1 do
		self:addEvent ( 150 * i, function ()
			if _scale > 0.1 then
				_scale = _scale -.1
				self:setScale ( -.1, -.1 )
			else
				self:setPos  ( 0, 0 )
				self:setSize ( 200 * .3, 325 * .3 ) 
				g.count = 0
				accel_x, accel_y = 0, 0
				g.over  = false
				_fall   = nil
			end
		end )
	end
end
