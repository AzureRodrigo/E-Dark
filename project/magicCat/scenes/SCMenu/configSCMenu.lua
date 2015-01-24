function setVariables ()
	--[[Inícia as variaveis antes de iniciar o app]]
end

function setModules ()
	--[[Inícia os modulos antes de iniciar o app]]
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	--[[Inícia os gameObjects antes de iniciar o app]]

	-- adicionando um gameObject que se encontra na pasta gameObjects deste cena

	scene:addGameObject ( "teste", 3, 5, 50,   {true}  )
	scene:addGameObject ( "teste", 3, 0, -150, {false, 600, 50} )
	scene:addGameObject ( "teste", 3, 0, 150,  {false, 600, 50} )
	scene:addGameObject ( "teste", 3, -240, 0, {false, 50, 600} )
	scene:addGameObject ( "teste", 3,  240, 0, {false, 50, 600} )

	scene:addGameObject ( "button", 1, -500, 0, {
		 -- o quarto paramentro é uma tabela ilimitada {} onde é possivel passar quantos parametros quiser 
		title = "Next Screen",
		selectColor = Color.White,
		funcDown = function ()
		end,
		funcMove = function ()
		end,
		funcUp   = function ()
			-- quando executar a função funcUp a particula irá parar de emitir
			g.particle:particlePause ()
			-- adicionando um novo evento daqui a 100 mili
			game:addEvent ( 100, function ()
				-- verifica se a particula ainda existe
				if not g.particle:getRemove () then
					-- remove a particula
					g.particle:remove ()
				end
			end )			
			-- adicionando o evento de troca de cena em 1000 mili "1 seg" para a cena nomeada
			game:changeScene ( 1000, "SCGame" )
		end
	})

	-- adicionando um gameObject que se encontra em outra pasta "neste cados uma particula"
	g.particle = scene:loadGameObject ( "AZObjects", "particleExemple", 1, 500, 150 )
	-- lembrando que g. são variaveis globais pertencentes a cena atual e G. são variaveis globais pertencentes ao jogo todo
end

function onBackButtonPressed () 
	--[[ dispara quando o botão back de um aparelho com android for precionado ]]
end

function onFocusChanged ( isFocused )
	--[[ dispara quando a aplicação perde o foco ou retorna o foco mobile
		isFocused -> true ou false
	]]
end 