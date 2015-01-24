azCoreModules = {}
local cacheFiles = {}

local function azListGameObjectFiles ( path )
	local cacheChunk = cacheFiles [ path ]
	if cacheChunk ~= nil then
		return cacheChunk
	end
	local gameObjectFiles = {}
	local orderFiles = {}
	for _, gameObjectName in ipairs ( listFiles ( path ) ) do
		if gameObjectName:find ( ".lua" ) ~= nil then
			local characterDist = gameObjectName:find ( "-" )  
			if characterDist ~= nil then
				table.insert ( orderFiles, { order = tonumber ( gameObjectName:sub(1, characterDist - 1 ) ), file = gameObjectName } )
			else
				table.insert ( gameObjectFiles, path .. "/" .. gameObjectName )
			end
		end
	end
	table.sort ( orderFiles, function ( a, b ) return a.order < b.order end )
	for _, file in ipairs ( orderFiles ) do
		table.insert ( gameObjectFiles, path .. "/" .. file.file )
	end
	cacheFiles [ path ] = gameObjectFiles
	return gameObjectFiles
end

local function azGetSceneModule ( sceneName, moduleName )
	local files = azListGameObjectFiles ( 'project/'.._Project..'/scenes/' .. sceneName .. '/coreScene/' .. moduleName )
	if #files ~= 0 then
		return files
	end
	return nil
end

function azCoreModules.loadScene ( sceneName, moduleName, data )
	local parameters = { }
	local moduleFiles = azGetSceneModule ( sceneName, moduleName )
	if moduleFiles == nil then
		print ( "Stage scene module: " .. sceneName .. ":" .. tostring ( moduleName ) .. " not found." )
		return
	end
	local constEnv = { }
	data.const = constEnv
	for _, file in ipairs ( moduleFiles ) do
		doFileSandbox ( data, file, parameters )
	end
end