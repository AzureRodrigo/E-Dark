azCoreGroup = {}
local azClassGroup = {}

function azCoreGroup.new ()
	local newGroup = {
		things = { }
	}
	extends ( newGroup, azClassGroup )
	return newGroup
end

function azClassGroup:addThing ( thing, name )
	self.things [ name ] = thing
	thing:addGroup ( self )
end

function azClassGroup:setPause ( state )
	for _, thing in pairs ( self.things ) do
		thing:setPause ( state )
	end
end

function azClassGroup:setStatic ( state )
	for _, thing in pairs ( self.things ) do
		thing:setStatic ( state )
	end
end

function azClassGroup:get ( name )
    return self.things [ name ]
end

function azClassGroup:setVisible ( state )
	for _, thing in pairs ( self.things ) do
		thing:setVisible ( state )
	end
end

function azClassGroup:getThings ()
	local ret = {}
	copyTable ( ret, self.things )
	return ret
end

function azClassGroup:clear ()
	self.things = {}
end

function azClassGroup:remove ( thing )
	for _, curThing in pairs ( self.things ) do
		if curThing == thing then
			curThing:removeGroup ( self )
			table.remove ( self.things, i )
			return
		end
	end
end

function azClassGroup:removeThing ( thing )
	local thingsToRemove = {}
	for _, curThing in pairs ( self.things ) do
		if curThing == thing or thing == nil then
			table.insert ( thingsToRemove, curThing )
		end
	end
	for i = 1, #thingsToRemove do
		local curThing = thingsToRemove [ i ]
		curThing:remove ()
	end
end