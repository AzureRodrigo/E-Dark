function onStart ()
	self:addEventLoop ( 100 , function ()
		onUpdate ( 16 )
	end )
end

maxTime = 500
time    = 0
change  = false

function onUpdate ( _time )
	time = time + _time
	if (time > maxTime) then
		time    = 0
		maxTime = math.random ( 100, 300 )
		if g.baloon == 0 then
			g.baloon = 5
			scene:addGameObject ( "balloon", 3, math.random(-220,-120),  math.random(-240, -160), { type = math.random ( 3 ), vel = math.random ( 3, 5 ) } )
			scene:addGameObject ( "balloon", 3, math.random(-80,   40),  math.random(-200, -180), { type = math.random ( 3 ), vel = math.random ( 3, 5 ) } )
			scene:addGameObject ( "balloon", 3, math.random( 80,  220),  math.random(-240, -160), { type = math.random ( 3 ), vel = math.random ( 3, 5 ) } )
			scene:addGameObject ( "balloon", 3, math.random(-120, -20),  math.random(-300, -280), { type = math.random ( 3 ), vel = math.random ( 3, 5 ) } )
			scene:addGameObject ( "balloon", 3, math.random( 20,  120),  math.random(-320, -300), { type = math.random ( 3 ), vel = math.random ( 3, 5 ) } )
		end
	end
end