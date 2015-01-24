azCoreGame = {
	scenes      	  = {},
	events      	  = {},
	globalTable 	  = {},
	colorTable  	  = {},
	bitTable          = {},
	mainScene   	  = nil,
	layers      	  = nil,
	camera      	  = nil,
	config      	  = nil,
	debugTextData     = nil,
	box2D       	  = nil,
	ticks	    	  = 0,
	reloadTime  	  = 0,
	isInExecuteEvents = false,
	running           = true,
	started           = false,
	restart           = true
}
local keys = { }

function azCoreGame:loadTextures ( textures )
	for _, texture in ipairs ( textures ) do
		azCoreImages:getDeck ( texture )
	end
end

function azCoreGame:camera2D ()
	if self.camera ~= nil then
		return self.camera
	end
end

function azCoreGame:getOptimization ()
	if not self.started then
		return true
	end
	if self:getMac () then
		return false
	end
	return true
end

function azCoreGame:setConfig ( config )
	self.config = config
end

function azCoreGame:getDefaultFontName ()
	return self.config.projectConfig.defaultFont
end

function azCoreGame:getBox2DWorld ()
	return self.box2D
end

function azCoreGame:getGlobalTable ()
	return self.globalTable
end

function azCoreGame:getColorTable ()
	return self.colorTable
end

function azCoreGame:getBitTable ()
	return self.bitTable
end

function azCoreGame:getKeysPressed ( chars )
	for counter = 1, chars:len () do
		local pressed = keys [ string.byte ( chars:sub ( counter, counter ) ) ]
		if pressed == nil or not pressed then
			return false
		end
	end
	return true
end

function azCoreGame:internalLeftClick ( down )
	if self.mainScene ~= nil then
		self.mainScene:internalLeftClick ( down, 'left' )
	end
	for i = 1, #self.scenes do
		self.scenes [ i ]:internalLeftClick ( down, 'left' )
	end
end

function azCoreGame:internalClickPress ( bool, direction )
	if self.mainScene ~= nil then
		self.mainScene:internalClickPress ( bool, direction)
	end
	for i = 1, #self.scenes do
		self.mainScene:internalClickPress ( bool, direction )
	end
end

function azCoreGame:internalClickMove ( bool, left, right )
	if bool then
		if self.mainScene ~= nil then
			self.mainScene:internalClickMove ( bool, left, right )
		end
		for i = 1, #self.scenes do
			self.scenes [ i ]:internalClickMove ( bool, left, right )
		end
	end
end

function azCoreGame:internalMoveClick ( bool, left, right )
	if bool then
		if self.mainScene ~= nil then
			self.mainScene:internalMoveClick ( bool, left, right )
		end
		for i = 1, #self.scenes do
			self.scenes [ i ]:internalMoveClick ( bool, left, right )
		end
	end
end

function azCoreGame:internalRightClick ( down )
	if self.mainScene ~= nil then
		self.mainScene:internalRightClick ( down, 'right' )
	end
	for i = 1, #self.scenes do
		self.scenes [ i ]:internalRightClick ( down, 'right' )
	end
end

function azCoreGame:purchase ( itemName )
	azCoreBilling.purchase ( itemName )
end

function azCoreGame:onStoreUpdate ( func )
	azCoreBilling.setCallback ( func )
end

local function onBackButtonPressed ()
	local scene = azCoreGame:getScene ()
	if scene ~= nil and scene.onBackButtonPressed ~= nil then
		scene.onBackButtonPressed ()
	end
	return true
end

local function onSessionStart ()
	local scene = g_game:getScene()

	if scene ~= nil and scene.onFocusChanged ~= nil then
		scene.onFocusChanged ()
	end
end

if MOAIApp ~= nil then
	MOAIApp.setListener ( MOAIApp.BACK_BUTTON_PRESSED, onBackButtonPressed )
	local isFocused = true

	if MOAIApp.ON_CHANGE_FOCUS ~= nil then
		local function onFocusChanged ()
			isFocused = not isFocused

			local scene = azCoreGame:getScene ()

			if scene ~= nil and scene.onFocusChanged ~= nil then
				scene.onFocusChanged ( isFocused )
			end
		end

		MOAIApp.setListener ( MOAIApp.ON_CHANGE_FOCUS, onFocusChanged )
	end

	if MOAIAppIOS ~= nil then
		print ( MOAIAppIOS )
		MOAIApp.setListener ( MOAIAppIOS.SESSION_START, onSessionStart )
		MOAIApp.setListener ( MOAIAppIOS.SESSION_END, onSessionStart )
	end
