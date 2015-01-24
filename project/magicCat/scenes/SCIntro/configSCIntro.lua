function setVariables ()
	g.finish = false
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
	scene:addGameObject ( "title", 2, 0, 0 )
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
		title = "Start",
		selectColor = Color.White,
		funcDown = function ()
		end,
		funcMove = function ()
		end,
		funcUp   = function ()
			game:changeScene ( 1000, "SCMeteor" )
		end,
		time	 = 3,
		posX	 = 130
	})
	-- credits button
	scene:addGameObject ( "button", 4, -500, -120, {
		 -- o quarto paramentro é uma tabela ilimitada {} onde é possivel passar quantos parametros quiser 
		title = "Credits",
		selectColor = Color.White,
		funcDown = function ()
		end,
		funcMove = function ()
		end,
		funcUp   = function ()
			-- game:changeScene ( 1000, "SCGame" )
		end,
		time	 = 4,
		posX	 = 130
	})


end

function onBackButtonPressed () 
end

function onFocusChanged ( isFocused )
end 