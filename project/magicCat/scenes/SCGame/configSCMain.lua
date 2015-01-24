  -- [[ Strutura de Scene ]]
function setVariables ()
	--[[Inícia as variaveis antes de iniciar o app]]
end

function setModules ()
	scene:loadModule ( 'control' )
end

function setGameObjects ()
	local bg = scene:addGameObject ( "bg", 1, 0, 0 )
	local extra = bg:getSize ( "x" )
	
	scene:addGameObject ( "bg", 1, extra, 0 )
	
	g.extra = 200

	g.hero = scene:addGameObject ( "quad", 3, g.extra, 0, { 50, 50, 1})
	game:setPosCamera  ( g.hero:getPos () )
	
	scene:addGameObject ( "fogo" , 5,  g.extra +  200,  0)
	scene:addGameObject ( "agua" , 5,  g.extra + -200,  0)
	scene:addGameObject ( "vento", 5,  g.extra +  0  ,  200)
	scene:addGameObject ( "terra", 5,  g.extra +  0  , -200)
	scene:addGameObject ( "void" , 5,  g.extra +  0  ,  0)
	scene:addText  ( "text" , 10, g.extra +  0  ,  0, 200, 40, Color.Yellow, 1)
end

function onStart ()
	--[[Executa ao iniciar a cena depois dos gameObjects]]
end

function onBackButtonPressed () 
	--[[ dispara quando o botão back de um aparelho com android for precionado ]]
end

function onFocusChanged ( isFocused )
	--[[ dispara quando a aplicação perde o foco ou retorna o foco
		isFocused -> true ou false
	]]
end 