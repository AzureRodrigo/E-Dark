function onStart ()
	self:addEventLoop ( 100 , function ()
		onUpdate ( 16 )
	end )
end

function onTouchDown ( id, objectPos, scenePos, time )
	print ("Scene touchDown")
end

function onTouchMove ( id, objectPos, scenePos, time )
	print ("Scene touchMove")
end

function onTouchUp   ( id, objectPos, scenePos, time )
	print ("Scene touchUP ")
end

maxTime = 100
time    = 0
change  = false

function onUpdate ( _time )
	time = time + _time
	if (time > maxTime) then
		time    = 0
		maxTime = math.random ( 80, 300 )
		
		if g.baloon < g.baloonMax then
			g.baloon = g.baloon + 1
			scene:addGameObject ( "balloon", 2, math.random(-200,200), math.random(-300,-180), { type = math.random ( 3 ) } )
		end
	-- elseif g.finish and not change then
		-- change = true
		-- game:changeScene ( 1000, "SCBalloons" )
	end
end