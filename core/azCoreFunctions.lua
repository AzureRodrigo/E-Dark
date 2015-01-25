local oldPrint = print

function extends ( base, derived )
	for name, func in pairs ( derived ) do
		base [ name ] = func
	end
end

function findAllFilesFromFolder ( basePath, regex )
	local ret = { }
	local function searchFolder ( searchingPath )
		for _, filePath in ipairs ( listFiles ( searchingPath ) ) do
			if filePath:find ( regex ) ~= nil then
				table.insert ( ret, searchingPath .. "/" .. filePath )
			end
		end
		for _, folder in ipairs ( listFolders(searchingPath ) ) do
			searchFolder ( searchingPath .. "/" .. folder )
		end
	end
	searchFolder ( basePath )
	return ret
end

function print ( ... )
	oldPrint ( ... )
	io.flush ()
end

function getTime ()
	return MOAISim.getDeviceTime() * 1000.0
end

function listFolders ( ... )
	local ret = MOAIFileSystem.listDirectories ( ... )
	if ret == nil then
		ret = {}
	end
	for _, name in ipairs ( ret ) do
		ret [ _ ] = name:gsub ( "/", "" )
	end
	return ret 
end

function listFiles ( ... )
	local ret = MOAIFileSystem.listFiles ( ... )
	if ret == nil then
		ret = {}
	end
	for _, name in ipairs ( ret ) do
		ret [ _ ] = name:gsub ( "/", "" )
	end
	return ret 
end

function getWorkingDirectory ()
	local path = MOAIFileSystem.getWorkingDirectory ()
	return path:sub ( 1, path:len () - 1 )
end

function fileExist ( path )
	local f = io.open ( path, "r" )
	if f ~= nil then
		f:close ()
		return true
	end
	return false
end

function copyTable ( destination, source )
	for key, value in pairs ( source ) do
		destination [ key ] = value
	end
end

function getFileLastModificationTime ( path )
	if MOAIFileSystem.getFileLastModificationTime == nil then
		return 0
	end
	return MOAIFileSystem.getFileLastModificationTime ( path )
end

function wait ( time )
	return coroutine.yield ( time )
end

function callWithDelay ( delay, func, ... )
	local timer = MOAITimer.new ()
	timer:setSpan ( delay / 1000.0 )
	timer:setListener ( MOAITimer.LOOP,
		function ()
		  timer:stop ()
		  timer = nil
		  func ()
		end )
	timer:start ()
end

function table.dump ( t, depth )
    if not depth then depth = 0 end
    for k, v in pairs ( t ) do
        str = ( ' ' ):rep ( depth * 2 ) .. k .. ': '

        if type ( v ) ~= "table" then
            print ( str .. tostring ( v ) )
        else
            print ( str )
        end
        if type ( v ) == "table" then
            table.dump ( v, depth+1 )
        end
    end
end

function table.find ( _table, var )
	for id, curVar in ipairs ( _table ) do
		if curVar == var then
			return id
		end
	end
	return 0
end

function table.findAndRemove ( _table, value )
	for id, object in ipairs ( _table ) do
		if object == value then
			table.remove ( _table, id )
			return true
		end
	end
	return false
end

function table.priorityInsert ( _table, value, test )
	local inserted = false
	for id, tableValue in ipairs ( _table ) do
		if test (value, tableValue ) then
			table.insert ( _table, id, value )
			inserted = true
			break
		end
	end
	if not inserted then
		table.insert ( _table, value )
	end
end

function calcDist ( objI, objII, type )
	local x1,y1 = objI:getPos ()
	local x2,y2 = objII:getPos ()
	if type then
		return math.sqrt ( math.pow ( x2 - x1, 2 ) ), math.sqrt ( math.pow ( y2 - y1, 2 ) )
	else
		return math.sqrt ( math.pow ( x2 - x1, 2 ) + math.pow ( y2-y1, 2 ))
	end
end

function calcMidDist ( objI, objII )
	local xI, yI   = objI:getPos ()
	local xII, yII = objII:getPos ()
	return math.sqrt ( math.pow ( xII - xI, 2 ) + math.pow ( yII - yI, 2 ))
end

function isAbove ( objI, objII )
	return objI:getPos ("y") > objII:getPos ("y")
end

function lookAt ( objI, objII )
    local medX = objII:getPos ("x") - objI:getPos ("x")
    local medY = objII:getPos ("y") - objI:getPos ("y")
	return - math.deg (math.atan2 ( medX, medY ))	
end

function lookAtPos ( objI, objII )
    local medX = objII[1] - objI:getPos ("x")
    local medY = objII[2] - objI:getPos ("y")
	return - math.deg (math.atan2 ( medX, medY ))	
end

function lookAtMouse ( pos, objII )
    local medX = pos.x - objII:getPos ("x")
    local medY = pos.y - objII:getPos ("y")
	return - math.deg (math.atan2 ( medX, medY ))	
end

function limitScreenOff ( obj, limitSize, side )
	local size = obj:getSize ( "x" ) / 2
	local pos  = obj:getPos  ( "x" )
	local limit = -240
	if limitSize ~= nil then
		limit = -limitSize
	end
	if side ~= nil then
		limit = 240
		if ( pos - size ) > limit then
			return true
		end
	end

	if ( pos + size ) < limit then
		return true
	end

	return false	
end

function colorIsEqual ( tableColorA, tableColorB )
	if tableColorA ~= nil and tableColorB ~= nil then
		if tableColorA.r ~= nil and tableColorA.g ~= nil and tableColorA.b ~= nil and tableColorA.a ~= nil and 
		   tableColorB.r ~= nil and tableColorB.g ~= nil and tableColorB.b ~= nil and tableColorB.a ~= nil then
		   	if tableColorA.r == tableColorB.r and tableColorA.g == tableColorB.g and 
		   	   tableColorA.b == tableColorB.b and tableColorA.a == tableColorB.a then
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

local function decToHex(IN)
	local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
	while IN>0 do
    	I=I+1
    	IN,D=math.floor(IN/B),math.fmod(IN,B)+1
    	OUT=string.sub(K,D,D)..OUT
	end
	return OUT
end

function rgbToHex(r,g,b)
	local output = decToHex(r) .. decToHex(g) .. decToHex(b);
	return output
end

function hexToRgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end