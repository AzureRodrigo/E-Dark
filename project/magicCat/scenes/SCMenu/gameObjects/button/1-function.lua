function onStart ()
	title = scene:addText  ( config.title, 
							 self:getLayer () + 1, 
							 self:getPos   (1), self:getPos   (2),
							 self:getSize  (1), self:getSize  (2),
							 config.color, 1)

	title:setVisible ( self:getVisible () )

	self:setColor ( 200, 200, 200, 80 )
	self:setParent ( title )
	self:moveToPos ( 0, 0, 3, function ()
		self:setColor ( 255,255,255,100 )
		isActive = true
	end )
end

function onTouchDown ( id, pointerPos, screenPos, time )
	--[[função para ver se foi tocado ou clicado ]]
	if isActive then
		self:setColor ( 100, 100, 100, 50 )
		title:setSelect ( config.selectColor )
		config.funcDown ()
	end
end

function onTouchMove ( id, pointerPos, screenPos, time )
	--[[função para ver se esta sendo arrastado ]]
	if isActive then
		self:setPos  ( pointerPos.x , pointerPos.y )
		config.funcMove ()
	end
end

function onTouchUp   ( id, pointerPos, screenPos, time )
	--[[ função para ver se foi um toque ou clique foi liberado ]]
	if isActive then
		self:setColor ( 255,255,255,100 )
		title:setUnSelect ()
		isActive = false
		config.funcUp ()
	end
end 