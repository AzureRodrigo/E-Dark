ponto = 0
texto = "score: "

textbox = nil

function onStart ()
	if move then
		self:setPivo ( 0, 0 )
		self:setGravityScale (1)
	end	

	if self.tag == "bolinha" then
		girando ()
		textbox = scene:addText ( texto..ponto , 9, 0, 0, 200, 200 )
	end
end

function girando ()
	self:addEvent ( 16, function ()
		self:addAngle ( -1 )
		girando ()
		if self.tag == "bolinha" then
			ponto = ponto + 1
			textbox:setText(texto..ponto)
		end
	end )
end

function onCollision ( objA, objB, type )
	if objA.tag == "bolinha" then
		if objA.tag ~= nil and objB.tag ~= nil and type == "collision BEGIN" then
			print (objA.tag, " está colidindo com: ", objB.tag)
			if not objA.textbox:getRemove () then
				objA.textbox:remove ()
			end
			--[[ retorna se a thing foi removida ]] 
		end
	end
	-- print( "colisão entre: ",objA," e : ",objB," do tipo: "..type )
end

