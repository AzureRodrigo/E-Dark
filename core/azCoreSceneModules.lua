azCoreSceneModules = {}
local azCoreSceneModuleClass = {}
local EVENT_UPDATE_MILE = 16.6666667

local function azGetPath () 
	return 'project/'.._Project..'/scenes/' 
end

local function azCheckSceneSyntax ( scene )
	if scene.onStart == nil then
		return false
	end
	return true
end

function azCoreSceneModuleClass:executeNextFrameEvents ()
	local ret = 0
	if self.nextFrameEvents [ 1 ] ~= nil then
		local events = {}
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

function azCoreSceneModuleClass:addEvent ( time, func )
	if azCoreGame:getDebugEventsActive () then
		local info = debug.getinfo ( 2 )
		self.scene:addModuleEventDebugCounter ( self, info.short_src .. ":" .. info.currentline )
	end
	if type ( func ) ~= 'function' then
		error ( 'Invalid function to addEvent.' )
		return
	end
	if self.removed then
		error ( "Trying to add event to a removed module." )
		return
	end
	self.eventCounter = self.eventCounter + 1
	if time == nil then
		self.nextFrameEvents [ #self.nextFrameEvents + 1 ] = { func = func, addedTime = getTime () }
	else
		if self.executingEvents then
			time = time - self.eventDelayCorrection
		end
		if self.executingEvents and self.eventTicks + time <= self.eventTicks then
			self.delayedEvents:pushBack ( { time = self.eventTicks + time, func = func, eventId = self.eventIdCounter } )
		else
			local frame = self.currentFrame + math.max ( 1, math.ceil ( time / EVENT_UPDATE_MILE ) )
			local frameChunk = self.events [ frame ]
			if frameChunk == nil then
				frameChunk = { }
				self.events [ frame ] = frameChunk
			end
			frameChunk [ #frameChunk + 1 ] = { time = self.eventTicks + time, func = func }
		end
	end
end

function azCoreSceneModuleClass:setPause ( state )
	self.paused = state
end

function azCoreSceneModuleClass:thinkEvents ()
	local executedEvents = 0
	local currentFrame = self.currentFrame - math.floor ( ( self.eventTicks - self.lastUpdatedEvents) / EVENT_UPDATE_MILE )
	local maxFrame = self.currentFrame
	while currentFrame <= maxFrame do
		local events = self.events [ currentFrame ]
		if events ~= nil then
			self.executingEvents = true
			for i = 1, #events do
				local event = events [ i ]
				self.eventDelayCorrection = self.eventTicks - event.time
				event.func ()
				executedEvents = executedEvents + 1
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
		executedEvents = executedEvents + 1
		self.eventCounter = self.eventCounter - 1
	end
	self.delayedEvents =azCoreLinkedList.new ()
	return executedEvents
end

function azCoreSceneModuleClass:loopEvent ( interval, func )
	if interval < 16 then
		interval = 16
	end
	self.loopFunctions:pushBack ( { func = func, interval = interval, intervalToActive = 0, nextEvent = interval } )
end

function azCoreSceneModuleClass:executeLoopFunctions ( timePassed )
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

function azCoreSceneModuleClass:internalUpdate ( time )
	self.eventTicks = self.eventTicks + time
	self.currentFrame = self.currentFrame + 1
	self.scene:setExecutingModuleName ( self.name )
	local start = getTime ()
	local ret = self:executeNextFrameEvents ()
	if not self.removed then
		ret = self:thinkEvents ()
	end
	if not self.removed then
		return ret + self:executeLoopFunctions ( time )
	end
	self.eventTicks = self.eventTicks - ( getTime () - start )
	return ret
end

function azCoreSceneModuleClass:addEventCoroutine ( time, func )
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

function azCoreSceneModuleClass:addEventLoop ( interval, func )
	if type ( func ) ~= 'function' then
		error ( 'loopFunction is not a func' )
		return
	end
	if interval < 16 then
		interval = 16
	end
	self.loopFunctions:pushBack ( { func = func, interval = interval, intervalToActive = 0, nextEvent = interval } )
	self:addEvent ( interval, func )
end

function azCoreSceneModuleClass:getPause ()
	return self.paused
end	

function azCoreSceneModuleClass:remove ()
	if self.removed then
		error ( "Trying to remove and already removed module." )
		return
	end
	self:cleanUp ()
end

function azCoreSceneModuleClass:cleanUp ()
	self.events = nil
	self.nextFrameEvents = nil
end	

function azCoreSceneModules.createSceneModule ()
	local newSceneMod = {
		paused 				 = false,
		events 				 = { },
		loopFunctions   	 =azCoreLinkedList.new (),
		eventTicks      	 = 0,
		removed         	 = false,
		name            	 = 'unknown?',
		delayedEvents   	 =azCoreLinkedList.new (),
		executingEvents 	 = false,
		eventDelayCorrection = 0,
		eventCounter         = 0,
		currentFrame         = 0,
		lastUpdatedEvents    = 0,
		nextFrameEvents      = { }
	}
	extends ( newSceneMod, azCoreSceneModuleClass )
	extends ( newSceneMod, azCoreGlobal.coreFunctions )
	return newSceneMod
end

function azCoreSceneModules:loadScene ( name, params, setGameScene )
	local files = findAllFilesFromFolder ( 'project/'.._Project..'/scenes/' .. name, ".lua" )
	for _, file in ipairs ( files ) do
		cacheFileText ( file )
	end
	local scene       = azCoreScene.new ()
	scene.scene       = scene
	scene.name        = name
	scene.game        = azCoreGame
	scene.file        = azCoreDataManager
	scene.global      = scene.global
	scene.billing     = azCoreBilling
	scene.tools 	  = azCoreTools
	scene.g 		  = scene.global
	scene.G 		  = azCoreGame:getGlobalTable ()
	scene.Color		  = azCoreGame:getColorTable  ()
	scene.Bit 	      = azCoreGame:getBitTable    ()
	scene.sceneParams = params
    if setGameScene then
        scene.game.mainScene = scene
    end
	if fileExist ( azGetPath () .. name .. "/config.lua" ) then
		doFileSandbox ( scene, azGetPath () .. name .. "/config.lua" )
		if scene.preLoadImages ~= nil then
			for _, identifier in ipairs ( scene.preLoadImages ) do
				g_images:getDeck ( identifier )
			end
		end
	end
	for _, fileName in ipairs ( listFiles ( azGetPath () .. name ) ) do
		if fileName:find ( ".lua" ) ~= nil and fileName:find ( "config.lua" ) == nil then
			doFileSandbox ( scene, azGetPath () .. name .. "/" .. fileName )
		end
	end
	return scene
end