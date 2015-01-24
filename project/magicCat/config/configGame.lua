-- [[ Configurações da View ]]
viewConfig = {
	size   		  = { width = 960, height = 640 },
	scale  		  = { width = 480, height = 320 },
	title  		  = "Who Are You?!"
}

-- [[ Configurações do Projeto ]]
projectConfig = {
	landscape 	  = true,
	maxLayers     = 10,
	layersToPause = { 1, 2, 3, 4, 5, 6, 7, 8 },
	defaultFont   = "ArialRounded",
	playReload	  = false,
	openScene 	  = "SCIntro"
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