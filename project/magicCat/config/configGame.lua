-- [[ Configurações da View ]]
viewConfig = {
	size   		  = { width = 960, height = 640 },
	scale  		  = { width = 480, height = 320 },
	title  		  = "Magic Cat <3"
}

-- [[ Configurações do Projeto ]]
projectConfig = {
	landscape 	  = true,
	maxLayers     = 10,
	layersToPause = { 1, 2, 3, 4, 5, 6, 7, 8 },
	defaultFont   = "Anatole",
	playReload	  = false,
	openScene 	  = "SCIntro"--"SCIntro""SCBalloons""SCIntro""SCMeteor"
}

-- [[ configuração da Física ]]
worldConfig = {
	gravityX      = 0,
	gravityY      = -9,
	meterPerPixel = 30
}

-- [[ configuração do Debug ]]
debugConfig = {
	screen 		  = false,
	lines  		  = false,
	psychs		  = false,
	printing  	  = false,
	events 		  = false,
	useful	      = false
}