azCoreGameObject	     = {}
local UPDATE_MILE_SECOND = 16.6666667
local azClassGameObject 	     = {}
local dateConfigFiles    = {}
local dateFiles          = {}
local nameSpaceInfo      = "config.lua"

-- [[ lê os aquivos no diretório definido ]]
local function listThingFiles ( path, config )
	if config then
		local date = dateConfigFiles [ path ]
		if date ~= nil then
			return date 
		else
			date = {}
			if fileExist ( path .. "/"..nameSpaceInfo ) then
				table.insert ( date, path .. "/"..nameSpaceInfo )
			end
			dateConfigFiles [ path ] = date
			return date;
		end
	end
	local dateChunk = dateFiles [ path ]
	if dateChunk ~= nil then
		return dateChunk
	end
	local gameObjectFiles = {}
	local orderFiles = {}
	for _, gameObjectFileName in ipairs ( listFiles ( path ) ) do
		if gameObjectFileName:find ( ".lua" ) ~= nil and gameObjectFileName ~= nameSpaceInfo then
			local characterDist = gameObjectFileName:find ( "-" )
			local characterIgnore = gameObjectFileName:find ( "_" )
			if characterDist ~= nil and characterIgnore == nil then
				table.insert ( orderFiles, { order = tonumber ( gameObjectFileName:sub ( 1, characterDist - 1 ) ), file = gameObjectFileName } )
			else
				table.insert ( gameObjectFiles, path .. "/" .. gameObjectFileName )
			end
		end
	end
	table.sort ( orderFiles, function ( a, b ) return a.order < b.order end )
	for _, file in ipairs ( orderFiles ) do
		table.insert ( gameObjectFiles, path .. "/" .. file.file )
	end
	dateFiles [ path ] = gameObjectFiles
	return gameObjectFiles
end

local function searchThingFiles ( folder, name, config )
	local thingFiles = nil
	local currentLoadingModuleName = azCoreGame:getScene ():getExecutingModuleName ()
	local files = listThingFiles ( 'project/'.._Project..'/scenes/' .. folder .. '/gameObjects/' .. name, config )
	return files
end

local function loadThing ( env, folder, name, sceneName )
	local files = searchThingFiles ( folder, name, true )
	if #files == 0 then
		return false
	end
	local newEnv = { }
	extends ( newEnv, azCoreGlobal.coreFunctions )
	for _, file in ipairs ( files ) do
		doFileSandbox ( env, file )
	end
	return true
end

-- faz merda nenhuma se possivel remover
local function checkThingEnvVariables ( thingEnv )
	return true
end

-- externo usado por objetos
function azCoreGameObject.new ( folder, name, sceneName, scene, config )--refazer inteiro
	local newThing = {
		prop2d 	    		 = MOAIProp2D.new (),
		removed     		 = false,
		placed      		 = false,
		layerId     		 = -1,
		width  	    		 = 0,
		deck 				 = nil,
		heigh 				 = 0,
		static 				 = false,
		moduleEnvs  		 = {},
		events 				 = {},
		parents				 = {},
		loopFunctions 		 = azCoreLinkedList.new (),
		eventTicks  		 = 0,
		paused 				 = false,
		isInUpdateList 	     = false,
		thingInUpdateList    = { thing = nil, listTimeout = 0, isInLoop = false, isInList = false },
		eventIdCounter       = 0,
		env 				 = nil,
		imageName   		 = '',
		adjustedBlendMode    = false,
		spriteIndex  		 = 1,
		color 		 		 = { r = 1, g = 1, b = 1, a = 1 },
		visible 	 		 = true,
		groups 		 		 = { },
		texture 	 		 = nil,
		delayedEvents   	 = azCoreLinkedList.new (),
		executingEvents 	 = false,
		eventDelayCorrection = 0,
		currentFrame 		 = 0,
		lastUpdatedEvents 	 = 0,
		eventCounter 		 = 0,
		game 				 = azCoreGame,
		G 					 = azCoreGame:getGlobalTable (),
		Color 				 = azCoreGame:getColorTable  (),
		Bit                  = azCoreGame:getBitTable    (),
		file 				 = azCoreDataManager,
		billing 			 = azCoreBilling,
		tools   			 = azCoreTools,
		g 					 = scene.global,
		m 					 = scene.globalModules,
		global  			 = scene.global,
		config  			 = config,
		nextFrameEvents 	 = {},	
		particle 			 = nil,
		plugin   			 = nil,
		system   			 = nil,
		state    			 = nil,
		emitter  			 = nil,
		deck     			 = nil,
		part 	 			 = {},
		body = {
			shape = nil,
			box  = {
				shape 		= nil,
				size 		= nil,
				filter 		= nil,
				collision 	= nil,
				onCollision = false,
			},
			circle = {
				shape 		= nil,
				size 		= nil,
				filter 		= nil,
				collision 	= nil,
				onCollision = false,
			},
			polygon = {
				shape 		= nil,
				size 		= nil,
				filter 		= nil,
				collision 	= nil,
				onCollision = false,
			},
		}
	}

	newThing.self = newThing 
	
	extends ( newThing, azCoreGlobal.coreFunctions )
	extends ( newThing, azClassGameObject )

	newThing.thingInUpdateList.thing = newThing
	if not loadThing ( newThing, folder, name, sceneName ) then
		return nil
	end

	newThing.imageName = newThing.image
	if newThing.size ~= nil then
		newThing.width = newThing.size [1]
		newThing.heigh = newThing.size [2]
	end

	newThing.prop2d.thing = newThing
	return newThing
