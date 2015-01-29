azCoreScene = {}
local azSceneClass = {}

function azCoreScene.new ()
	
	local newScene = { 
		systemBg = nil,
		things 	                 = azCoreLinkedList.new (),
		updatingThings           = azCoreLinkedList.new (),
		moduleEnvs               = {},
		globalModules            = {}, 
		global                   = {},
		staticThings             = {},
		texts                    = {},
		staticTexts              = {},
		sounds                   = {},
		particles                = {},
		thingExecutedEvents      = 0,
		eventTicks               = 0,
		moduleEnvsExecutedEvents = 0,
		updateCounter  		     = 0,
		executingModuleName 	 = nil, 
		runningThingEvent        = nil,
		removed                  = false,
		debugEvents 			 = {
			things  = {},
			modules = {}
		}
	}
	extends ( newScene, azSceneClass )
	extends ( newScene, azCoreGlobal.coreFunctions )
	return newScene
end

function azSceneClass:internalAdd ( thing, layerId, x, y )
	if thing.placed == true then
		print ( "gameObjects " .. thing:getDescription() .. " is already added." )
		return
	end

	thing.placed   = true
	thing.layerId  = layerId
	local bodyData = thing.bodyInfo

	if bodyData ~= nil then
		local world = azCoreGame:getBox2DWorld ()
		bodyType  = MOAIBox2DBody.DYNAMIC
		if bodyData.type == "kinematic" then
			bodyType  = MOAIBox2DBody.KINEMATIC
		elseif bodyData.type == "static" then 
			bodyType = MOAIBox2DBody.STATIC 
		end
		body = world:addBody ( bodyType, x, y )
		if bodyData.mass == nil then bodyData.mass = 100 end
		body:resetMassData ()
		body:setMassData ( bodyData.mass, 100 )
		thing:getProp ():setParent ( body )
		thing.body.shape = body
		if bodyData.shape == nil then
			thing:createBodyBox ( nil )
		else
			if bodyData.shape.box == nil and bodyData.shape.circle == nil and bodyData.shape.polygon == nil then
				thing:createBodyBox ( nil )	
			else
				if bodyData.shape.box     ~= nil then thing:createBodyBox     ( bodyData.shape.box     ) end
				if bodyData.shape.circle  ~= nil then thing:createBodyCircle  ( bodyData.shape.circle  ) end
				if bodyData.shape.polygon ~= nil then thing:createBodyPolygon ( bodyData.shape.polygon ) end
			end
		end
		thing:setBodyFilter ( bodyData )
		thing:setPos ( x, y )
	else
		thing:setPos ( x, y )
	end
	
	thing:setSize( thing:getSize() )
	if thing.particle then
		azCoreGame:getLayer(layerId):insertProp ( thing.system )
	else
		azCoreGame:getLayer(layerId):insertProp( thing:getProp() )
	end
	
	thing:internalOnAdd ()

end

function azSceneClass:internalStart ()
	if self.setVariables ~= nil then
		self.setVariables ()
	end

	if self.setModules ~= nil then
		self.setModules ()
	end

	if self.setGameObjects ~= nil then
		self.setGameObjects ()
	end

	for _, modulo in ipairs ( self.moduleEnvs ) do
		if modulo.onStart ~= nil then
			modulo.onStart ()
		end
	end
	-- for thing in lpairs(self.things) do
	-- 	if thing.onStart ~= nil then
	-- 		thing.onStart ()
	-- 	end
	-- 	if thing.onCollision ~= nil then
	-- 		thing:bodyCollide ( thing.onCollision )
	-- 	end
	-- end
end

function azSceneClass:internalUpdate ( time )
	local thingsToUpdate = azCoreLinkedList.new ()
	local thingToRemove  = {}
	local curNode        = self.updatingThings:getFirstNode ()
	while curNode ~= nil do
		local thing = curNode:getValue().thing
		if not thing.paused then
			if (thing.eventCounter > 0 or thing.loopFunctions:getSize() > 0) then
				thingsToUpdate:pushBack(thing)
			else
				table.insert(thingToRemove, thing)
			end
		end
		curNode = curNode:getNextNode()
	end
	for i = 1, #thingToRemove do
		thingToRemove[i]:removeFromUpdateEventList()
	end
	for thing in lpairs(thingsToUpdate) do
		if not thing.removed then
			self.thingExecutedEvents = self.thingExecutedEvents + thing:internalUpdate(time)
		end
	end
	for _, moduleEnv in ipairs(self.moduleEnvs) do
		if not moduleEnv:setPause() then
			self.moduleEnvsExecutedEvents = self.moduleEnvsExecutedEvents + moduleEnv:internalUpdate(time)
		end
	end
	self.updateCounter = self.updateCounter + 1
