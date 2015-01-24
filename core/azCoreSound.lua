azCoreSound          = {}
local azClassSound   = {}
local azGroupType    = "sound"
local debugMessenger = {
	type       = "AzCoreSound ERRO:",
	errorLoad  = "O audio que não foi iniciado corretamente é",
	removed    = "Impossivel executar o comando pois o audio foi removido",
	errorI     = "Impossivel executar o comando [",
	errorII    = "], pois a thing não é do grupo sound",
	play       = "play",
	pause      = "pause",
	stop       = "stop",
	setVolume  = "setVolume",
	setLoop    = "setLoop",
	getVolume  = "getVolume",
	getPlay    = "getPlay",
	fadeEffect = "fadeEffect",
}

local function azLoadConfig ()
	local path = 'project/'.._Project..'/resources/sounds/configSound.lua'
	local config = {}
	extends ( config, azCoreGlobal.coreFunctions )
	doFileSandbox ( config, path )
	azCoreSound.sounds = config.sounds
end

azLoadConfig ()

local function errorPrint ( type, name )
	if ( type == "loadArchive" ) then
		print ( "###"..debugMessenger.type.." - "..debugMessenger.errorLoad..":"..name.."###")
	elseif ( type == "removed" ) then
		print ( "###"..debugMessenger.type.." - "..debugMessenger.removed.."###")
	else
		print ( "###"..debugMessenger.type.." - "..debugMessenger.errorI..debugMessenger [type]..debugMessenger.errorII.."###")
	end
end

local function groupType ( thing )
	if thing.groupType == azGroupType then
		return true
	end
	return false
end

function azCoreSound.start ()
	if MOAIUntzSystem ~= nil then
		MOAIUntzSystem.initialize ()
	else
		print ( "Sound system not loaded." )
	end
end

function azCoreSound.new ( name )
	local soundChunk = azCoreSound.sounds [ name ]
	if soundChunk == nil then
		print ( "Sound: " .. name .. " not found." )
		return nil
	end

	local newSound = {
		sound     = nil,
		volume    = 100,
		type      = "BgSound",
		loop      = false,
		removed   = false,
		groupType = azGroupType,
		ray		  = 0,
		body	  = nil,
		target    = nil,
		update    = false,
	}

	if MOAIUntzSystem ~= nil then
		newSound.sound = MOAIUntzSound.new ()
		newSound.sound:load ( 'project/'.._Project..'/resources/sounds/' .. soundChunk.fileName )

		newSound.sound:setVolume ( 1.0 )

		if soundChunk.loop then
			newSound.loop = true
			newSound.sound:setLooping ( true )
		end

		if newSound.sound == nil then
			newSound.removed = true;
			errorPrint ( "loadArchive", name )
		end
		print ( "som adicionado com sucesso: "..name )
	else
		print ( "azCoreSound não foi iniciado" )
	end

	extends ( newSound, azClassSound )
	
	return newSound
end

function azClassSound:getGroupType ()
	return self.groupType		
end

function azClassSound:play ( volume )
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			if volume then
				self.sound:setVolume ( 1.0 * ( volume / 100.0 ) )
			end
			self.sound:play ()
		end
	else
		errorPrint ( "play" )
	end
end

function azClassSound:pause ()
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			self.sound:pause ()
		end
	else
		errorPrint ( "pause" )
	end
end

function azClassSound:stop ()
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			self.sound:stop ()
		end
	else
		errorPrint ( "stop" )
	end
end

function azClassSound:setVolume ( volume )
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			self.sound:setVolume ( ( volume / 100 ) )
		end
	else
		errorPrint ( "setVolume" )
	end
end

function azClassSound:setLoop ( state )
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			self.sound:setLooping ( state )
		end
	else
		errorPrint ( "setLoop" )
	end
end

function azClassSound:getVolume () 
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			return self.sound:getVolume ()
		end
	else
		errorPrint ( "getVolume" )
		return 0
	end
end

function azClassSound:getPlay ()
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			return self.sound:isPlaying ()
		end
	else
		errorPrint ( "getPlay" )
		return false
	end
end

function azClassSound:addVolume ( volume )
	local volume =  ( self:getVolume () + volume ) * 100
	if volume < 100 then
		self:setVolume ( volume )
	else
		volume = 100
		self:setVolume ( volume )
	end
end

function azClassSound:subVolume ( volume )
	local volume =  ( self:getVolume () - volume ) * 100
	if volume > 0.0 then
		self:setVolume ( volume )
	else
		volume = 0
		self:setVolume ( volume )
	end
end

function azClassSound:fadeEffect ( effect, time, func, type )
	if time == nil then
		time = 300
	else
		time = time / 10
	end
	if groupType ( self ) then
		if self.removed then
			errorPrint ( "removed" )
		else
			if ( effect == "in" ) then --"up"
				local soundIncrement = ( 1.0 - self:getVolume () ) / 10
				for i = 1, 10 do
					azCoreGame:addEvent( i * ( time ), function () 
						self:addVolume ( soundIncrement )
						if i == 10 then
							if type == "stop" then
								self:stop ()
							elseif type == "pause" then
								self:pause ()
							end
							if func ~= nil then
								func ()
							end
						end
					end )
				end
			else
				local soundIncrement = self:getVolume () / 10
				for i = 1, 10 do
					azCoreGame:addEvent( i * ( time ), function () 
						self:subVolume ( soundIncrement )
						if i == 10 then
							if type == "stop" then
								self:stop ()
							elseif type == "pause" then
								self:pause ()
							end
							if func ~= nil then
								func ()
							end
						end
					end )
				end
			end
		end
	else
		errorPrint ( "fadeEffect" )
	end
end

function azClassSound:setWorldData ( ray, body, target, type )
	self.type   = type
	self.ray    = ray * azCoreGame:meterPerPixel ()
	self.body	= body 
	self.target = target
	self.update = true

	local high = calcMidDist ( self.body ,self.target )	
	if self.type == "x" then
		high = math.abs ( self.body:getPos ( "x" ) - self.target:getPos ( "x" ) )
	elseif self.type == "y" then
		high = math.abs ( self.body:getPos ( "y" ) - self.target:getPos ( "y" ) )
	end

	local max = math.ceil (100 - (high * 100)/ self.ray)
	if max > 0 and max < 100 then
		if not self:getPlay () then
			self:play ()
		end
		self:setVolume ( max )
	elseif max > 100 then
		self:setVolume ( 100 )
	else
		self:setVolume ( 0 )
		if self:getPlay () then
			self:stop ()
		end
	end
end

function azClassSound:soundUpdate ( time )
	local high = calcMidDist ( self.body ,self.target )	
	if self.type == "x" then
		high = math.abs ( self.body:getPos ( "x" ) - self.target:getPos ( "x" ) )
	elseif self.type == "y" then
		high = math.abs ( self.body:getPos ( "y" ) - self.target:getPos ( "y" ) )
	end

	local max = math.ceil (100 - (high * 100)/ self.ray)
	if max > 0 and max < 100 then
		if not self:getPlay () then
			self:play ()
		end
		self:setVolume ( max )
	elseif max > 100 then
		self:setVolume ( 100 )
	else
		self:setVolume ( 0 )
		if self:getPlay () then
			self:stop ()
		end
	end
end