end

function azClassGameObject:setRect ( ... )
	self.prop2d:setRect ( ... )
end

function azClassGameObject:setDeck ( deck, texture )
	self.prop2d:setDeck ( deck )
	self.texture = texture
	self.deck 	 = deck
end

function azClassGameObject:getWorldPoses ()
	local propX1, propY1, propZ1, propX2, propY2, propZ2 = self.prop2d:getWorldBounds()
	return { x1 = propX1, y1 = propY1, x2 = propX2, y2 = propY2 }
end

function azClassGameObject:getDescription ()
	local propX1, propY1, propZ1, propX2, propY2, propZ2 = self.prop2d:getWorldBounds ()
	return "gameObject " .. "[" .. propX1 .. "/" .. propY1 .. ";" .. propX2 .. "/" .. propY2 .. "]"
end

function azClassGameObject:getProp ()
	return self.prop2d
end

function azClassGameObject:getTexture ()
	return self.texture
end

-- [[ add gameObject functions ]]
function azClassGameObject:addThing ( ... ) 
	self.scene:internalAdd ( self, ... )
end

function azClassGameObject:addToUpdateEventList ( loop )
	if self.thingInUpdateList.isInLoop or self.thingInUpdateList.isInList then
		return
	end
	if loop then
		self.thingInUpdateList.isInLoop = loop
	end
	if not self.thingInUpdateList.isInList then
		self.scene:addThingToUpdateList ( self.thingInUpdateList )
		self.thingInUpdateList.isInList    = true
		self.thingInUpdateList.listTimeout = getTime() + 5000
	end
end

