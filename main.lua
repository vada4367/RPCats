local gE = require("engine")
local Gmr = require("gamer")

function love.load()
	love.window.setTitle("SimpleScale Demo")
	require "simpleScale"
	love.graphics.setDefaultFilter("nearest","nearest")
	scaleType = 1
	width = 960
	height = 540
	windowWidth = 960
	widthHeight = 540
	fullscreen = true
	simpleScale.setWindow(width,height,windowWidth,widthHeight, {fullscreen = fullscreen, resizable = true});

	function updateScale()
		simpleScale.updateWindow(windowWidth,widthHeight, {fullscreen = fullscreen, resizable = true});
	end

	line1 = gE.Line(1, 1, 960, 540)
	line1:init()
	lines1 = {line1}

	player = Gmr.Gamer()
	player:update()
	player:init()

	updateScale()
end

function love.update(dt)
	simpleScale.set()
	simpleScale.resizeUpdate()

	if love.keyboard.isDown("w") then
		if player.y + player.sy >= 539 then
			player.vi = -260
		end
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - 2
	end
	
	if love.keyboard.isDown("d") then
		player.x = player.x + 2
	end

	player:fall()

	if player.y + player.sy >= 540 then
		player.y = 540 - player.sy
	end


	player:update()
	player:init()
	player:collision(lines1)
	--love.graphics.print(player.peres[2][1] .. " " .. player.peres[2][2], 400, 400)
	
	--[[
	if love.mouse.isDown(1) then
		mouse.x, mouse.y = love.mouse.getPosition( )
		mouse.x = mouse.x / 1.66
		mouse.y = mouse.y / 1.66
	end
	if not love.mouse.isDown(1) then
		mouse.x = nil
		mouse.y = nil
	end
	]]

	simpleScale.unSet()
end

function love.draw()
    simpleScale.set()
    for i = 1, #player.peres do
   		love.graphics.print(player.peres[i][1] .. " " .. player.peres[i][2], 400, 400 + i * 10)
   	end
    --[[
    if love.mouse.isDown(1) then
	love.graphics.print(mouse.x .. " " .. mouse.y, 100, 50)
    	if (mouse.x < player.x + 100 and mouse.x > player.x - 100) and (mouse.y < player.y + 100 and mouse.y > player.y - 100) then
		math.randomseed(os.time())
        	player.x = math.random(0, 900)
		player.y = math.random(0, 540)	
    	end
    end
    ]]
    

    love.graphics.rectangle("fill", player.x, player.y, player.sx, player.sy)
    love.graphics.line(line1.x, line1.y, line1.dx, line1.dy)
    simpleScale.unSet()
end
