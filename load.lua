function love.load()

	--load graphics
	spr = {
		triangle = {
			love.graphics.newImage('spr/triangle/triangle1.png'),
			love.graphics.newImage('spr/triangle/triangle2.png'),
			love.graphics.newImage('spr/triangle/triangle3.png'),
			love.graphics.newImage('spr/triangle/triangle4.png'),
			love.graphics.newImage('spr/triangle/triangle5.png'),
			love.graphics.newImage('spr/triangle/triangle6.png'),
			love.graphics.newImage('spr/triangle/triangle7.png'),
			love.graphics.newImage('spr/triangle/triangle8.png')
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

	--initialize randomization
	math.randomseed()

	triangle = {
		spr = spr.triangle,
		x = 256 + 16,
		y = 176 + 16,
		grid_x = 9,
		grid_y = 6,
		angle = 0,
		goal_angle = 0,
		direction = 'up',
		between_squares = false,
		between_squares_counter = 0,
		zooping = false,
		zoop_status = 'out',
		color = 'red',
	}

	up_bound_grid_y = 6
	down_bound_grid_y = 9
	left_bound_grid_x = 9
	right_bound_grid_x = 12

	topcolumn = {
		{},
		{},
		{},
		{}
	}
	bottomcolumn = {
		{},
		{},
		{},
		{}
	}
	leftrow = {
		{},
		{},
		{},
		{}
	}
	rightrow = {
		{},
		{},
		{},
		{}
	}

	spawn_interval = 30

	spawner = {
		{
			x = 272,
			y = 8,
			grid_x = 9,
			grid_y = 0,
			vert = true,
			linked_table = topcolumn[1],
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 304,
			y = 8,
			grid_x = 10,
			grid_y = 0,
			linked_table = topcolumn[2],
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 336,
			y = 8,
			grid_x = 11,
			grid_y = 0,
			linked_table = topcolumn[3],
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 368,
			y = 8,
			grid_x = 12,
			grid_y = 0,
			linked_table = topcolumn[4],
			direction = 'down',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = -16,
			y = 200,
			grid_x = 0,
			grid_y = 6,
			linked_table = leftrow[1],
			direction = 'right',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = -16,
			y = 232,
			grid_x = 0,
			grid_y = 7,
			linked_table = leftrow[2],
			direction = 'right',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = -16,
			y = 264,
			grid_x = 0,
			grid_y = 8,
			linked_table = leftrow[3],
			direction = 'right',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = -16,
			y = 296,
			grid_x = 0,
			grid_y = 9,
			linked_table = leftrow[4],
			direction = 'right',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 272,
			y = 488,
			grid_x = 9,
			grid_y = 15,
			linked_table = bottomcolumn[1],
			direction = 'up',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 304,
			y = 488,
			grid_x = 10,
			grid_y = 15,
			linked_table = bottomcolumn[2],
			direction = 'up',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 336,
			y = 488,
			grid_x = 11,
			grid_y = 15,
			linked_table = bottomcolumn[3],
			direction = 'up',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 368,
			y = 488,
			grid_x = 12,
			grid_y = 15,
			linked_table = bottomcolumn[4],
			direction = 'up',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 648,
			y = 200,
			grid_x = 21,
			grid_y = 6,
			linked_table = rightrow[1],
			direction = 'left',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 648,
			y = 232,
			grid_x = 21,
			grid_y = 7,
			linked_table = rightrow[2],
			direction = 'left',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 648,
			y = 264,
			grid_x = 21,
			grid_y = 8,
			linked_table = rightrow[3],
			direction = 'left',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		},
		{
			x = 648,
			y = 296,
			grid_x = 21,
			grid_y = 9,
			linked_table = rightrow[4],
			direction = 'left',
			chosen_to_spawn = false,
			spawning = false,
			spawn_timer = 0
		}
	}

	mouse = {
		x = 0,
		y = 0,
		og_x = 0,
		og_y = 0,
		held = false
	}
	swiped = false

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

	end_game = false
end