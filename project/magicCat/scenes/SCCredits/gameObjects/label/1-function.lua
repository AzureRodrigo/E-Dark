function onStart ()
	title = scene:addText  ( config[1], 
							 self:getLayer ()+1, 
							 self:getPos   (1), self:getPos   (2),
							 self:getSize  (1), self:getSize  (2), Color.White, 1 )
	self:setParent ( title )
	self:moveToPos ( config[3], self:getPos ("y"), config[2], function ()

	end )
end