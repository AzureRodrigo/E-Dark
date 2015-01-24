azCoreParticle = {
	particles = {},
}

local particleClass = {}

local function azLoadConfig ()
	local path = 'project/'.._Project..'/resources/particles/configParticles.lua'
	local config = {}
	extends ( config, azCoreGlobal.coreFunctions )
	doFileSandbox ( config, path )
	azCoreParticle.particles = config.particles
end

azLoadConfig ()

function azCoreParticle.new ( name, part )

	local particleChunk = azCoreParticle.particles [ name ]
	
	if particleChunk == nil then
		print ( "Particle: " .. name .. " not found." )
		return nil
	end
	if part.plugin == nil then
		part.plugin 			 = MOAIParticlePexPlugin.load ( 'project/'.._Project..'/resources/particles/'..particleChunk.fileName )
		maxParticles 			 = part.plugin:getMaxParticles ()
		blendsrc, blenddst 		 = part.plugin:getBlendMode ()		
		minLifespan, maxLifespan = part.plugin:getLifespan ()
		duration 				 = part.plugin:getDuration ()
		xMin, yMin, xMax, yMax   = part.plugin:getRect ()
	end
	if part.system == nil then
		part.system = MOAIParticleSystem.new ()
		part.system._duration = duration
		part.system._lifespan = maxLifespan
		part.system:reserveParticles ( maxParticles , part.plugin:getSize() )
		part.system:reserveSprites ( maxParticles )
		part.system:reserveStates ( 1 )
		part.system:setBlendMode ( blendsrc, blenddst )
	end
	if part.state == nil then
		part.state = MOAIParticleState.new ()
		part.state:setTerm ( minLifespan, maxLifespan )
		part.state:setPlugin(  part.plugin  )
		part.system:setState ( 1, part.state )
	end
	if part.emitter == nil then
		part.emitter = MOAIParticleTimedEmitter.new ()
		part.emitter:setSystem ( part.system )
		part.emitter:setEmission ( part.plugin:getEmission () )
		part.emitter:setFrequency ( part.plugin:getFrequency () )
		part.emitter:setRect ( xMin, yMin, xMax, yMax )
	end
	if part.deck == nil then
		part.deck = azCoreImages:getDeck(part:getImage())
		part.deck:setRect( -0.1, -0.1, 0.1, 0.1 )
		part.system:setDeck( part.deck )
	end
	part.system:start ()
	part.emitter:start ()
end

--[[
<particleEmitterConfig>
  <texture name="texture.png"/>
  <sourcePosition x="300.00" y="300.00"/>
  <sourcePositionVariance x="0.00" y="0.00"/>
  <speed value="72"/>
  <speedVariance value="0"/>
  <particleLifeSpan value="0.5"/>
  <particleLifespanVariance value="0"/>
  <angle value="360.00"/>
  <angleVariance value="360.00"/>
  <gravity x="0" y="0"/>
  <radialAcceleration value="0.00"/>
  <tangentialAcceleration value="0.00"/>
  <radialAccelVariance value="0.00"/>
  <tangentialAccelVariance value="0.00"/>
  <startColor red="0.89" green="0.56" blue="0.36" alpha="1"/>
  <startColorVariance red="0.02" green="0.02" blue="0.02" alpha="0.05"/>
  <finishColor red="0.00" green="0.00" blue="0.00" alpha="0.84"/>
  <finishColorVariance red="0" green="0" blue="0" alpha="0"/>
  <maxParticles value="2000"/>
  <startParticleSize value="0.00"/>
  <startParticleSizeVariance value="0.0"/>
  <finishParticleSize value="60.00"/>
  <FinishParticleSizeVariance value="0.00"/>
  <duration value="0.01"/>
  <emitterType value="0"/>
  <maxRadius value="100.00"/>
  <maxRadiusVariance value="0.00"/>
  <minRadius value="0.00"/>
  <rotatePerSecond value="0.00"/>
  <rotatePerSecondVariance value="0.00"/>
  <blendFuncSource value="770"/>
  <blendFuncDestination value="1"/>
  <rotationStart value="0.00"/>
  <rotationStartVariance value="0.00"/>
  <rotationEnd value="0.00"/>
  <rotationEndVariance value="0.00"/>
</particleEmitterConfig>
]]