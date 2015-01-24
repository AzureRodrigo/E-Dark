function setVariables ()
	g.count  = 0
	g.finish = false
	g.over   = false
end

function setModules ()
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	-- background
	g.bg = scene:addGameObject ( "background",  1, 0, 0 )
	scene:addGameObjectStatic  ( "fog", 4, 0, 0 )

	g.color = { math.random ( 1, 4 ), math.random ( 1, 4 ), math.random ( 1, 4 ), math.random ( 1, 4 ) } 
	-- triangleHudWhite 
	scene:addGameObjectStatic ( "triangleWhiteHud", 4, -195,  120, { "left",  "down", g.color[2], 2500  } )
	scene:addGameObjectStatic ( "triangleWhiteHud", 4,  195, -120, { "right", "up",   g.color[3], 5000  } )
	scene:addGameObjectStatic ( "triangleWhiteHud", 4, -195, -120, { "left",  "up",   g.color[1], 7500  } )
	scene:addGameObjectStatic ( "triangleWhiteHud", 4,  195,  120, { "right", "down", g.color[4], 10000 } )
	-- triangleHud
	scene:addGameObjectStatic ( "triangleHud", 5, -195, -120, { "left", "up" } )
	scene:addGameObjectStatic ( "triangleHud", 5, -195,  120, { "left", "down" } )
	scene:addGameObjectStatic ( "triangleHud", 5,  195, -120, { "right", "up" } )
	scene:addGameObjectStatic ( "triangleHud", 5,  195,  120, { "right", "down" } )
	-- player
	g.player = scene:addGameObject ( "player", 1, 0, 0 )
end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end 