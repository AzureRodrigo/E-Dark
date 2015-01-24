function onStart ()
	-- self:addEvent ( 1000, function ()
	-- 	fadeIn ()	
	-- end )
	scene:addText ( "Magic Cat", 3, 0, 100, 200, 100, Color.Purple, 2, "Anatole" )
end

function fadeIn ()
	self:addEvent ( 50, function ()
		if self:getAlpha () < 0.9 then
			self:addAlpha ( 0.1 )
			fadeIn ()
		else
			self:setAlpha ( 1 )
		end
	end )
end