end

local function PriorityTest ( a, b )
	return a.time <= b.time
end

function azCoreGame:addScene ( name, params )
	local scene = azCoreSceneModules:loadScene ( name, params )
	if scene ~= nil then
		print ( "Adding scene: " .. name )
		table.insert ( self.scenes, scene )
		scene:internalStart ()
	else
		error ( "Scene: " .. tostring ( name ) .. " not found." )
	end
end

function azCoreGame:setScene ( scene, shouldStopmainScene )
	if not self.isInExecuteEvents then
		error ( "You must use game:addEvent() to setScene." )
		return
	end
	if self.mainScene ~= nil then
		if shouldStopmainScene == nil or shouldStopmainScene then
			self.mainScene:internalStop ()
		end
	end
	self.mainScene = scene
	scene:addThingsPropsToLayers ()
end

function azCoreGame:getScene ()
	return self.mainScene
end

function azCoreGame:getScenes ()
	local scenes = { }
	for i = 1, #self.scenes do
	    table.insert ( scenes, self.scenes [ i ] )
	end
	table.insert ( scenes, self.mainScene )
	return scenes
end

function azCoreGame:changeScene ( time, name, params, shouldStopmainScene )
	self:addEvent ( time, function ()
		self:switchScene ( name, params, shouldStopmainScene )		
	end)	
end
function azCoreGame:switchScene ( name, params, shouldStopmainScene )
	if not self.isInExecuteEvents then
		error ( "You must use game:addEvent() to changeScene." )
		return
	end
	print ( "Changing scene to:" .. name )
	if self.mainScene ~= nil then		
		if ( shouldStopmainScene == nil or shouldStopmainScene ) then
			self.mainScene:internalStop ()
			--adicionar o fade in
		end
	end
	self.mainScene = azCoreSceneModules:loadScene ( name, params, true )
	if self.mainScene ~= nil then
		--adicionar o fade off
		self.mainScene:internalStart ()
	end	
end

function azCoreGame:removeScene ( name )
	for i, tmp in pairs ( self.scenes ) do 
		if tmp.name == name then
				tmp:internalStop ()
				table.remove ( self.scenes, i )
			return true
		end
	end
end

function azCoreGame:setLayers ( layers )
	self.layers = layers
end

function azCoreGame:getLayer ( layerId )
	return self.layers [ layerId ]
end

function azCoreGame:getLayers ()
	local ret = { }
	for i = 1, self.config.projectConfig.maxLayers do
		ret [ i ] = self:getLayer ( i )
	end
	return ret
end

function azCoreGame:getExtraLayer ()
	return self:getLayer ( self.config.projectConfig.maxLayers + 1 )
end

function azCoreGame:cleanUpLayers ()	
	for i = 1, self.config.projectConfig.maxLayers do
		self:getLayer ( i ):clear ()
	end
end

function azCoreGame:getDebugLinesPsychsActive ()
	if self.config.debugConfig.psychs ~= nil then
		return self.config.debugConfig.psychs
	end
	return false
end

function azCoreGame:getDebugLinesActive ()
	if self.config.debugConfig.lines ~= nil then
		return self.config.debugConfig.lines
	end
	return false
end

function azCoreGame:getDebugPrintActive ()
	if self.config.debugConfig.printing ~= nil then
		return self.config.debugConfig.printing
	end
	return false
end

function azCoreGame:getDebugScreenActive ()
	if self.config.debugConfig.screen ~= nil then
		return self.config.debugConfig.screen
	end
	return false
end

function azCoreGame:getDebugEventsActive ()
	if self.config.debugConfig.events ~= nil then
		return self.config.debugConfig.events
	end
	return false
end

function azCoreGame:getDebugUsefulActive ()
	if self.config.debugConfig.useful ~= nil then
		return self.config.debugConfig.useful
	end
	return false
end

function azCoreGame:getDebugText ()
	return self.debugTextData
end

function azCoreGame:showDebugLines ()
	MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 0, 1, 0 )
	MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 1, 0, 0 )
	MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 2, 0, 0, 1 )
