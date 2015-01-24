_Project                       = "magicCat"
--[[ Variables ]]
local fileCaches               = {}
local loopingCheckFiles        = false
local loopingFiles             = {}
local loopingCache             = {}
local listLibrary              = {}
local collisionBodyBoxColor    = { { .7, .5, .7, 1 }, { .8, .6, .8, 1 } }
local collisionBodyCircleColor = { { .5, .8, .5, 1 }, { .4, .7, .4, 1 } }
--[[ Functions ]]

math.randomseed ( os.time() )

function cacheFileText ( path )
    textCache = azCoreTools.readWholeFile ( path )
    fileCaches [ path ] = textCache
end

function runInMySandbox ( env, func, ... )
  local oldenv = getfenv ( 0 )
  setfenv ( func, env )
  setfenv ( 0, env )
  local rets = { func ( ... ) }
  setfenv ( 0, oldenv )
  return env
end

function doFileSandbox ( env, path, ... )
    return runInMySandbox ( env, function ( ... ) 
        local _function = loadfile ( path )
        if _function ~= nil then
            _function ( ... )
        else
            print ( 'error', path )
            callWithDelay ( 10000, RESTART )
        end
    end, ... )
end

doFileSandbox ( _G, 'core/azCoreGlobal.lua' )
doFileSandbox ( _G, 'core/azCoreFunctions.lua' )
local config = {}
extends ( config, azCoreGlobal.coreFunctions )
doFileSandbox ( config, 'project/'.._Project..'/config/configGame.lua' )

doFileSandbox ( _G, 'core/azCore.lua' )
_G.initialize ()
MOAILogMgr.setLogLevel(MOAILogMgr.LOG_ERROR)
azCoreGame:setConfig (config)


MOAISim.openWindow ( config.viewConfig.title, config.viewConfig.size.width, config.viewConfig.size.height )

viewport = MOAIViewport.new ()
viewport:setScale ( config.viewConfig.scale.width, config.viewConfig.scale.height )
viewport:setSize (MOAIEnvironment.horizontalResolution, MOAIEnvironment.verticalResolution)

-- viewport:setOffset(1, 1)
-- viewport:setRotation(-90)

local layers = { }

local camera = MOAICamera2D.new ()
for i = 1, config.projectConfig.maxLayers + 1 do
    local newLayer = MOAILayer2D.new ()
    newLayer:setViewport ( viewport )
    newLayer:setCamera ( camera )
    partition = MOAIPartition.new ()
    partition:reserveLevels ( 3 )
    partition:setLevel ( 1, 256, 4, 4  )
    partition:setLevel ( 2, 128, 8, 8  )
    partition:setLevel ( 3, 96, 12, 12 )
    newLayer:setPartition ( partition )
    table.insert ( layers, newLayer )
end

azCoreGame:setLayers ( layers )
azCoreGame:addCamera ( camera )

MOAIRenderMgr.setRenderTable(layers)

if MOAIInputMgr.device.keyboard then
    MOAIInputMgr.device.keyboard:setCallback ( function ( ... ) azCoreGame:keyboard ( ... ) end )
end

thread = MOAIThread:new ()

 thread:run (
        function ()
            local lastTime = getTime ()
            local game     = azCoreGame
            local bonusUp  = 0
            game:onStart ( config.projectConfig.openScene )
            while game.running do
                coroutine.yield ()
                game:update ( 17 )

            -- if ( MOAIMoviePlayer ~= nil and player == nil) then
            --     MOAIMoviePlayer.init ( "http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1211/sample_iTunes.mov" ) -- Another sample video "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
            --     MOAIMoviePlayer.play ()
            --      player = true
            -- end
                local currentTime = getTime ()
                local updateTime  = currentTime - lastTime
                lastTime = currentTime
                bonusUp = bonusUp + updateTime - 16

                if ( bonusUp >= 16  ) then
                    game:update ( 16 )
                    bonusUp = bonusUp - 16
                end

                if game.shouldRestart then
                    return
                end

            end
            game:onExit ()
            os.exit ()
        end
)

if MOAIInputMgr.device.pointer then
    local isMousePress       = false
    local isMouseLeftPress   = false
    local isMouseRightPress  = false
   
    MOAIInputMgr.device.mouseLeft:setCallback (
        function ( isMouseDown )
            azCoreGame:internalClickPress ( isMouseDown, "left" )
            if isMouseDown then
                isMousePress     = true
                isMouseLeftPress = true
            else
                isMousePress     = false
                isMouseLeftPress = false
            end
        end
    )
    MOAIInputMgr.device.mouseRight:setCallback (
        function ( isMouseDown )
            azCoreGame:internalClickPress ( isMouseDown, "right" )
            if isMouseDown then
                isMousePress      = true
                isMouseRightPress = true
            else
                isMousePress      = false
                isMouseRightPress = false
            end
        end
    )
    MOAIInputMgr.device.pointer:setCallback ( 
        function ( mouseX, mouseY )
            if ( mouseX <= 0 or mouseY <= 0 ) or ( mouseX >= config.viewConfig.size.width or mouseY >= config.viewConfig.size.height ) then
                isMousePress = false
            end
            if isMousePress then
                azCoreGame:internalClickMove ( true, isMouseLeftPress, isMouseRightPress )
            else
                azCoreGame:internalClickMove ( false, isMouseLeftPress, isMouseRightPress )
            end
        end
    ) else


    MOAIInputMgr.device.level:setCallback ( function ( ... ) azCoreGame:accelerometer ( ... ) end )
    MOAIInputMgr.device.touch:setCallback ( function ( ... ) azCoreGame:touch ( ... ) end )
end

MOAISim.setTraceback ( azCoreGame.onError )

-- if azCoreGame:isDebugLinesActive() then
    -- function onDraw()
    --     local scenes = azCoreGame:getScenes()
    --     local x, y = camera:getLoc()
    --     local screenX = azCoreGame:getWidth()
    --     local screenY = azCoreGame:getHeight()

    --     for _, scene in ipairs(scenes) do
    --         for _, thing in ipairs(scene:getThingsEnvFromRect(x - (screenX / 2), y + (screenY / 2), x + (screenX / 2), y - (screenY / 2))) do
    --             if thing.onDraw ~= nil then
    --                 thing.onDraw()
    --             end
    --         end
    --     end
    -- end

    -- scriptDeck = MOAIScriptDeck.new ()
    -- scriptDeck:setRect ( -64, -64, 64, 64 )
    -- scriptDeck:setDrawCallback ( onDraw )

    -- prop = MOAIProp2D.new ()
    -- prop:setDeck ( scriptDeck )
    -- layers[5]:insertProp ( prop )
-- end
