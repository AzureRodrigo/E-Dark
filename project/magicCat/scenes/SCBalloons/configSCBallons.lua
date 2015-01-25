function setVariables ()
	g.finish = false
	g.start  = false
	g.ost    = scene:addSound ( "baloon" )	
	g.ost:setLoop ( true )
	g.ost:setVolume ( 0 )
	g.ost:play ()
	g.over     = false
	g.choice   = math.random (3)
	g.baloon   = 0
	g.count    = 0	
	g.sequence = { 
		math.random ( 3 ),
		math.random ( 3 ),
		math.random ( 3 ),
		math.random ( 3 ),
		math.random ( 3 )
	}
	
	G.effect_knife   = scene:addSound ( "eff_knife" )
	G.effect_explode = scene:addSound ( "eff_explode" )

end

function setModules ()
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	scene:addGameObject ( "bg", 	  1, 0, 0,  {false, 600, 50} )	
	scene:addGameObject ( "clouds",   2, 0,   70,  {1} )	
	scene:addGameObject ( "clouds",   2, 340, 60,  {2} )	
	scene:addGameObject ( "circus",   1, -170, -80 )	
	scene:addGameObject ( "platform", 3, 1, -190 )
	g.killer = scene:addGameObject 		 ( "killer", 4, 0, -120 )
	g.score  = scene:addTextStatic 		 ( "score: "..g.count, 6, 0, 140, 300, 50, Color.Yellow, 1.5 )
	g.fade	 = scene:addGameObjectStatic ("fade", 10, 0, 0 )

	g.txt1   = '<c:'..Color.White..'>'.."Get "

	if g.sequence [g.count + 1]  == 1 then
		g.txt2   = '<c:'..Color.Blue..'>'   
		g.color  = "Green"
	elseif g.sequence [g.count + 1]  == 2 then
		g.txt2   = '<c:'..Color.Red..'>'   
		g.color  = "Blue"
	else
		g.txt2   = '<c:'..Color.Green..'>'
		g.color  = "Red"   
	end

	g.lbl = scene:addTextStatic ( g.txt1..g.txt2..g.color..'<c:'..Color.White..'>'.." Balloon" , 8, 160, -140, 300, 50 )

end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end