end

function azCoreGame:addCamera ( camera )
	self.camera = camera
end

function azCoreGame:addPosCamera ( x, y )
	local oldX, oldY = self.camera:getLoc ()
	self.camera:setLoc ( oldX + x, oldY + y )
	if self.mainScene ~= nil then
		self.mainScene:onChangeCameraPos ( 0, 0, x, y )
	end
	for i = 1, #self.scenes do
		self.scenes [ i ]:onChangeCameraPos ( 0, 0, x, y )
	end
	if self.debugTextData then
		local textLocX, textLocY = self.debugTextData:getLoc ()
		self.debugTextData:setPos ( textLocX + x, textLocY + y )

	end
end

function azCoreGame:setPosCamera ( x, y )
	local oldX, oldY = self.camera:getLoc ()
	self.camera:setLoc ( x, y )

	if self.debugTextData then
		local textLocX, textLocY = self.debugTextData:getPos ()
		self.debugTextData:setPos ( ( textLocX - oldX ) + x, ( textLocY - oldY ) + y )
	end
	
	if self.mainScene ~= nil then
		self.mainScene:onChangeCameraPos ( oldX, oldY, x, y )
	end
	for i = 1, #self.scenes do
		self.scenes [ i ]:onChangeCameraPos ( oldX, oldY, x, y )
	end
	self.camera:forceUpdate ()
end

function azCoreGame:getCameraPos ( type )
	local x, y =  self.camera:getLoc ()
	if type == nil then
		return x, y
	elseif type == 'x' or type == 1 then
		return x
	elseif type == 'y' or type == 2 then
		return y
	end
end

function azCoreGame:moveToPosCamera ( x, y, time )
	self.camera:seekLoc ( x, y, time / 1000, MOAIEaseType.LINEAR )
end

function azCoreGame:addEvent ( time, func )
	if type ( time ) ~= 'number' then
		error ( 'Invalid time to addEvent.' )
		return
	elseif type ( func ) ~= 'function' then
		error ( 'Invalid function to addEvent.' )
		return
	end
	table.priorityInsert ( self.events, { time = self.ticks + time, func = func }, PriorityTest )
end

function azCoreGame:loopEvent ( interval, func )
	local function f ()
		func ()
		self:addEvent ( interval, f )
	end
	self:addEvent ( interval, f )
end

function azCoreGame:pause ( layerList )
	if self.mainScene ~= nil then
		if layerList == nil then 
			layerList = self.config.projectConfig.layersToPause 
		end
		for _, layerId in ipairs ( layerList ) do
			self.mainScene:setPauseLayer ( layerId, true )
			for i = 1, #self.scenes do
				self.scenes [ i ]:setPauseLayer ( layerId, true )
			end
		end
	end
end

function azCoreGame:unPause ( layerList )
	if self.mainScene ~= nil then
		if layerList == nil then 
			layerList = self.config.projectConfig.layersToPause 
		end
		for _, layerId in ipairs(layerList) do
			self.mainScene:setPauseLayer(layerId, false)
			for i = 1, #self.scenes do
				self.scenes[i]:setPauseLayer(layerId, false)
			end
		end
	end
end

function azCoreGame:getSize ( index )
	if index == 'x' or index == 1 then
		return self.config.screenScale.x
	elseif index == 'y' or index == 2 then
		return self.config.screenScale.y
	else
		return self.config.screenScale.x, self.config.screenScale.y
	end
end

function azCoreGame:getSizeDevice ( index )
	if index == 'x' or index == 1 then
		return MOAIEnvironment.horizontalResolution
	elseif index == 'y' or index == 2 then
		return MOAIEnvironment.verticalResolution 
	else
		return MOAIEnvironment.horizontalResolution, MOAIEnvironment.verticalResolution 
	end
	-- 	if azCoreGame:getIOS () and azCoreGame:getLandscape () then 
	-- 		return MOAIEnvironment.verticalResolution 
	-- 	else
	-- 		return MOAIEnvironment.horizontalResolution
	-- 	end

	-- elseif index == 'y' or index == 2 then
	-- 	if azCoreGame:getIOS () and azCoreGame:getLandscape () then 
	-- 		return MOAIEnvironment.horizontalResolution
	-- 	else
	-- 		return MOAIEnvironment.verticalResolution 
	-- 	end
	-- else
	-- 	if azCoreGame:getIOS () and azCoreGame:getLandscape () then 
	-- 		return MOAIEnvironment.verticalResolution, MOAIEnvironment.horizontalResolution 
	-- 	else
	-- 		return MOAIEnvironment.horizontalResolution, MOAIEnvironment.verticalResolution 
	-- 	end
	-- end
