image = "meteorTriangleWhite"
size  = { 95, 85 }
red,green,blue = 0
time = config[4]

if config[3] == 1 then
	red,green,blue = hexToRgb ( Color.Red )
elseif config[3] == 2 then
	red,green,blue = hexToRgb ( Color.Blue )
elseif config[3] == 3 then
	red,green,blue = hexToRgb ( Color.Green )
else
	red,green,blue = hexToRgb ( Color.Purple )
end

self:setFlip ( config[1] )
self:setFlip ( config[2] )

