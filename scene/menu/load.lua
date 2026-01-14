function love.load()

	--helper function for colors
	function set_color(_color)
		
		if _color == 'red' then
			love.graphics.setColor(1, 0, 0, 1)
		elseif _color == 'blue' then
			love.graphics.setColor(0, 0, 1, 1)
		elseif _color == 'green' then
			love.graphics.setColor(0, 1, 0, 1)
		elseif _color == 'yellow' then
			love.graphics.setColor(1, 1, 0, 1)
		elseif _color == 'white' then
			love.graphics.setColor(1, 1, 1, 1)
		end
	end

	sfx = {
		drain = love.audio.newSource('sfx/drain.wav', 'static'),
		loop = love.audio.newSource('sfx/loop.wav', 'static')
	}
	spr = {
		hexagon = love.graphics.newImage('spr/hexagon.png')
	}
	font = {
		title = love.graphics.newFont('font/BungeeInline-Regular.ttf', 72),
		level = love.graphics.newFont('font/BungeeInline-Regular.ttf', 36),
		button = love.graphics.newFont('font/BungeeInline-Regular.ttf', 24),
		small = love.graphics.newFont('font/BungeeInline-Regular.ttf', 16)
	}

	button = {
		{
			caption = 'ENDLESS',
			x = 640/2,
			y = 480/2
		},
		{
			caption = 'MARATHON',
			x = 640/2,
			y = 480/2 + 32
		}
	}

	key_held = {
		['up'] = false,
		['down'] = false,
		['enter'] = false
	}

	button_selected = 1

	--love.window.setMode(640, 480)
end