function onStart ()
	title = scene:addText  ( config.title, 
							 self:getLayer () + 1, 
							 self:getPos   (1), self:getPos   (2),
							 self:getSize  (1), self:getSize  (2),
							 config.color, 1)

	title:setVisible ( self:getVisible () )

	self:setColor ( 200, 200, 200, 80 )
	self:setParent ( title )
	self:moveToPos ( posX, self:getPos ("y"), time, function ()
		self:setColor ( 255,255,255,100 )
		isActive = true
	end )
end

function onTouchDown ( id, pointerPos, screenPos, time )
	if isActive and clicked == nil then
		self:setColor ( 100, 100, 100, 50 )
		title:setSelect ( config.selectColor )
		G.effect_btn:play()
		clicked = true
		config.funcDown ()
	end
end

function onTouchUp   ( id, pointerPos, screenPos, time )
	if isActive and clicked and second == nil then
		second = true
		self:setColor ( 255,255,255,100 )
		title:setUnSelect ()
		config.funcUp ()
	end
end 