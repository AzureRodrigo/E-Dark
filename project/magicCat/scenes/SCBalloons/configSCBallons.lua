function setVariables ()
	g.finish 	= false
	g.over   	= false
	g.choice 	= math.random (3)
	g.baloon 	= 0
	g.baloonMax = 4

	-- g.correctColor = math.random(1,3)
	-- g.contBalloons = 0
end

function setModules ()
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	scene:addGameObject ( "bg", 1, 0, 150,  {false, 600, 50} )	
	-- scene:addGameObject ( "platform", 3,   0, -150 )
	-- scene:addGameObject ( "catknife", 4, -15, -80 )
	-- scene:addGameObject ( "knife", 4, -25, -80, { limitX = 240, limitY = 160 } )
end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end