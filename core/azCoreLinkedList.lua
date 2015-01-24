azCoreLinkedList = {}
local azClassLinkedList = {}
local azClassNode       = {}

function azCoreLinkedList.new ()
	local newLinkedList = { 
		size  = 0,
		first = nil,
		last  = nil
	}
	setmetatable ( newLinkedList, { __index = azClassLinkedList } )
	return newLinkedList
end

function azClassNode:setNextNode ( node )
	self.nextNode = node
end

function azClassNode:setPrevNode ( node )
	self.prevNode = node
end

function azClassNode:getNextNode ()
	return self.nextNode
end

function azClassNode:getPrevNode ()
	return self.prevNode
end

function azClassNode:getValue ()
	return self.value
end

function createNode ()
	local node = { 
		nextNode = nil,
		prevNode = nil,
		value    = nil
	}
	setmetatable ( node, { __index = azClassNode } )
	return node
end

function azClassLinkedList:addSize ( value )
	self.size = self.size + value
end

function azClassLinkedList:setFirstNode ( node )
	self.first = node
end

function azClassLinkedList:setLastNode ( node )
	self.last = node
end

function azClassLinkedList:getSize ()
	return self.size
end

function azClassLinkedList:getFirstNode ()
	return self.first
end

function azClassLinkedList:getLastNode ()
	return self.last
end

function lpairs ( l )
	local curNode = nil
	return function ()
		if curNode == nil then
			curNode = l:getFirstNode ()
		else
			curNode = curNode:getNextNode ()
		end
		if curNode ~= nil then
			return curNode:getValue ()
		end
	end
end

function azClassLinkedList:insertIf ( value, func )
	if self:getSize () == 0 then
		self:pushBack ( value )
		return
	end
	local inserted = false
	local curNode  = self:getFirstNode ()
	while curNode ~= nil do 
		if func ( value, curNode:getValue () ) then
			local isFirst = curNode == self:getFirstNode ()
			local newNode = createNode ()
			newNode.value = value
			newNode:setNextNode ( curNode )
			local curNodePrevNode = curNode:getPrevNode ()
			newNode:setPrevNode ( curNodePrevNode )
			if curNodePrevNode ~= nil then
				curNodePrevNode:setNextNode ( newNode )
			end
			curNode:setPrevNode ( newNode )
			if isFirst then self:setFirstNode ( newNode ) end
			self:addSize ( 1 )
			inserted = true
			break
		end
		curNode = curNode:getNextNode ()
	end
	if not inserted then
		self:pushBack ( value )
	end
end

function azClassLinkedList:popFront ()
	if self:getSize () == 0 then
		return
	end
	local firstNode = self:getFirstNode ()
	local nextToFirstNode = firstNode:getNextNode ()
	if nextToFirstNode ~= nil then
		nextToFirstNode:setPrevNode ( nil )
		self:setFirstNode ( nextToFirstNode )
	else
		self:setFirstNode ( nil )
		self:setLastNode ( nil )
	end
	self:addSize ( -1 )
	return self:getFirstNode ()
end

function azClassLinkedList:pushBack ( value )
	local node = createNode ()
	node.value = value
	if self:getSize () == 0 then
		self:setLastNode ( node )
		self:setFirstNode ( node ) 
	else
		local exLastNode = self:getLastNode ()
		exLastNode:setNextNode ( node )
		node:setPrevNode ( exLastNode )
		self:setLastNode ( node )
	end
	self:addSize ( 1 )
end

function azClassLinkedList:remove ( value )
	if self:getSize () == 0 then
		return false
	end
	local curNode = self:getFirstNode ()
	while curNode ~= nil do 
		if value == curNode:getValue () then
			if curNode == self:getFirstNode () then
				self:popFront ()
				return true
			elseif curNode == self:getLastNode () then
				local lastNode = self:getLastNode ()
				local prevLastNode = lastNode:getPrevNode ()
				prevLastNode:setNextNode ( nil )
				self:setLastNode ( prevLastNode )
				lastNode:setPrevNode ( nil )
			else
				local curPrevNode = curNode:getPrevNode ()
				local curNextNode = curNode:getNextNode ()
				curPrevNode:setNextNode ( curNextNode )
				curNextNode:setPrevNode ( curPrevNode )
				curNode:setPrevNode ( nil )
				curNode:setNextNode ( nil )
			end
			self:addSize ( -1 )
			return true
		end
		curNode = curNode:getNextNode ()
	end
	return false
end