function setVariables ()
	g.finish = false
	g.start  = false
	if G.effect_btn    == nil then G.effect_btn     = scene:addSound ( "eff_btn" )    end
	if G.effect_cat    == nil then G.effect_cat     = scene:addSound ( "eff_cat" )	  G.effect_cat:setVolume    ( 60 ) end
	if G.effect_damage == nil then G.effect_damage  = scene:addSound ( "eff_damage" ) G.effect_damage:setVolume ( 60 ) end
	if G.effect_fall   == nil then G.effect_fall    = scene:addSound ( "eff_fall" )   G.effect_fall:setVolume   ( 60 ) end
	if G.effect_knife  == nil then G.effect_knife   = scene:addSound ( "eff_knife" )  end
	
	g.ost = scene:addSound ( "intro" )	
	g.ost:setLoop ( true )
	g.ost:setVolume ( 0 )
	g.ost:play ()
end

function setModules ()
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	-- background
	local bg = scene:addGameObject ( "bg", 1, 0, 0 )
	local extra = bg:getSize ( "x" )
	scene:addGameObject ( "bg", 1, extra, 0 )
	-- title
	scene:addGameObject ( "title", 2, 0, 80 )
	-- grass
	scene:addGameObject ( "grass", 3, 0, 90 )
	-- cat
	scene:addGameObject ( "cat", 4, -160, -80 )
	-- moon
	scene:addGameObject ( "moon", 4, 200, 120 )
	-- tree
	scene:addGameObject ( "tree", 5, -65, 0 )
	-- play button
	scene:addGameObject ( "button", 4, -500, -70, {
		image = "introBtnStart",
		title = "",
		selectColor = Color.White,
		funcDown = function ()
		end,
		funcMove = function ()
		end,
		funcUp   = function ()
			if not g.finish then
				g.finish = true
				g.ost:fadeEffect ( "out", 1000)
				g.fade.fadeIn (100, function () 
					game:changeScene ( 1000, "SCMeteor" )
				end)
			end
		end,
		time	 = 3,
		posX	 = 130
	})
	-- credits button
	scene:addGameObject ( "button", 4, -500, -120, {
		 -- o quarto paramentro é uma tabela ilimitada {} onde é possivel passar quantos parametros quiser 
		image = "introBtnCredits",
		title = "",
		selectColor = Color.White,
		funcDown = function ()
		end,
		funcMove = function ()
		end,
		funcUp   = function ()
			if not g.finish then
				g.finish = true
				g.ost:fadeEffect ( "out", 1000)
				g.fade.fadeIn (100, function () 
					game:changeScene ( 1000, "SCCredits" )
				end)
			end
		end,
		time	 = 4,
		posX	 = 130
	})

	g.fade	 = scene:addGameObjectStatic ("fade", 10, 0, 0 )
end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end 