end

local function executeTouchObject ( object, _eventType, _touchId, objectPos, posScreen, timeTouch )
	if not object:getRemove () and not object:getPause () and object:getVisible () then
		if _eventType == true or _eventType == 0 or _eventType == 1 then
			if object.onTouchDown ~= nil and object.touchPressMove == nil then
				local areaThing = object.onTouchDown ( _touchId, objectPos, posScreen, timeTouch )
				object.touchPressMove = true
				if areaThing ~= nil and areaThing then
					return
				end
			end
			if object.onTouchMove ~= nil and object.touchPressMove ~= nil then
				local areaThing = object.onTouchMove ( _touchId, objectPos, posScreen, timeTouch )
				if areaThing ~= nil and areaThing then
					return
				end
			end
		elseif _eventType == false or _eventType == 2 then
			if object.onTouchUp ~= nil and object.touchPressMove ~= nil then
				local areaThing = object.onTouchUp ( _touchId, objectPos, posScreen, timeTouch )
				object.touchPressMove = nil
				if areaThing ~= nil and areaThing then
					return
				end
			end
		end
	end
end

local function executeTouchScene ( object, _eventType, _touchId, objectPos, posScreen, timeTouch )
	if not object:getPause () then
		if _eventType == true or _eventType == 0 or _eventType == 1 then
			if object.onTouchDown ~= nil and object.touchPressMove == nil then
				local areaThing = object.onTouchDown ( _touchId, objectPos, posScreen, timeTouch )
				object.touchPressMove = true
				if areaThing ~= nil and areaThing then
					return
				end
			end
			if object.onTouchMove ~= nil and object.touchPressMove ~= nil then
				local areaThing = object.onTouchMove ( _touchId, objectPos, posScreen, timeTouch )
				if areaThing ~= nil and areaThing then
					return
				end
			end
		elseif _eventType == false or _eventType == 2 then
			if object.onTouchUp ~= nil then
				local areaThing = object.onTouchUp ( _touchId, objectPos, posScreen, timeTouch )
				object.touchPressMove = nil
				if areaThing ~= nil and areaThing then
					return
				end
			end
		end
	end
end

function azSceneClass:internalTouchControl ( _eventType, _touchId, _x, _y, _tapCount )
	local listLayer      = azCoreGame:getLayers ()
	local posScreen      = { x = _x, y = _y }
	local timeTouch		 = azCoreTools.getTime  ()

	local objectX, objectY = listLayer[1]:wndToWorld ( _x, _y )
	local objectPos  = { x = objectX, y = objectY }
	local touchPress = false

	for id = #listLayer, 1, -1 do
		local listObjects = self:getThingsEnvFromPos  ( objectPos.x, objectPos.y, id, self )
		local allObjects  = self:getThingsEnvFromRect ( -240, -160, 240, 160, id )

		for _, object in ipairs ( listObjects ) do
			if object.onTouchDown ~= nil then
				touchPress = executeTouchObject ( object, _eventType, _touchId, objectPos, posScreen, timeTouch )
			end
		end

		for _, object in ipairs ( allObjects ) do
			if object.touchPressMove then
				touchPress = executeTouchObject ( object, _eventType, _touchId, objectPos, posScreen, timeTouch )
			end
		end
	end

	if touchPress ~= nil then
		for _, object in ipairs ( self.moduleEnvs ) do
			executeTouchScene ( object, _eventType, _touchId, objectPos, posScreen, timeTouch )
		end
	end
end

function azSceneClass:internalClickPress ( bool, direction )
	local x, y = MOAIInputMgr.device.pointer:getLoc ()
	self:internalTouchControl ( bool, direction, x, y )