-- [[ event gameObject functions ]]
function azClassGameObject:addEvent ( time, func )
	if azCoreGame:getDebugEventsActive () then
		local info = debug.getinfo ( 2 )
		self.scene:addThingEventDebugCounter ( self, info.short_src .. ":" .. info.currentline )
	end
	if type ( func ) ~= 'function' then
		error ( 'Invalid function to addEvent.' )
		return
	end
	if self.removed then
		error("Trying to add event to a removed thing.")
		return
	end
	self.eventCounter = self.eventCounter + 1
	self:addToUpdateEventList ()
	if time == nil then
		self.nextFrameEvents [ #self.nextFrameEvents + 1 ] = { func = func, addedTime = getTime () }
	else
		if time < 16 then
			time = 16
		end
		self.eventIdCounter = self.eventIdCounter + 1
		if self.executingEvents then
			time = time - self.eventDelayCorrection
		end
		if self.executingEvents and self.eventTicks + time <= self.eventTicks then
			self.delayedEvents:pushBack ( { time = self.eventTicks + time, func = func, eventId = self.eventIdCounter } )
		else
			local frame = self.currentFrame + math.max ( 1, math.ceil ( time / UPDATE_MILE_SECOND ) )
			local frameChunk = self.events [ frame ]
			if frameChunk == nil then
				frameChunk = { }
				self.events [ frame ] = frameChunk
			end
			frameChunk [ #frameChunk + 1 ] = { time = self.eventTicks + time, func = func, eventId = self.eventIdCounter }
		end
	end
	return eventIdCounter
end

function azClassGameObject:addEventCoroutine ( time, func )
	local co = coroutine.create ( func )
	local function eventFunc ( timePassed )
		local ret, value = coroutine.resume ( co, timePassed )
		if not ret then
			error ( value )
		end
		if coroutine.status ( co ) == 'suspended' and not self.removed then
			self:addEvent ( value, eventFunc )
		end
	end
	self:addEvent ( time, eventFunc )
end

function azClassGameObject:addEventLoop ( interval, func )
	if type ( func ) ~= 'function' then
		error ( 'loopFunction is not a func' )
		return
	end
	if interval < UPDATE_MILE_SECOND then
		interval = UPDATE_MILE_SECOND
	end
	self.loopFunctions:pushBack ( { func = func, interval = interval, intervalToActive = 0, nextEvent = interval } )
	self:addToUpdateEventList ( true )
end

function azClassGameObject:removeEvent ( eventId )
	for event in lpairs ( self.events ) do
		if event.eventId == eventId then
			return self.events:remove ( event )  
		end
	end
	return false
end

-- [[ update gameObject functions ]]
function azClassGameObject:thinkEvents ()
	local executedEvents = 0
	local currentFrame   = self.currentFrame - math.floor ( ( self.eventTicks - self.lastUpdatedEvents ) / UPDATE_MILE_SECOND )
	local maxFrame       = self.currentFrame
	while currentFrame <= maxFrame do
		local events = self.events [ currentFrame ]
		if events ~= nil then
			self.executingEvents = true
			for i = 1, #events do
				local event = events [ i ]
				self.eventDelayCorrection = self.eventTicks - event.time
				event.func ()
				executedEvents    = executedEvents + 1
				self.eventCounter = self.eventCounter - 1
				if self.removed then
					return executedEvents
				end
			end
			self.executingEvents = false
		end
		self.events [ currentFrame ] = nil
		currentFrame = currentFrame + 1
	end
	self.lastUpdatedEvents = self.eventTicks
	for event in lpairs ( self.delayedEvents ) do
		event.func ()
		executedEvents    = executedEvents + 1
		self.eventCounter = self.eventCounter - 1
	end
	self.delayedEvents =azCoreLinkedList.new ()
	return executedEvents
end

function azClassGameObject:internalOnAdd ()
	-- print (self.scene.name,self.folderName)
	local files = searchThingFiles ( self.scene.name, self.folderName, false )
	if #files == 0 then
		return false
	end
	for _, file in ipairs ( files ) do
		doFileSandbox ( self, file )
	end


	if self.onStart ~= nil then
		self.onStart ()
	end
	if self.onCollision ~= nil then
		self:bodyCollide ( self.onCollision )
	end
end

function azClassGameObject:internalUpdate ( time )
	self.eventTicks   = self.eventTicks + time
	self.currentFrame = self.currentFrame + 1
	local start = getTime ()
	local ret = self:executeNextFrameEvents ()
	if not self.removed then
		ret = ret + self:executeLoopFunctions ( time ) + self:thinkEvents ()
	end
	self.eventTicks = self.eventTicks - ( getTime () - start )
	return ret
end

function azClassGameObject:executeNextFrameEvents ()
	local ret = 0
	if self.nextFrameEvents [ 1 ] ~= nil then
		local events = { }
		copyTable ( events, self.nextFrameEvents )
		self.nextFrameEvents = { }
		local currentTime = getTime ()
		for i, event in ipairs ( events ) do
			event.func ( currentTime - event.addedTime )
			self.eventCounter = self.eventCounter - 1
			if self.removed then
				return ret
			end
		end
	end
	return ret
end

function azClassGameObject:executeLoopFunctions ( timePassed )
	local ret = 0
	self.executingEvents = true
	for loopFunc in lpairs ( self.loopFunctions ) do
		loopFunc.intervalToActive = loopFunc.intervalToActive + timePassed
		while loopFunc.intervalToActive >= loopFunc.nextEvent do
			self.eventDelayCorrection = loopFunc.intervalToActive - loopFunc.nextEvent
			loopFunc.nextEvent = loopFunc.intervalToActive + loopFunc.interval - self.eventDelayCorrection
			loopFunc.func ()
			ret = ret + 1
			if self.removed then
				return ret
			end
		end
	end
	self.executingEvents = false
	for event in lpairs ( self.delayedEvents ) do
		event.func ()
	end
	self.delayedEvents =azCoreLinkedList.new ()
	return ret
end

function azClassGameObject:setParent ( object )
	table.insert ( self.parents, object )
end

-- [[ remove gameObject functions ]]
function azClassGameObject:removeFromUpdateEventList ( force )
	if force then
		self.thingInUpdateList.isInList = false
		return self.scene:removeThingToUpdateList ( self.thingInUpdateList )
	else
		if self.thingInUpdateList.isInLoop then
			return false
		end
		if self.thingInUpdateList.isInList and self.thingInUpdateList.listTimeout <= getTime () then
			self.scene:removeThingToUpdateList ( self.thingInUpdateList )
			self.thingInUpdateList.isInList = false
		end
	end
	return false
end

function azClassGameObject:remove ()
	if not self:getRemove () then
		self:addEvent ( 16, function ()
			for id, tmp in pairs ( self.parents ) do
				if not tmp:getRemove () then
					self.scene:remove (tmp)
				end
			end
			if not self:getRemove () then
				self.scene:remove (self)
			end
		end )
	end
end

function azClassGameObject:removeParent ( object )
	if not object:getRemove () then
	 	for id, tmp in ipairs ( self.parents ) do
	   		if tmp == object then
				table.remove ( self.parents, id )
				object:remove ()
				return true
			end
		end
	end
end

function azClassGameObject:removeGroup ( group )
	for i = 1, #self.groups do
		local curGroup = self.groups [ i ]
		if curGroup == group then
			table.remove ( self.groups, i )
			return
		end
	end
end

function azClassGameObject:cleanUp ()
	local groups = { }
	copyTable ( groups, self.groups )
	for i = 1, #groups do
		groups [ i ]:remove ( self )
	end
	if self.deck ~= nil then
		self.deck:setTexture ( nil )
	end
	self.prop2d:setDeck ( nil )
	self.prop2d.thing 	 = nil
	self.prop2d 		 = nil
	self.deck 			 = nil
	self.moduleEnvs 	 = nil
	self.global  		 = nil
	self.billing 		 = nil
	self.tools   		 = nil
	self.g 		 		 = nil
	self.self    		 = nil
	self.events  		 = nil
	self.texture 		 = nil
	self.delayedEvents   = nil
	self.nextFrameEvents = nil
	if self.body.shape ~= nil then
		self.body.shape:destroy ()
		if self.body.box.shape ~= nil then
			self.body.box.shape:destroy ()
		end
		if self.body.circle.shape ~= nil then
			self.body.circle.shape:destroy ()
		end
		if self.body.polygon.shape ~= nil then
			self.body.polygon.shape:destroy ()
		end


		body = {
			shape = nil,
			box   = {
				shape 		= nil,
				filter 		= nil,
				collision 	= nil,
				onCollision = false,
			},
			circle = {
				shape 		= nil,
				filter 		= nil,
				collision 	= nil,
				onCollision = false,
			},
			polygon = {
				shape 		= nil,
				filter 		= nil,
				collision 	= nil,
				onCollision = false,
			},
		}
	end
end

-- [[ image inGame functions ]]
function azClassGameObject:addSprite ( value )
	if value == nil then 
		value = 1 
	end
	local id = self:getSprite ()
	if id == nil then
		id = 1
	end
	self:setSprite ( id + value )
end

function azClassGameObject:addAlpha ( number )
	if not self.adjustedBlendMode then
		self.adjustedBlendMode = true
		self.prop2d:setBlendMode ( MOAIProp2D.GL_SRC_ALPHA, MOAIProp2D.GL_ONE_MINUS_SRC_ALPHA )
	end
	self.color.a = self.color.a + number
	self.prop2d:setColor ( self.color.r, self.color.g, self.color.b, self.color.a )
end

function azClassGameObject:addAngle ( angle )
	self:setAngle ( self:getAngle () + angle )
end

function azClassGameObject:setImage ( imageName )
	local newImage, texture = azCoreImages:getDeck ( imageName )
	if newImage == nil then
		return
	end
	self.imageName 		= imageName
	self.deck:setTexture ( nil )
	self:setDeck 		 ( newImage )
	self.deck 			= newImage
	self.texture 		= texture
	self:setSize 		 ( self:getSize () )
end

function azClassGameObject:setSprite ( value )
	self.prop2d:setIndex ( value )
	self.spriteIndex = value
end

function azClassGameObject:setIdLayer ( number )
	self.layerId = number
end

function azClassGameObject:setPriority ( value )
	self.prop2d:setPriority ( value )
end

function azClassGameObject:setVisible ( state )
	self.prop2d:setVisible ( state ) 
	self.visible = state
end

function azClassGameObject:setColor ( r, g, b, a )
	if a == nil then
		a = self.color.a
	end
	if a ~= 1 then
		if not self.adjustedBlendMode then
			self.adjustedBlendMode = true
			self.prop2d:setBlendMode ( MOAIProp2D.GL_SRC_ALPHA, MOAIProp2D.GL_ONE_MINUS_SRC_ALPHA )
		end
	end
	self.color = { r = r/255.0, g = g/255.0, b = b/255.0, a = a/100 }
	self.prop2d:setColor ( r/255.0, g/255.0, b/255.0, a/100 )
end

function azClassGameObject:setAlpha ( number )
	if not self.adjustedBlendMode then
		self.adjustedBlendMode = true
		self.prop2d:setBlendMode ( MOAIProp2D.GL_SRC_ALPHA, MOAIProp2D.GL_ONE_MINUS_SRC_ALPHA )
	end
	self.color.a = number
	self.prop2d:setColor ( self.color.r, self.color.g, self.color.b, number )
end

function azClassGameObject:setColorPixel ( x, y, r, g, b, a )
	if self.texture.getRGBA ~= nil then
		r = r * 1 / 255
		g = g * 1 / 255
		b = b * 1 / 255
		a = a * 1 / 255
		self.texture:setRGBA ( x, y, r, g, b, a )
	end
end

function azClassGameObject:setPivo ( x, y )
	if self.body.shape ~= nil then
		self.body.shape:setLocalCenter ( x, y )
	else
		self.prop2d:setPiv ( x, y )
	end
end

function azClassGameObject:getImage ()
	return self.imageName
end

function azClassGameObject:getSprite ()
	return self.spriteIndex
end

function azClassGameObject:getLayer ()
	return self.layerId
end

function azClassGameObject:getPriority ()
	return self.prop2d:getPriority()
end

function azClassGameObject:getVisible ()
	return self.visible
end

function azClassGameObject:getColor ()
	return self.color
end

function azClassGameObject:getAlpha ()
	return self:getColor ().a
end

function azClassGameObject:getColorPixel ( x, y )
	if self.texture.getRGBA ~= nil then
		local r, g, b, a = self.texture:getRGBA ( x, y )
		r = r * 255 / 1
	    g = g * 255 / 1
	    b = b * 255 / 1
	    a = a * 255 / 1
	    return r, g, b, a
	else
		return nil
	end
end

function azClassGameObject:getPivo ()
	if self.body.shape ~= nil then
		return self.body.shape:getLocalCenter ()	
	else
		return self.prop2d:getPiv ()
	end
end

function azClassGameObject:getScene ()
	return self.scene
end

function azClassGameObject:getSize ( index )
	if index == nil then
		return self.width, self.heigh
	else
		if index == 'x' or index == 1 then
			return self.width
		elseif index == 'y' or index == 2 then
			return self.heigh
		end
	end
end

function azClassGameObject:getSizeImage ()
	return self.texture:getSize ()
end

function azClassGameObject:getAngle ()
	if self.body.shape ~= nil then
		return self.body.shape:getAngle ()
	else
		return self.prop2d:getRot ()
	end
end

function azClassGameObject:setAngle ( angle )
	if self.body.shape ~= nil then
		local x, y = self:getPos ()
		self.body.shape:setTransform ( x, y, angle )
	else
		self.prop2d:setRot ( angle )
	end
end

function azClassGameObject:setSize ( width, heigh ) 
	self.width = width 
	self.heigh = heigh
	if self.particle == nil then
		self.deck:setRect ( - ( width / 2 ), - ( heigh / 2 ), ( width / 2 ), ( heigh / 2 ) )
	end
end

function azClassGameObject:setScale ( sclx, scly )
	if self.body.shape ~= nil then

	end
	local large, heigh = self:getSize ()
	if scly == nil then scly = sclx end
	self:setSize ( large + ( large * sclx ), heigh + ( heigh * scly ) )
end

function azClassGameObject:setFlip ( direction )
	if self.body.shape ~= nil and self.body.polygon.have then
	
	end

	local x, y = self:getProp ():getScl () 
	if direction == 'left' then
		self:getProp ():setScl ( 1, y)
	elseif direction == 'right' then
		self:getProp ():setScl ( -1, y )
	elseif direction == 'up' then
		self:getProp ():setScl ( x, -1 )
	elseif direction == 'down' then
		self:getProp ():setScl ( x,  1 )
	end
end

function azClassGameObject:priorityIncrease ( thing )
	self.prop2d:setPriority ( thing:getPriority () + 1 )
end

function azClassGameObject:priorityDecrease ( thing )
	self.prop2d:setPriority( thing:getPriority () - 1 )
end

function azClassGameObject:colorCompare ( colorA, colorB )
	if colorA ~= nil and colorB ~= nil then
		if colorA [ 1 ] ~= nil and colorB [ 1 ] ~= nil and colorA [ 2 ] ~= nil and colorB [ 2 ] ~= nil and
		   colorA [ 3 ] ~= nil and colorB [ 3 ] ~= nil and colorA [ 4 ] ~= nil and colorB [ 4 ] ~= nil then
			if colorA [ 1 ] == colorB [ 1 ] and colorA [ 2 ] == colorB [ 2 ] and
			   colorA [ 3 ] == colorB [ 3 ] and colorA [ 4 ] == colorB [ 4 ] then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

-- [[ gameObject inGame functions ]]
function azClassGameObject:addPos ( _x, _y )
	local x, y = self:getPos ()
		if self.emitter ~= nil then
		self.emitter:setLoc ( x + _x, y + _y )
	else
		for id, tmp in pairs ( self.parents ) do
				if not tmp:getRemove () then
					local difX, difY = tmp:getPos ()
					tmp:setPos ( _x + difX - x, _y + difY - y )
				end
			end
		self:setPos ( x + _x, y + _y )
	end
end

function azClassGameObject:setPos ( x, y )
	if self.emitter ~= nil then
		self.emitter:setLoc ( x, y )
	else
		local oldX, oldY = self:getPos ()
		for id, tmp in pairs ( self.parents ) do
			if not tmp:getRemove () then
				local difX, difY = tmp:getPos ()
				tmp:setPos ( x + difX - oldX, y + difY - oldY )
			end
		end

		if self.body.shape ~= nil then
			self.body.shape:setTransform ( x, y, self.body.shape:getAngle () )
		else
			self.prop2d:setLoc ( x, y )
		end
	end
end

function azClassGameObject:getPos ( value )
	if self.body.shape ~= nil then
		local x, y = self.body.shape:getPosition ()
		if value == nil then
			return x, y
		elseif value == 1 or value == 'x' then
			return x
		elseif value == 2 or value == 'y' then
			return y
		end	
	end
	if value == nil then
		if self.emitter ~= nil then
			return self.emitter:getLoc ()
		else
			return self.prop2d:getLoc ()
		end
	elseif value == 1 or value == 'x' then
		if self.emitter ~= nil then
			local x, y = self.emitter:getLoc ()
			return x
		else
			local x, y = self.prop2d:getLoc ()
			return x
		end
	elseif value == 2 or value == 'y' then
		if self.emitter ~= nil then
			local x, y = self.emitter:getLoc ()
			return y
		else
			local x, y = self.prop2d:getLoc ()
			return y
		end
	end
end

function azClassGameObject:moveToPos ( x, y, time, onFinish )
	local oldX, oldY = self:getPos ()
	for id, tmp in pairs ( self.parents ) do
		if not tmp:getRemove () then
			local difX, difY = tmp:getPos ()
			tmp:moveToPos (x - oldX, y - oldY, time )
		end
	end
	local action = nil
	if self.emitter ~= nil then
		action = self.emitter:moveLoc (x - oldX, y - oldY,0, time )
	else
		action = self.prop2d:moveLoc (x - oldX, y - oldY, time )
	end
	if onFinish ~= nil then
		action:setListener ( MOAIAction.EVENT_STOP, onFinish )
	end
end

-- [[ propriety inGame functions ]]
function azClassGameObject:setPause ( state )
	self.paused = state
end

function azClassGameObject:setStatic ( state )
	self.scene:setThingStatic ( self, state )
end

function azClassGameObject:getPause ()
	return self.paused
end

function azClassGameObject:getRemove ()
	return self.removed	
end

function azClassGameObject:getStatic ()
	return self.static
end

function azClassGameObject:particleStart ()
	if self.emitter ~= nil then
		self.emitter:start ()
	end
end

function azClassGameObject:particlePause ()
	if self.emitter ~= nil then
		self.emitter:pause ()
	end
end

function drawColisionCircle ()
	if MOAIDraw ~= nil then
		MOAIGfxDevice.setPenColor ( 1, 0, 0, 1 )
		MOAIDraw.fillCircle ( 0, 0, 64, 32 )
	else
		print ("fail")
	end
end

-- [[create box and chipmunk]]
local function newBodyData ( gameObject )
	
	if gameObject.bodyInfo.shape == nil then
		gameObject.bodyInfo.shape = {
			box     = nil,
			circle  = nil,
			polygon = nil
		}
	end

	if gameObject.bodyInfo.filter == nil then
		gameObject.bodyInfo.filter = {
			box     = nil,
			circle  = nil,
			polygon = nil
		}
	else
		if gameObject.bodyInfo.filter.box == nil then
			gameObject.bodyInfo.filter.box = nil
		end
		if gameObject.bodyInfo.filter.circle == nil then
			gameObject.bodyInfo.filter.circle = nil
		end
		if gameObject.bodyInfo.filter.polygon == nil then
			gameObject.bodyInfo.filter.polygon = nil
		end
	end

	if gameObject.bodyInfo.mask == nil then
		gameObject.bodyInfo.mask   = {
			box     = nil, 
			circle  = nil, 
			polygon = nil
		}
	else
		if gameObject.bodyInfo.mask.box == nil then
			gameObject.bodyInfo.mask.box = nil
		end
		if gameObject.bodyInfo.mask.circle == nil then
			gameObject.bodyInfo.mask.circle = nil
		end
		if gameObject.bodyInfo.mask.polygon == nil then
			gameObject.bodyInfo.mask.polygon = nil
		end
	end

	if gameObject.bodyInfo.type 	   == nil then gameObject.bodyInfo.type 	    = "dynamic"	 end	
	if gameObject.bodyInfo.sensor	   == nil then gameObject.bodyInfo.sensor 	    = false	     end	
	if gameObject.bodyInfo.mass 	   == nil then gameObject.bodyInfo.mass	        = 100 	     end
	if gameObject.bodyInfo.density 	   == nil then gameObject.bodyInfo.density      = 100 	     end
	if gameObject.bodyInfo.restitution == nil then gameObject.bodyInfo.restitution  = 100 	 	 end
	if gameObject.bodyInfo.friction    == nil then gameObject.bodyInfo.friction 	= 100 	 	 end
end

local function setBodyData ( gameObject, bodyDate, newFixture)
	newFixture.thingEnv = gameObject


	newFixture:setDensity     ( bodyDate.density/100     )
	newFixture:setRestitution ( bodyDate.restitution/100 )
	newFixture:setFriction    ( bodyDate.friction/100 	 )
	newFixture:setSensor      ( bodyDate.sensor 		 )
	gameObject.body.box.shape = newFixture
end

function azClassGameObject:createBodyBox     ( data )
	newBodyData ( self )
	local newFixture = nil
	local bodyDate   = self.bodyInfo
	if data == nil then
		local width, height = self:getSize ()
		newFixture = self.body.shape:addRect (-(width/2), -(height/2), (width/2), (height/2))
		self.body.box.shape = newFixture
	else
		newFixture = self.body.shape:addRect ( data[1], data[2], data[3], data[4] )
		self.body.box.shape = newFixture
	end
	setBodyData   ( self, bodyDate, newFixture )
end

function azClassGameObject:createBodyCircle  ( data )
	newBodyData ( self )
	local bodyDate    = self.bodyInfo
	if data[2] == nil then data[2] = 0 data[3] = 0 end
	if data[3] == nil then data[3] = 0 end
	local newFixture  = self.body.shape:addCircle ( data[2], data[3], data[1] )
	self.body.circle.shape = newFixture
	setBodyData   ( self, bodyDate, newFixture )
end

function azClassGameObject:createBodyPolygon ( data )
	newBodyData ( self )
	local bodyDate = self.bodyInfo
	local newFixture  = self.body.shape:addPolygon ( data )
	self.body.polygon.shape = newFixture
	setBodyData   ( self, bodyDate, newFixture )
end

function azClassGameObject:setBodyFilter ( bodyDate )
	if bodyDate.filter ~= nil and bodyDate.mask ~= nil then
		if self.body.box ~= nil and self.body.box.shape ~= nil then
			if bodyDate.filter.box ~= nil and bodyDate.mask.box ~= nil then
				self.body.box.shape:setFilter ( bodyDate.filter.box , bodyDate.mask.box )
			elseif bodyDate.filter.box ~= nil then
				self.body.box.shape:setFilter ( bodyDate.filter.box )
			elseif bodyDate.mask.box ~= nil then
				self.body.box.shape:setFilter ( bodyDate.mask.box )
			end
		end
		if self.body.circle ~= nil and self.body.circle.shape ~= nil then
			if bodyDate.filter.circle ~= nil and bodyDate.mask.circle ~= nil then
				self.body.circle.shape:setFilter ( bodyDate.filter.circle , bodyDate.mask.circle )
			elseif bodyDate.filter.circle ~= nil then
				self.body.circle.shape:setFilter ( bodyDate.filter.circle )
			elseif bodyDate.mask.circle ~= nil then
				self.body.circle.shape:setFilter ( bodyDate.mask.circle )
			end
		end
		if self.body.polygon ~= nil and self.body.polygon.shape ~= nil then
			if bodyDate.filter.polygon ~= nil and bodyDate.mask.polygon ~= nil then
				self.body.polygon.shape:setFilter ( bodyDate.filter.polygon , bodyDate.mask.polygon )
			elseif bodyDate.filter.polygon ~= nil then
				self.body.polygon.shape:setFilter ( bodyDate.filter.polygon )
			elseif bodyDate.mask.polygon ~= nil then
				self.body.polygon.shape:setFilter ( bodyDate.mask.polygon )
			end
		end
	end
end

local function collisionType ( event )
	if event == MOAIBox2DArbiter.BEGIN then
       return "collision BEGIN"
	end
	if event == MOAIBox2DArbiter.END then
       return "collision END"
	end
	if event == MOAIBox2DArbiter.PRE_SOLVE then
       return "collision PRE_SOLVE"
	end
	if event == MOAIBox2DArbiter.POST_SOLVE then
       return "collision POST_SOLVE"
	end
end

-- [[collision box and chipmunk]]]]
function azClassGameObject:createBodyCollision ()

	if self.body.box.collision == nil then
		self.body.box.collision = { }
	end

	local collisions = self.body.box.collision

	if not self.body.box.onCollision then
		self.body.box.onCollision = true
		self.body.box.shape:setCollisionHandler (
			function ( event, colliding, collided, arbiter )
				local funcs = collisions.things [ collided.thingEnv ]
				if funcs ~= nil and not collided.thingEnv:getRemove () then
					for _, func in ipairs ( funcs ) do
						func ( colliding.thingEnv, collided.thingEnv, collisionType ( event ) )
					end
				end
				for _, func in ipairs ( collisions.global ) do
					func ( colliding.thingEnv, collided.thingEnv, collisionType ( event ) )
				end
				local thingsToRemove = { }
				for curThing, _ in pairs ( collisions.things ) do
					if curThing:getRemove () then
						table.insert ( thingsToRemove, curThing )
					end
				end
				for _, curThing in ipairs ( thingsToRemove ) do
					collisions.things [ curThing ] = nil
				end
			end, MOAIBox2DArbiter.ALL 
		)
	end
