function love.load()
	spr = {
		triangle = {
			love.graphics.newImage('spr/triangle_red/triangle1.png'),
			love.graphics.newImage('spr/triangle_red/triangle2.png'),
			love.graphics.newImage('spr/triangle_red/triangle3.png'),
			love.graphics.newImage('spr/triangle_red/triangle4.png'),
			love.graphics.newImage('spr/triangle_red/triangle5.png'),
			love.graphics.newImage('spr/triangle_red/triangle6.png'),
			love.graphics.newImage('spr/triangle_red/triangle7.png'),
			love.graphics.newImage('spr/triangle_red/triangle8.png')
		},
		ball = {
			love.graphics.newImage('spr/ball/ball1.png'),
			love.graphics.newImage('spr/ball/ball2.png'),
			love.graphics.newImage('spr/ball/ball3.png'),
			love.graphics.newImage('spr/ball/ball4.png'),
			love.graphics.newImage('spr/ball/ball5.png'),
			love.graphics.newImage('spr/ball/ball6.png'),
			love.graphics.newImage('spr/ball/ball7.png'),
			love.graphics.newImage('spr/ball/ball8.png'),
			love.graphics.newImage('spr/ball/ball9.png'),
			love.graphics.newImage('spr/ball/ball10.png'),
			love.graphics.newImage('spr/ball/ball11.png'),
			love.graphics.newImage('spr/ball/ball12.png'),
			love.graphics.newImage('spr/ball/ball13.png'),
			love.graphics.newImage('spr/ball/ball14.png'),
			love.graphics.newImage('spr/ball/ball15.png'),
			love.graphics.newImage('spr/ball/ball16.png'),
			love.graphics.newImage('spr/ball/ball17.png'),
			love.graphics.newImage('spr/ball/ball18.png'),
			love.graphics.newImage('spr/ball/ball19.png'),
			love.graphics.newImage('spr/ball/ball20.png'),
			love.graphics.newImage('spr/ball/ball21.png'),
			love.graphics.newImage('spr/ball/ball22.png'),
			love.graphics.newImage('spr/ball/ball23.png'),
			love.graphics.newImage('spr/ball/ball24.png'),
			love.graphics.newImage('spr/ball/ball25.png'),
			love.graphics.newImage('spr/ball/ball26.png'),
			love.graphics.newImage('spr/ball/ball27.png'),
			love.graphics.newImage('spr/ball/ball28.png'),
			love.graphics.newImage('spr/ball/ball29.png'),
			love.graphics.newImage('spr/ball/ball30.png'),
			love.graphics.newImage('spr/ball/ball31.png'),
			love.graphics.newImage('spr/ball/ball32.png')
		}
	}

mouse = {
   x = 0
   y = 0
   held = false
}

	--initialize randomization
	math.randomseed(1)

	triangle = {
		x = 256 + 16,
		y = 176 + 16,
		grid_x = 1,
		grid_y = 1,
		angle = 0,
		goal_angle = 0,
		direction = 'up',
		between_squares = false,
		between_squares_counter = 0
	}

	topcolumn_1 = {}
	topcolumn_2 = {}
	topcolumn_3 = {}
	topcolumn_4 = {}
	bottomcolumn_1 = {}
	bottomcolumn_2 = {}

	spawn_interval = 30

	spawner = {
		{
			x = 272,
			y = 0,
			grid_x = 9,
			grid_y = 1,
			vert = true,
			linked_table = topcolumn_1,
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 304,
			y = 0,
			grid_x = 10,
			grid_y = 1,
			linked_table = topcolumn_2,
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 336,
			y = 0,
			grid_x = 11,
			grid_y = 1,
			linked_table = topcolumn_3,
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 368,
			y = 0,
			grid_x = 12,
			grid_y = 1,
			linked_table = topcolumn_4,
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		}
	}

	key_pressed = {
		['up'] = false,
		['down'] = false,
		['right'] = false,
		['left'] = false
	}

	key_held = {
		['up'] = false,
		['down'] = false,
		['left'] = false,
		['right'] = false
	}

	love.window.setMode(640, 480)
end