azCoreImages = {}
local debugPrintIdenfitifer = {}

local function azLoadImage ( image )
	if image.texture == nil then
		if image.pixelMap then 
			image.texture = MOAIImage.new ()
		else
			image.texture = MOAITexture.new ()
			if MOAIEnvironment.osBrand == "Windows" or MOAIEnvironment.osBrand == "OSX" then
				image.texture:setFilter ( MOAITexture.GL_LINEAR_MIPMAP_NEAREST )
			else 
				image.texture:setFilter ( MOAITexture.GL_LINEAR )
			end
		end
		image.texture:load ( 'project/'.._Project..'/resources/images/' .. image.fileName )
		image.modificationTime = getFileLastModificationTime ( 'project/'.._Project..'/resources/images/' .. image.fileName )
	end
	local tileRect
	if image.size ~= nil then
		tileRect = MOAITileDeck2D.new ()
		tileRect:setTexture ( image.texture )
		tileRect:setSize ( image.size.colluns, image.size.lines )
	else
		tileRect = MOAIGfxQuad2D.new ()
		tileRect:setTexture ( image.texture )
	end
	return tileRect, image.texture
end

local function azLoadConfig ()
	local config = {}
	extends ( config, azCoreGlobal.coreFunctions )
	doFileSandbox ( config, 'project/'.._Project..'/resources/images/configImages.lua' )
	azCoreImages.configModificationTime = getFileLastModificationTime ( 'project/'.._Project..'/resources/images/configImages.lua' )
	azCoreImages.images = config.images
end

azLoadConfig ()

local function azCheckImageConfigChange () --incompleto
	local configModificationTime = getFileLastModificationTime ( 'project/'.._Project..'/resources/images/configImages.lua' )
	if configModificationTime <= azCoreImages.configModificationTime then 
		return 
	end
	azCoreImages.configModificationTime = configModificationTime
	print ( "Update: images/configImages.lua" ) --Fazer um debugDraw interno
	local newConfig = {}
	extends ( newConfig, azCoreGlobal.coreFunctions )
	doFileSandbox ( newConfig, 'project/'.._Project..'/resources/images/configImages.lua' )
	for newName, newImageConfig in pairs ( newConfig.images ) do
		local oldConfig = azCoreImages.images [ newName ]
		if oldConfig == nil then
			azCoreImages.images [ newName ] = newImageConfig
			azLoadImage ()
		else
			if oldConfig.fileName ~= newImageConfig.fileName then
				oldConfig.texture:load ( 'project/'.._Project..'/resources/images/' .. newImageConfig.fileName )
				oldConfig.fileName = newImageConfig.fileName
			end
			local newX, newY = nil, nil
			if oldConfig.size ~= nil and newImageConfig.size ~= nil then
				if oldConfig.size.x ~= newImageConfig.size.x or oldConfig.size.y ~= newImageConfig.size.y then
					newX, newY = newImageConfig.size.x, newImageConfig.size.y
				end
			elseif oldConfig.size == nil and newImageConfig.size ~= nil then
				newX,newY = newImageConfig.size.x, newImageConfig.size.y
			elseif oldConfig.size ~= nil and newImageConfig.size == nil then
				newX, newY = 1, 1
			end
			oldConfig.size = newImageConfig.size
			if newX ~= nil then
				for _, thing in ipairs ( azCoreGame:gatherAllThings () ) do
					if thing:getTexture () == oldConfig.texture then
						local thingDimentions = thing:getDimentions ()
						local dec, tex = loadImage ( newName, oldConfig )
						thing:setDeck ( dec, tex )
						thing:setDimentions ( thingDimentions.width, thingDimentions.heigh )
					end
				end
			end
		end
	end
end

local function azCheckImagesChanged ()
	for _, image in pairs ( azCoreImages.images ) do
		local modificationTime = getFileLastModificationTime ( 'project/'.._Project..'/resources/images/' .. image.fileName )
		if image.modificationTime ~= nil and modificationTime > image.modificationTime then
			if MOAIEnvironment.osBrand == "Windows" or MOAIEnvironment.osBrand == "OSX" then
				image.texture:setFilter ( MOAITexture.GL_LINEAR_MIPMAP_NEAREST )
			else 
				image.texture:setFilter ( MOAITexture.GL_LINEAR )
			end
			image.texture:load ( 'project/'.._Project..'/resources/images/' .. image.fileName )
			image.modificationTime = modificationTime
		end
	end
end

function azCoreImages:checkReload ()
	azCheckImageConfigChange ()
	azCheckImagesChanged ()
end

function azCoreImages:cleanUp ()
	for _, image in ipairs ( self.images ) do
		image.texture = nil
	end
	self.images = nil
end

function azCoreImages:getDeck ( identifier )
	if azCoreGame:getDebugUsefulActive () then
		if debugPrintIdenfitifer [ identifier ] == nil then
			debugPrintIdenfitifer [ identifier ] = true
			print ( "Loading img: " .. identifier )
		end
	end
	local image = self.images [ identifier ]
	if image == nil then
		print ( 'getDeck img not found: ' .. tostring ( identifier ) )
		return nil
	end
	return azLoadImage ( image )
end

function azCoreImages:getSize ()
	if self.image.texture ~= nil then
		return self.image.texture:getSize ()
	else
		print ( "Error: Image not getSize" )
		return nil
	end
end