end

function azClassGameObject:bodyCollide ( collidingFunc )
	self:createBodyCollision ()
	local collisions = self.body.box.collision
	if collisions.things == nil then
		collisions.things = { }
	end
	if collisions.global == nil then
		collisions.global = { }
	end
	
	table.insert ( collisions.global, collidingFunc )
end

-- [[apply function box and chipmunk]]]]
function azClassGameObject:applyAngularImpulse ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:applyAngularImpulse ( value * azCoreGame:meterPerPixel () )
	end
end

function azClassGameObject:applyForce ( valueX, valueY, pointX, pointY )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:applyForce ( valueX * azCoreGame:meterPerPixel (), valueY * azCoreGame:meterPerPixel (), pointX, pointY  )
	end
end

function azClassGameObject:applyLinearImpulse ( valueX, valueY, pointX, pointY  )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:applyLinearImpulse ( valueX, valueY, pointX, pointY  )
	end
end

function azClassGameObject:applyTorque ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:applyTorque ( value )
	end
end

function azClassGameObject:getAngularVelocity ()
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:getAngularVelocity ()
	end
end

function azClassGameObject:getInertia ()
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:getInertia ()
	end
end

function azClassGameObject:getLinearVelocity ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		local x, y = self.body.shape:getLinearVelocity ()
		if value == nil then
			return x, y
		elseif value == "x" or value == 1 then
			return x
		elseif value == "y" or value == 2 then
			return y
		end
	end
