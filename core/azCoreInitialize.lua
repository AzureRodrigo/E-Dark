azCoreInitialize = {}

function azCoreInitialize.initialize ()
	local data = {}

	extends ( data, azCoreGlobal.coreFunctions )

	data.G     = azCoreGame:getGlobalTable ()
	data.Color = azCoreGame:getColorTable  ()
	data.Bit   = azCoreGame:getBitTable	   ()
	
	for _, fileName in ipairs ( listFiles ( 'project/'.._Project..'/initialize' ) ) do
		if fileName:find ( ".lua" ) ~= nil then
			doFileSandbox ( data, 'project/'.._Project..'/initialize/' .. fileName )
		end
	end
end