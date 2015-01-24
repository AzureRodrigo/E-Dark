function onStart ()
	--[[Executa ao iniciar]]
end

function onTouchDown ( id, objectPos, scenePos, time )

	g.hero.moving = true
	if scenePos.x > game:getSizeDevice ("x")/2 then
		g.hero.right = true
	else
		g.hero.right = false
	end

   	if scenePos.y < game:getSizeDevice ("y") * .4 then
		g.hero.up   = true
		g.hero.down = false
	elseif scenePos.y > game:getSizeDevice ("y") * 6 then
		g.hero.up   = false
		g.hero.down = true
	else
		g.hero.up   = false
		g.hero.down = false
	end
end

function onTouchMove ( id, objectPos, scenePos, time )
	--[[função para ver se esta sendo arrastado ]]
	if scenePos.x > game:getSizeDevice ("x")/2 then
		g.hero.right = true
	else
		g.hero.right = false
	end
	if scenePos.y < game:getSizeDevice ("y") * .4 then
		g.hero.up   = true
		g.hero.down = false
	elseif scenePos.y > game:getSizeDevice ("y") * .6 then
		g.hero.up   = false
		g.hero.down = true
	else
		g.hero.up   = false
		g.hero.down = false
	end

	local angle = lookAtMouse ( objectPos, g.hero )

	g.hero:setAngle ( angle )
end

function onTouchUp   ( id, objectPos, scenePos, time )
	g.hero.moving = false
	g.hero.up     = false
	g.hero.down   = false
end

function on ( ... )
end
