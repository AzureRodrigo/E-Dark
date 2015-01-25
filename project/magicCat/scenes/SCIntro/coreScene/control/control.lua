function onStart ()
	g.ost:fadeEffect ( "in", 1000)
	g.fade.fadeOff (100, function () 
		g.start = true
	end)
end

function onTouchDown ( id, objectPos, scenePos, time )
end

function onTouchMove ( id, objectPos, scenePos, time )
end

function onTouchUp   ( id, objectPos, scenePos, time )
end