end

function azSceneClass:internalClickMove ( isMove, isLeft, isRight )
	local x, y = MOAIInputMgr.device.pointer:getLoc ()
	self:internalTouchControl ( isMove, "move", x, y )
end

local function executeAccelerometer ( object, x, y, z )
	if not object:getRemove () and not object:getPause () and object:getVisible () then
		if object.onAccelerometer ~= nil then
			object.onAccelerometer (  x, y, z  )
		end
	end
end

function azSceneClass:internalAccelerometer ( z, x, y )
	local listObjects = azCoreGame:gatherAllThings ()
	for _, object in ipairs ( listObjects ) do
		if object.onAccelerometer ~= nil then
			executeAccelerometer ( object, z, x, y )
		end
	end
end

function azSceneClass:internalKeyboard (  idKey, press )
	print ("tecla: ", idKey, press )
end

function azSceneClass:internalStop ()
	if self.removed then
		print ( "Tring to remove an already removed scene." )
		return
	end
	if self.onStop ~= nil then
		self.onStop ()
	end
	for _, moduleEnv in ipairs ( self.moduleEnvs ) do
		if moduleEnv.onStop ~= nil then
			moduleEnv.onStop ()
		end
	end
	for counter = 1, self.things:getSize () do
		self:remove ( self.things:getFirstNode ():getValue () )
	end
	for counter = 1, #self.texts do
		self:removeText ( self.texts [1] )
	end
	for _, currentMod in ipairs ( self.moduleEnvs ) do
		currentMod:remove ()
	end
	for _, sound in ipairs ( self.sounds ) do
		sound:stop ()
	end
	self.sounds       = nil
	self.global       = nil
	self.tools        = nil
	self.billing      = nil
	self.g            = nil
	self.moduleEnvs   = nil
	self.staticThings = nil
end

function azSceneClass:loadModule ( name, config, layerId )
	local newEnv       = azCoreSceneModules.createSceneModule()
	newEnv.scene       = self
	newEnv.file        = azCoreDataManager
	newEnv.billing     = azCoreBilling
	newEnv.tools       = azCoreTools
	newEnv.game        = azCoreGame
	newEnv.G           = azCoreGame:getGlobalTable ()
	newEnv.Color       = azCoreGame:getColorTable  ()
	newEnv.Bit         = azCoreGame:getBitTable    ()
	newEnv.global      = self.global
	newEnv.g           = self.global
	newEnv.self        = newEnv
	newEnv.sceneParams = params
	newEnv.layerId     = layerId
	newEnv.config      = config
	newEnv.name        = name
	self.executingModuleName = name
	azCoreModules.loadScene ( self.name, name, newEnv )
	table.insert ( self.moduleEnvs, newEnv )
	self.globalModules[name] = newEnv
	self.executingModuleName = nil

	return newEnv
end

function azSceneClass:addModuleEventDebugCounter ( module, funcName )
	local moduleChunk = self.debugEvents.modules[module]
	if moduleChunk == nil then
		moduleChunk = { }
		self.debugEvents.modules[module] = moduleChunk
	end
	local funcChunk = moduleChunk[funcName]
	if funcChunk == nil then
		moduleChunk[funcName] = 0
		funcChunk = 0
	end
	moduleChunk[funcName] = funcChunk + 1
end

function azSceneClass:setExecutingModuleName ( name )
	self.executingModuleName = name
end

function azSceneClass:getExecutingModuleName ()
	return self.executingModuleName
end

function azSceneClass:setPauseLayer ( layerId, state ) -- melhorar
	for thing in lpairs ( self.things ) do
		if thing.layerId == layerId then
			thing:setPause ( state )
		end
	end
	for _, moduleEnv in ipairs ( self.moduleEnvs ) do
		if moduleEnv.layerId == layerId then
			moduleEnv:setPause ( state )
		end
	end
end

function azSceneClass:create ( folder, name, config )
	local thing = azCoreGameObject.new ( folder, name, self.name, self, config )
	if thing == nil then
		error ( "Could not create " .. folder .. ':' .. name .. "." )
		return
	end
	if thing.particle == nil then
		thing:setDeck(azCoreImages:getDeck(thing:getImage()))
		thing:setSize( thing:getSize () )
	else
		azCoreParticle.new( thing.particle.pex , thing )
	end
	self.things:pushBack(thing)
	-- perigo verificar
	thing.scene = self
	thing.scene.name = folder
	thing.folderName = name
	return thing
