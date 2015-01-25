function onStart ()
	credits ()
	g.ost:fadeEffect ( "in", 1000)
	g.fade.fadeOff (100, function () 
		g.start = true
	end)
end

function onTouchDown ( id, objectPos, scenePos, time )
end

function onTouchMove ( id, objectPos, scenePos, time )
end

function onTouchUp   ( id, objectPos, scenePos, time )
end

function credits ()
	value = 1500
	self:addEvent ( 100 + value + value * .1, function ()
		scene:addGameObject ( "label", 4, 500, 150, { "Progamming", 3, 0 })
	end)
	self:addEvent ( 150 + value + value * .2, function ()
		scene:addGameObject ( "label", 4, 500, 120, { "Rodrigo Pimentel Tomaz", 3, 0 })
	end)
	self:addEvent ( 200 + value + value * .3, function ()
		scene:addGameObject ( "label", 4, 500, 100, { "Rafael Bueno dos Santos", 3, 0 })
	end)
	self:addEvent ( 250 + value + value * .4, function ()
		scene:addGameObject ( "label", 4, 500, 70, { "Art", 3, 0 })
	end)
	self:addEvent ( 300 + value + value * .5, function ()
		scene:addGameObject ( "label", 4, 500, 50, { "Isadora Aita Fabricio Salgado", 3, 0 })
	end)
	self:addEvent ( 350 + value + value * .6, function ()
		scene:addGameObject ( "label", 4, 500, 30, { "Renata Ferraio", 3, 0 })
	end)
	self:addEvent ( 400 + value + value * .7, function ()
		scene:addGameObject ( "label", 4, 500, -0, { "Music and Sounds", 3, 0 })
	end)
	self:addEvent ( 450 + value + value * .8, function ()
		scene:addGameObject ( "label", 4, 500, -20, { "Renan Gabriel Ribeiro", 3, 0 })
	end)
	self:addEvent ( 500 + value + value * .9, function ()
		scene:addGameObject ( "label", 4, 500, -40, { "Gabriel de Souza Gouveia Oliveira", 3, 0 })
	end)
	self:addEvent ( 550 + value + value * 1, function ()
		scene:addGameObject ( "label", 4, 500, -70, { "Support",  3, 0 })
	end)
	self:addEvent ( 600 + value + value * 1.1, function ()
		scene:addGameObject ( "label", 4, 500, -90, { "Matheus Dalla",  3, 0 })
	end)
	self:addEvent ( 650 + value + value * 1.2, function ()
		scene:addGameObject ( "label", 4, 500, -120, { "Other",  3, 0 })
	end)
	self:addEvent ( 700 + value + value * 1.3, function ()
		scene:addGameObject ( "label", 4, 500, -140, { "Eduardo Gasperin",  3, 0 })
	end)
end
