function setVariables ()
	g.start  = false
	g.ost    = scene:addSound ( "credits" )	
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
	-- play button
	scene:addGameObject ( "button", 4, 500, 120, {
		image = "creditsBack",
		title = "",
		selectColor = Color.White,
		funcDown = function ()
		end,
		funcMove = function ()
		end,
		funcUp   = function ()
			g.ost:fadeEffect ( "out", 1000)
			g.fade.fadeIn (100, function () 
				game:changeScene ( 1000, "SCIntro" )
			end)
		end,
		time	 = 3,
		posX	 = -180
	})

	g.fade	 = scene:addGameObjectStatic ("fade", 10, 0, 0 )
end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end 