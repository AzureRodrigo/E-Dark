azCoreTools = {}

function azCoreTools.readWholeFile ( path )
	local file = io.open ( path, "r" )
    local content = file:read ( "*all" )
    file:close ()
    return content
end

function azCoreTools.loadXmlFile ( path )
	return MOAIXmlParser.parseString ( azCoreTools.readWholeFile ( path ) )
end

function azCoreTools.getTime ()
	return getTime ()
end