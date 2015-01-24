azCoreText = {}
local azClassText = {}

function azCoreText.new ( text, width, height, size, fontName, color )
	local newText = {
		text 	= text,
		textbox = MOAITextBox.new (),
		layerId = 0,
		removed = false,
		scene   = nil, 
		static  = false,
		font    = font,
		color   = color,
		visible = true
	}
	extends( newText, azClassText )

	newText.font = azCoreFonts:getFont ( azCoreGame:getDefaultFontName () ) 
	if fontName ~= nil then
		newText.font = azCoreFonts:getFont ( fontName )
	end

	if color == nil then
		color = "ffffff"
	end

	newText.textbox:setString ( '<c:'..color..'>'..text..'</>' )
	newText.textbox:setFont (newText.font)
	
	if size ~= nil then
		newText.textbox:setTextSize ( size.height )
	end

	newText.textbox:setRect ( -width / 2, -height / 2, width / 2, height / 2)
	newText.textbox:setYFlip ( true )
	newText.textbox:setAlignment ( 1 , 1 )
	return newText
end

function azClassText:newTag ( size, color, font )
    local tag = MOAITextStyle.new ()
    if font == nil then
    	font = self.font
    end
    tag:setFont(font)
    if size ~= nil then
    	tag:setSize(size.height)
	end
	if color ~= nil then
		if color.a == nil then
			color.a = 1
		end
	    tag:setColor ( color.r, color.g, color.b, color.a )
	end
	return tag 
end

local function chooseAlignment ( alignment )
	if alignment == 'center' then
		return MOAITextBox.CENTER_JUSTIFY
	elseif alignment == 'left' then
		return MOAITextBox.LEFT_JUSTIFY
	elseif alignment == 'right' then
		return MOAITextBox.RIGHT_JUSTIFY
	elseif alignment == 'up' then
		return MOAITextBox.LEFT_JUSTIFY
	elseif alignment == 'down' then
		return MOAITextBox.RIGHT_JUSTIFY
	end
end

function azClassText:setStatic ( state )
    self.scene:setTextStatic ( self, state )
end

function azClassText:setText ( text )
	local large, height = self:getBoxSize ()
	self.textbox:setString ( text )
end

function azClassText:getBoxSize ()
	local x, y, xI, yI = self.textbox:getRect ()	
	return math.abs ( x ) + math.abs ( xI ) , math.abs ( y ) + math.abs ( yI)
end

function azClassText:setSize ( size ) -- ??????
	self.textbox:setTextSize ( size, 72 )
end

function azClassText:setTag ( name, tag ) -- ?????
	self.textbox:setStyle ( name, tag )
end

function azClassText:setPos ( x, y )
	self.textbox:setLoc ( x, y )
end

function azClassText:moveToPos ( x, y, time, onFinish )
	local action = self.textbox:moveLoc (x, y, 0, time )
	if onFinish ~= nil then
		action:setListener ( MOAIAction.EVENT_STOP, onFinish )
	end
end

function azClassText:setVisible ( visible )
	self.visible = visible
	if not self.visible then
		self.textbox:setReveal ( 0 )
	else
		self.textbox:revealAll ()
	end
end

function azClassText:getVisible ()
	return self.visible
end

function azClassText:setAlignment ( hAlignment, vAlignment )
    self.textbox:setAlignment ( chooseAlignment ( hAlignment ), chooseAlignment ( vAlignment ) )
end

function azClassText:setSelect ( color )
	label = "<c:"..color..">"..self.text.."</>"
	self:setText ( label )
end

function azClassText:setUnSelect ()
	label = "<c:"..self.color..">"..self.text.."</>"
	self:setText ( label )
end
function azClassText:showCaracters ( id )
	self.textbox:setReveal ( id )
end

function azClassText:getStatic ()
	return self.static
end

function azClassText:getProp ()
	return self.textbox
end

function azClassText:getPos ( x, y )
	return self.textbox:getLoc ()
end 

function azClassText:addPos ( x, y )
	local locX, locY = self.textbox:getLoc ()
	self.textbox:setLoc ( x + locX, y + locY )
end

function azClassText:getRemove ()
	return self.removed
end

function azClassText:remove ()
	if self.scene ~= nil then
		self.scene:removeText (self)
	end
end