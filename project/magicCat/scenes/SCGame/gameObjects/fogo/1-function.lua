function onStart ()
	bgStage = scene:addSound ( "bg10" )	
	bgStage:setLoop ( true )
	bgStage:setWorldData ( 5, self, g.hero )	

	timeUpSound = 0
end

function onUpdate ( time )
	timeUpSound = timeUpSound + time

	if timeUpSound >= 100 then
		timeUpSound = 0
		bgStage:soundUpdate ()
	end

    lookHero ()
end

function lookHero ()
	self:setAngle ( lookAt (self, g.hero) )
end