end

function azSceneClass:createGroup ()
	return azCoreGroup.new()
end

function azSceneClass:addThingEventDebugCounter ( thing, funcName )
	local thingChunk = self.debugEvents.things[thing]
	if thingChunk == nil then
		thingChunk = { }
		self.debugEvents.things[thing] = thingChunk
	end
	local funcChunk = thingChunk[funcName]
	if funcChunk == nil then
		thingChunk[funcName] = 0
		funcChunk = 0
	end
	thingChunk[funcName] = funcChunk + 1
end

function azSceneClass:addThingsPropsToLayers ()
	for thing in lpairs ( self.things ) do
		azCoreGame:getLayer ( thing.layerId ):insertProp ( thing:getProp () )
	end
	for _, text in ipairs ( self.texts ) do
		azCoreGame:getLayer ( text.layerId ):insertProp ( text:getProp () )
	end
end

function azSceneClass:addThingToUpdateList ( thing )
	self.updatingThings:pushBack ( thing )
end


--[[GameObjects functions]] 


function azSceneClass:create ( folder, name, config )
	local thing = azCoreGameObject.new ( folder, name, self.name, self, config )
	if thing == nil then
		error ( "Could not create " .. folder .. ':' .. name .. "." )
		return
	end
	if thing.particle == nil then
		thing:setDeck( azCoreImages:getDeck(thing:getImage()) )
		thing:setSize( thing:getSize () )
	else
		azCoreParticle.new( thing.particle.pex , thing )
	end
	self.things:pushBack(thing)
	thing.scene = self
	thing.scene.name = folder
	thing.folderName = name
	return thing
end

function azSceneClass:loadGameObject ( folder, name, layerId, x, y, config )
	local thing = self:InternalAddGameObject (folder, name, layerId, x, y, config)
		if thing ~= nil then
		thing:addThing ( layerId, x, y )
		return thing
	end
	return 
end

function azSceneClass:addGameObject ( name, layerId, x, y, config )
	local thing = self:InternalAddGameObject (self.name, name, layerId, x, y, config)
	if thing ~= nil then
		thing:addThing ( layerId, x, y )
		return thing
	end
	return 
end

function azSceneClass:InternalAddGameObject (folder, name, layerId, x, y, config )
	return self:create ( folder, name, config )	
end

--[[GameObjects functions]] 


function azSceneClass:addGameObjectStatic (name, layerId, x, y, config )
	local cameraX, cameraY = azCoreGame:getCameraPos ()
	local thing = self:addGameObject ( name, layerId, x, y, config )
	if thing ~= nil then
		thing.static = true
		-- thing:addThing ( layerId, x, y )
		table.insert ( self.staticThings, thing )
	end
	return thing
end

function azSceneClass:setGameObjectStatic ( thing, state )
	if state and not thing:getStatic () then
		thing.static = true
		table.insert ( self.staticThings, thing )
	elseif not state and thing:getStatic () then
		thing.static = false
		if not table.findAndRemove ( self.staticThings, thing ) then
			logLuaError ( "removing static, but failed." )
		end
	end
end

function azSceneClass:getThings ()
	return self.things
end

function azSceneClass:getThingsFromLayer ( layer )
	local ret = {}
	for thing in ipairs ( self.things ) do
		if table.find ( layers, thing.layerId ) ~= 0 then
			table.insert ( ret, thing )
		end 
	end
	return ret
end

function azSceneClass:getThingsEnvFromPos ( x, y, layerId, scene )
local ret = { }
	local layer = azCoreGame:getLayer ( layerId )
	if layer == nil then
		return ret
	end
	local partition = layer:getPartition ()
	if partition == nil then
		return ret
	end
	local props = { partition:propListForPoint ( x, y, 0 ) } 
	for _, prop in ipairs ( props ) do
		if prop.thing ~= nil and ( scene == nil or scene == prop.thing.scene ) then
			table.insert ( ret, prop.thing )
		end
	end
	return ret