end

-- [[ System ]]
function azCoreGame:getOs ()
	return MOAIEnvironment.osBrand
end

function azCoreGame:getWindows ()
	return self:getOs () == "Windows"
end

function azCoreGame:getOSX ()
	return self:getOs () == "OSX"
end

function azCoreGame:getIOS ()
	return self:getOs () == "iOS"
end

function azCoreGame:getAndroid ()
	return self:getOs () == "Android"
end

function azCoreGame:getLinux ()
	return self:getOs () == "Linux"
end

function azCoreGame:getComputer ()
	return MOAIInputMgr.device.pointer ~= nil
end

function azCoreGame:getLandscape ()
	local state = self.config.projectConfig.landscape
	if state == nil then
		return true
	end
	return state
end

function azCoreGame:gatherAllThings ()
	local things = { }
	if self.mainScene ~= nil then
		for thing in lpairs ( self.mainScene:getThings () ) do
			table.insert ( things, thing )
		end
	end
	for i = 1, #self.scenes do
        local scene = self.scenes [ i ]
		for thing in lpairs ( scene:getThings () ) do
			table.insert ( things, thing )
		end
	end
	return things
end

function azCoreGame.onError ( error )
	for layerId = 1, azCoreGame.config.projectConfig.maxLayers + 1 do
		azCoreGame.layers [ layerId ]:clear ()
	end
end

function azCoreGame:playReload ()
	local playReload = self.config.projectConfig.playReload
	if playReload == nil then
		return false
	end
	return playReload
end

function azCoreGame:checkReloads ()
	azCoreImages:checkReload ()
end
-- [[ System ]]

-- [[ Functions ]]
function azCoreGame:addText ( text, x, y, w, h, size, fontName )
	local layer = self:getExtraLayer ()
	fontSize = azCoreFonts:getSize ( "Anatole" )
	local textBox = azCoreText.new('<c:ff6000>'..text..'</>', w, h, fontSize )
	if textBox ~= nil then
		textBox.textbox:setLoc ( x, y )
		layer:insertProp ( textBox.textbox )
	end
	return textBox
end

function azCoreGame:meterPerPixel ()
	return self.config.worldConfig.meterPerPixel
end

function azCoreGame:onStart ( sceneName )
	self.started = true
	self.box2D = MOAIBox2DWorld.new ()

	self.box2D:setGravity ( self.config.worldConfig.gravityX, self.config.worldConfig.gravityY )
	self.box2D:setUnitsToMeters ( 1/self:meterPerPixel (), 10 )
	if self:getDebugLinesPsychsActive() then
		self.box2D:setDebugDrawFlags (
						MOAIBox2DWorld.DEBUG_DRAW_SHAPES + MOAIBox2DWorld.DEBUG_DRAW_JOINTS +
						MOAIBox2DWorld.DEBUG_DRAW_PAIRS  + MOAIBox2DWorld.DEBUG_DRAW_BOUNDS +
						MOAIBox2DWorld.DEBUG_DRAW_CENTERS )
		self:getExtraLayer ():setBox2DWorld ( self.box2D )
	end
	azCoreSound.start ()
	self:loopEvent ( 1000, function ()
		if self.mainScene ~= nil then
			self.mainScene:printDebugData ()
		end
	end )
	azCoreInitialize.initialize ()
	local files = findAllFilesFromFolder ( 'lib', ".lua" )
	for _, file in ipairs ( files ) do
		cacheFileText ( file )
	end
	self.isInExecuteEvents = true
	self:changeScene ( 1, sceneName )
	self.isInExecuteEvents = false
	if azCoreGame:getDebugScreenActive () then 
		self.debugTextData = self:addText ( "", -171, -100, 130, 110, 1 )
	end
	if self:getDebugLinesActive () then 
		self:showDebugLines ( true ) 
	end
	azCoreBilling.init ()
	self.box2D:start ()
