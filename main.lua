local gE = require("engine")
local Gmr = require("gamer")
local wf = require ('windfield')

function love.load()

	world = wf.newWorld(0, 10000)
	love.window.setTitle("SimpleScale Demo")
	require "simpleScale"
	love.graphics.setDefaultFilter("nearest","nearest")
	scaleType = 1
	width = 960
	height = 540
	windowWidth = 960
	widthHeight = 540
	fullscreen = true
	simpleScale.setWindow(width,height,windowWidth,widthHeight, {fullscreen = fullscreen, resizable = true, vsync = true});
	function updateScale()
		simpleScale.updateWindow(windowWidth,widthHeight, {fullscreen = fullscreen, resizable = true, vsync = true});
	end

	line1 = gE.Line(1, 510, 960, 510)

	lines1 = {line1}

	for i = 1, #lines1 do
		lines1[i]:init()
	end


	rect1 = world:newBSGRectangleCollider(500, 310, 300, 200, 0)
	rect1:setType('static')

	rect2 = world:newBSGRectangleCollider(100, 300, 150, 20, 0)
	rect2:setType('static')

	player = Gmr.Gamer()
	player:update()
	player.collider:setFixedRotation(true)
	player.collider:setFriction(0)
	wall = world:newLineCollider(1, 510, 960, 510)
	wall:setType('static')

	updateScale()
end

function love.update(dt)
	simpleScale.set()
	simpleScale.resizeUpdate()


	if love.keyboard.isDown('right') or love.keyboard.isDown('left') then
		if love.keyboard.isDown('right') then
			player.vx = player.vx + 20
			player.collider:setFriction(0)
		end
		if love.keyboard.isDown('left') then
			player.vx = player.vx + -20
			player.collider:setFriction(0)
		end
 	else
		player.vx = player.vx + ((player.vx / 13) * -1)
	end

	if love.keyboard.isDown('c') then
		player.vi = -450
	end


	if math.abs(player.vx) > 200 then
		if player.vx > 0 then
			player.vx = 200
		else
			player.vx = -200
		end
	end

	world:update(dt)
	player:move()
	player:update()


	player:collision(lines1)

	print(player.vi)

	simpleScale.unSet()
end

function love.draw()
    simpleScale.set()

		for i = 1, #lines1 do
			love.graphics.line(lines1[i].x, lines1[i].y, lines1[i].dx, lines1[i].dy)
		end

		for i = 1, #player.lines do
			love.graphics.line(player.lines[i].x, player.lines[i].y, player.lines[i].dx, player.lines[i].dy)
		end

		world:draw()
    simpleScale.unSet()
end