end

function azSceneClass:getThingsEnvFromRect ( x1, y1, x2, y2, layers )
	local ret = { }
	local layer = azCoreGame:getLayer ( layers )
	if layer == nil then return ret end
	local partition = layer:getPartition ()
	if partition == nil then return ret end
	local props = { partition:propListForRect ( x1, y1, x2, y2 ) }
	for _, prop in ipairs(props) do
		if prop.thing ~= nil and ( scene == nil or scene == prop.thing.scene ) then
			table.insert ( ret, prop.thing )
		end
	end
	return ret
end

function azSceneClass:getName ()
    return self.name
end

function azSceneClass:addText  ( text, layer, x, y, large, _height, color, scale, font )
	local sizeString = string.len ( text )
	local sizeText   = { 0, 0 }
	if scale == nil then
		fontSize = azCoreFonts:getSize ( font )
		scale = 1
	else
		fontSize = azCoreFonts:getSize ( font )
		fontSize = { width = fontSize.width * scale, height = fontSize.height * scale}
	end

	if ( large ) / fontSize.width - math.floor ( large   / fontSize.width ) < 0.2 * scale then
		sizeText [ 1 ] = math.floor ( ( large) / fontSize.width )
	else
		sizeText [ 1 ] = math.ceil ( ( large) / fontSize.width )
	end
 	sizeText [ 2 ] = math.ceil ( sizeString / sizeText [ 1 ] )
	local height = fontSize.height

	if height >= _height then _height = height + height * 0.3 end
	
	if fontSize.width > large then large = fontSize.width end
	if color == nil then color = "ffffff" end
	local textBox = azCoreText.new(text, large, _height, fontSize, font, color)
	if textBox ~= nil then
		textBox.textbox:setLoc ( x, y )
		textBox.layerId = layer
		textBox.scene   = self
		azCoreGame:getLayer ( layer ):insertProp ( textBox.textbox )
		table.insert ( self.texts, textBox )
	end
	return textBox
end

function azSceneClass:addTextStatic ( ... )
	local textBox = self:addText ( ... )
	if textBox ~= nil then
		textBox.static = true
		table.insert ( self.staticTexts, textBox )
	end
	return textBox
end

function azSceneClass:setTextStatic ( text, state )
	if state and not text:getStatic () then
		text.static = true
		table.insert ( self.staticTexts, text )
	elseif not state and text:getStatic () then
		text.static = false
		if not table.findAndRemove ( self.staticTexts, text ) then
			logLuaError ( "removing static, but failed." )
		end
	end
end

function azSceneClass:removeText ( textBox )
	if textBox.removed then
		error ( "Trying to remove an already removed text." )
		return
	end
	for _, currentTextbox in ipairs ( self.texts ) do
		if currentTextbox == textBox then
			azCoreGame:getLayer ( textBox.layerId ):removeProp ( textBox.textbox )
			table.remove ( self.texts, _ )
			break
		end
	end
	if textBox.static then
		for _, currentTextbox in ipairs ( self.staticTexts ) do
			if currentTextbox == textBox then
				table.remove ( self.staticTexts, _ )
				break
			end
		end
	end
end

function azSceneClass:addSound ( name )
	local sound = azCoreSound.new ( name )
	if sound ~= nil then
		table.insert ( self.sounds, sound )
	end
	return sound
end

function azSceneClass:onChangeCameraPos ( oldX, oldY, newX, newY )
	for _, thing in ipairs ( self.staticThings ) do
		local thingLocX, thingLocY = thing:getPos ()
		thing:setPos ( ( thingLocX - oldX ) + newX, ( thingLocY - oldY ) + newY )
	end
	for _, thing in ipairs ( self.staticTexts ) do
		local thingLocX, thingLocY = thing:getPos ()
		thing:setPos ( ( thingLocX - oldX ) + newX, ( thingLocY - oldY ) + newY )
	end
end