end

function azCoreGame:restart ()
	self.shouldRestart = true
end

function azCoreGame:onExit ()
	if self.mainScene ~= nil then
		self.mainScene:internalStop ()
	end
	for i = 1, #self.scenes do
		self.scenes [ i ]:internalStop ()
	end
	azCoreImages:cleanUp ()
	for _, layer in ipairs ( self.layers ) do
		layer:setCamera ( nil )
	end
	self.layers = nil
	self.camera = nil
	self.events = nil
end

function azCoreGame:exit ()
	self.running = false
end

function azCoreGame:accelerometer ( ... )
	if self.mainScene ~= nil then
		self.mainScene:internalAccelerometer ( ... )
		if self.mainScene.accelerometer ~= nil then
			self.mainScene.accelerometer ( ... )
		end
	end
	for i = 1, #self.scenes do
		local scene = self.scenes [ i ]
		scene:internalAccelerometer ( ... )
		if scene.accelerometer ~= nil then
			scene.accelerometer ( ... )
		end
	end
end

function azCoreGame:touch ( ... )
	if self.mainScene ~= nil then
		self.mainScene:internalTouchControl ( ... )
		if self.mainScene.touch ~= nil then
			self.mainScene.touch ( ... )
		end
	end
	for i = 1, #self.scenes do
		local scene = self.scenes [ i ]
		scene:internalTouchControl ( ... )
		if scene.touch ~= nil then
			scene.touch ( ... )
		end
	end
end

-- function azCoreGame:keyboard ( key, down )
-- keys[key] = down
-- 	if self.mainScene ~= nil and self.mainScene.keyboard ~= nil then
-- 		self.mainScene.keyboard ( key, down )
-- 	end
-- 	for i = 1, #self.scenes do
-- 		local scene = self.scenes[i]
-- 		if scene.keyboard ~= nil then
-- 			scene.keyboard.keyboard(key, down)
-- 		end
-- 	end
-- end

function azCoreGame:keyboard ( ... )
	local id, press = ...
	keys [id] = press
	if self.mainScene ~= nil then
		self.mainScene:internalKeyboard ( id, press )
	end
end


-- UpdateEngine
function azCoreGame:thinkEvents ()
	local eventsCount = #self.events
	if eventsCount == 0 then
		return
	end
	self.isInExecuteEvents = true
	for counter = 1, eventsCount do
		local event = self.events [ 1 ]
		if event == nil then
			break
		end
		if event.time > self.ticks then
			break
		end
		event.func ()
		table.remove ( self.events, 1 )
	end
	self.isInExecuteEvents = false
end

function azCoreGame:update ( time )
	self.ticks = self.ticks + time

	if self.mainScene then
	 	self.mainScene.internalUpdate ( self.mainScene, time )
	end

	--[[ percore listas de indices numérico ]]
	for id, scene in ipairs ( self.scenes ) do
		self.scenes [id].internalUpdate ( scene, time )
	end
	
	local listUpdate	= {}
	local listCollision = {}
	local listDraw		= {}

	for id, tmp in ipairs ( self:gatherAllThings () ) do
		if tmp.onUpdate ~= nil then
			table.insert ( listUpdate, tmp )
		end
		if tmp.onCollision ~= nil then
			table.insert ( listCollision, tmp )
		end
		if tmp.onDraw ~= nil then
			table.insert ( listDraw, tmp )
		end
	end
	for id, tmp in pairs ( listUpdate ) do
		if tmp.onUpdate ~= nil then
			tmp.onUpdate ( time )
		end
	end
	for id, tmp in pairs ( listUpdate ) do
		if tmp.onCollision ~= nil then
			tmp.onCollision ( time )
		end
	end
	for id, tmp in pairs ( listUpdate ) do
		if tmp.onDraw ~= nil then
			tmp.onDraw ( time )
		end
	end
		
	self:thinkEvents ()	

	--//atualizar imagens em tempo real ...
	-- if azCoreGame:getOSX () and azCoreGame:playReload () then
	-- 	self.reloadTime = self.reloadTime + time
	-- 	if self.reloadTime >= 1000 then
	-- 		self.reloadTime = 0
	-- 		azCoreGame:checkReloads ()
	-- 	end
	-- end
end