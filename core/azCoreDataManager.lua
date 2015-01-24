azCoreDataManager = {}
local azCoreMainPath = ( MOAIEnvironment.documentDirectory or "." )

--[[
	"r" read mode (the default);
	"w" write mode;
	"a" append mode;
	"r+" update mode, all previous data is preserved;
	"w+" update mode, all previous data is erased;
	"a+" append update mode, previous data is preserved, writing is only allowed at the end of file.
]]

function azCoreDataManager:save ( type, fileName )
	local serializer = MOAISerializer.new ()
	serializer:serialize ( type )
	local file = io.open ( azCoreMainPath .. "/" .. fileName, 'w' )
	file:write ( string.dump ( loadstring ( serializer:exportToString ( azCoreMainPath .. "/" .. fileName ) ) ) )
	file:close ()
end

function azCoreDataManager:load ( fileName )
	if MOAIFileSystem.checkFileExists ( azCoreMainPath .. "/" .. fileName ) then
		return dofile ( azCoreMainPath .. "/" .. fileName )
	end
	return nil
end