end

function azClassGameObject:getLocalCenter ()
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:getLocalCenter ()
	end
end

function azClassGameObject:getMass ()
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:getMass ()
	end
end

function azClassGameObject:getWorldCenter ()
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:getWorldCenter ()
	end
end

function azClassGameObject:getFilter ( type )
	-- //fazer
end

function azClassGameObject:getFixture ( type )
	-- //fazer
end

function azClassGameObject:getGravityScale ()
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:getGravityScale ()
	end
end

-- [[set function box and chipmunk]]]]
function azClassGameObject:setActive ( bool )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setActive ( bool )
	end
end

function azClassGameObject:setAngularDamping ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setAngularDamping (value )
	end
end

function azClassGameObject:setAngularVelocity ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setAngularDamping ( value )
	end
end

function azClassGameObject:setAwake ( bool )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setAwake ( bool )
	end
end

function azClassGameObject:setBullet ( bool )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setBullet ( bool )
	end
end

function azClassGameObject:setDensity ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:setDensity    ( value/100 )
		if self.bodyInfo ~= nil then
			self.bodyInfo.density = value
		end
	end
end

function azClassGameObject:setFixedRotation ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setFixedRotation ( value )
	end
end

function azClassGameObject:setFilter ( filter, mask, list, type )
-- //fazer
end

