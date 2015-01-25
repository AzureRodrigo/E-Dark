function onStart ()
	g.ost:fadeEffect ( "in", 1000)
	g.fade.fadeOff (100, function () 
		g.start = true
		self:addEventLoop ( 100 , function ()
			onUpdate ( 16 )
		end )
	end)
end

function onTouchDown ( id, objectPos, scenePos, time )
end

function onTouchMove ( id, objectPos, scenePos, time )
end

function onTouchUp   ( id, objectPos, scenePos, time )
end

maxTime = 100
time    = 0
change  = false

function onUpdate ( _time )
	time = time + _time
	if (time > maxTime) and not g.finish and not g.over then
		time    = 0
		maxTime = math.random ( 80, 300 )
		local x, y 	   = g.player:getPos ()
		local etX, etY = math.random ( 200, 500 ), math.random ( 200, 500 )
		local rX, rY   = math.random ( -1, 1 ), math.random ( -1, 1 )
	 	
	 	if rX == 0 then rX = 1 end
	 	if rY == 0 then rY = 1 end

		scene:addGameObject ( "bullet", 1, ( x + etX ) * rX, ( etY + y ) * rY, { color = math.random (4) } )
	elseif g.finish and not change then
		change = true
		g.ost:fadeEffect ( "out", 1000)
		g.fade.fadeIn (100, function () 
			game:changeScene ( 1000, "SCBalloons" )
		end)
	end
end