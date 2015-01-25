function setVariables ()
	g.finish = false
	g.start  = false
	g.ost    = scene:addSound ( "baloon" )	
	g.ost:setLoop ( true )
	g.ost:setVolume ( 0 )
	-- g.ost:play ()
	g.over   	= false
	g.choice 	= math.random (3)
	g.baloon 	= 0

	-- g.correctColor = math.random (1,3)
	-- g.contBalloons = 0
end

function setModules ()
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	scene:addGameObject ( "bg", 1, 0, 0,  {false, 600, 50} )	
	scene:addGameObject ( "clouds", 2, 0,   70,  {1} )	
	scene:addGameObject ( "clouds", 2, 340, 60,  {2} )	
	scene:addGameObject ( "circus", 1, -170, -80 )	

	-- scene:addGameObject ( "platform", 3,   0, -150 )
	g.killer = scene:addGameObject ( "killer", 4, 0, -120 )
	-- scene:addGameObject ( "knife2", 4, 0 , 0 )
	g.fade	 = scene:addGameObjectStatic ("fade", 10, 0, 0 )
end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end