function azClassGameObject:setFriction ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:setFriction    ( value/100 )
		if self.bodyInfo ~= nil then
			self.bodyInfo.friction = value
		end
	end
end

function azClassGameObject:setGravityScale ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setGravityScale ( value )
	end
end

function azClassGameObject:setLinearDamping ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setLinearDamping ( value )
	end
end

function azClassGameObject:setLinearVelocity ( valueX, valueY )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setLinearVelocity ( valueX, valueY )
	end
end

function azClassGameObject:setMassData ( mass, I, centerX, centerY )
	if self.body ~= nil and self.body.shape ~= nil then
		return self.body.shape:setMassData ( mass, I, centerX, centerY )
	end
end

function azClassGameObject:setRestitution ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:setRestitution    ( value/100 )
		if self.bodyInfo ~= nil then
			self.bodyInfo.restitution = value
		end
	end
end

function azClassGameObject:setSensor ( value )
	if self.body ~= nil and self.body.shape ~= nil then
		self.body.shape:setSensor ( value )
	end
end

-- [[destroy function box and chipmunk]]]]
function azClassGameObject:destroyBody ()
	if self.body.shape ~= nil then
		self.body.shape:destroy ()
	end
	if self.body.box ~= nil then
		if self.body.box.shape ~= nil then
			self.body.box.shape:destroy ()
		end
	end
	if self.body.circle ~= nil then
		if self.body.circle.shape ~= nil then
			self.body.circle.shape:destroy ()
		end
	end
	if self.body.polygon ~= nil then
		if self.body.polygon.shape ~= nil then
			self.body.polygon.shape:destroy ()
		end
	end
end

-- getSize
-- getFilter
-- getFixture
-- setFilter
-- setScale
-- setPos