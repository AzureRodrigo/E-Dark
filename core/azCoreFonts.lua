azCoreFonts = {
	fonts = {}
}

local function azLoadConfig ()
	local config = {} 
	extends ( config, azCoreGlobal.coreFunctions )
	doFileSandbox ( config, 'project/'.._Project..'/resources/fonts/configFonts.lua' )
	for name, font in pairs ( config.fonts ) do
		local newFont = MOAIFont.new ()
		if font.fileName:find ( ".ttf" ) ~= nil then
			newFont:loadFromTTF ( 'project/'.._Project..'/resources/fonts/' .. font.fileName, font.ascii, font.size.height, font.dpi )
		else
			newFont:loadFromBMFont ( 'project/'.._Project..'/resources/fonts/' .. font.fileName )
		end
		azCoreFonts.fonts [ name ] = newFont
	end
end

azLoadConfig ()

function azCoreFonts:getFont ( name )
	if name == nil then
		name = azCoreGame:getDefaultFontName ()
	end
	local fontChunk = self.fonts [ name ]
	if fontChunk == nil then
		print ( "Font: " .. tostring ( name ) .. " not found." )
		fontChunk = self.fonts [ azCoreGame:getDefaultFontName () ]
	end
	return fontChunk
end

function azCoreFonts:getSize ( name )
	local config = { } 
	extends ( config, azCoreGlobal.coreFunctions )
	doFileSandbox ( config, 'project/'.._Project..'/resources/fonts/configFonts.lua' )

	if name ~= nil then
		return config.fonts [ name ].size
	else
		name = azCoreGame:getDefaultFontName ()
		return config.fonts [ name ].size
	end
end

function azCoreFonts:getDpi ( name )
	local config = { } 
	extends ( config, azCoreGlobal.coreFunctions )
	doFileSandbox ( config, 'project/'.._Project..'/resources/fonts/configFonts.lua' )

	if name ~= nil then
		return config.fonts [ name ].dpi
	else
		name = azCoreGame:getDefaultFontName ()
		return config.fonts [ name ].dpi
	end
end

function azCoreFonts:cleanUp ()
	self.fonts = nil
end