function azSceneClass:printDebugData ()
	local amountEvents = 0
	for thing in lpairs(self.things) do
		amountEvents = amountEvents + thing.eventCounter
	end
	local modulesEvents = 0
	for _, moduleEnv in ipairs(self.moduleEnvs) do
		modulesEvents = modulesEvents + moduleEnv.eventCounter
	end
	local debugTextData = azCoreGame:getDebugText()
	local memoryUsage = math.ceil(MOAISim.getMemoryUsage("M").total)
	if azCoreGame:getDebugScreenActive () then

		debugTextData:setAlignment ("left", "center")

		local cA = "<c:ffffff>"
		local cB = "<c:ffff00>"

		debugTextData:setSize (12)
		debugTextData:setText (cA.."Fps:"            .. "#" .. cB .. math.ceil(MOAISim.getPerformance()).. cA .. "\n" ..
								   "Updates:"        .. "#" .. cB .. self.updateCounter .. cA .."\n" ..
								   "Things:"         .. "#" .. cB .. self.updatingThings:getSize() .. cA .. "/" .. cB .. self.things:getSize() .. cA .."\n" ..
								   "Things Events:"  .. "#" .. cB .. self.thingExecutedEvents .. cA .."\n" ..
								   "Modules:"        .. "#" .. cB .. #self.moduleEnvs .. cA .."\n" ..
								   "Modules Events:" .. "#" .. cB .. self.moduleEnvsExecutedEvents .. cA .."\n" ..
								   "Memory:"         .. "#" .. cB .. memoryUsage )
	
	end
	if azCoreGame:getDebugPrintActive() then
		print("Fps: " .. math.ceil(MOAISim.getPerformance()) .. "; updates: " .. self.updateCounter ..  "; things: " .. self.updatingThings:getSize() .. "/" .. self.things:getSize() .. ", events: " .. self.thingExecutedEvents .. "/s; Modules: " .. #self.moduleEnvs .. ", events: " .. self.moduleEnvsExecutedEvents .. "/s \nMem:" .. memoryUsage .. " mb.")
	end
	-- print(MOAIRenderMgr.getPerformanceDrawCount())
	self.updateCounter = 0
	self.thingExecutedEvents = 0
	self.moduleEnvsExecutedEvents = 0
	if azCoreGame:getDebugEventsActive() then
		local global = { }
		for _, thing in pairs(self.debugEvents.things) do
			for funcName, counter in pairs(thing) do
				if global[funcName] == nil then
					global[funcName] = counter
				else
					global[funcName] = global[funcName] + counter
				end
			end
		end
		print("THING EVENTS")
		for name, counter in pairs(global) do
			print(name .. "->" .. counter)
		end
		global = { }
		for _, thing in pairs(self.debugEvents.modules) do
			for funcName, counter in pairs(thing) do
				if global[funcName] == nil then
					global[funcName] = counter
				else
					global[funcName] = global[funcName] + counter
				end
			end
		end
		print("MODULES EVENTS")
		for name, counter in pairs(global) do
			print(name .. "->" .. counter)
		end
		self.debugEvents = {
			things = {
			},
			modules = {
			}
		}
	end
end

function azSceneClass:removeThingToUpdateList ( thing )
	return self.updatingThings:remove ( thing )
end

function azSceneClass:remove ( thing )
	if thing.removed then
		error ( "Trying to remove thing but its already removed." )
		return
	end
	if thing.onRemove ~= nil then
		thing.onRemove()
	end
	thing.removed = true
	self.things:remove ( thing )
	if thing.removeFromUpdateEventList ~= nil then
		thing:removeFromUpdateEventList ( true )
	end
	
	if thing.particle ~= nil then
		azCoreGame:getLayer ( thing.layerId ):removeProp ( thing.system )
	else
		azCoreGame:getLayer ( thing.layerId ):removeProp ( thing:getProp () )
	end
	if thing.cleanUp ~= nil then
		thing:cleanUp ()
	end
	if thing.static then
		for _, staticThing in ipairs(self.staticThings) do
			if staticThing == thing then
				table.remove(self.staticThings, _)
				break
			end
		end
	end

	return
end

-- uhn .....
function azSceneClass:createParticle ( folder, name, config )
	local particle = azCoreParticle.new ( folder, name )
	if particle == nil then
		error("Could not create " .. folder .. ':' .. name .. ".")
		return
	end
	particle.scene = self
	return particle
end