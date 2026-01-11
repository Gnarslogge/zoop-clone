function love.update(dt) 

	spawn_interval = spawn_interval - 1

	if spawn_interval == 0 then

		--pick a spawner to spawn
		local _chosen = math.random(4)
		spawner[_chosen].chosen_to_spawn = true

		--update spawners
		for i=1, #spawner do

			if spawner[i].chosen_to_spawn then

				table.insert(spawner[i].linked_table, {

					type = 'node',
					x = spawner[i].x,
					y = spawner[i].y,
					grid_x = spawner[i].grid_x,
					grid_y = spawner[i].grid_y,
					angle = 0
				})

				spawner[i].spawn_timer = 4
				spawner[i].spawning = true
				spawner[i].chosen_to_spawn = false
			end
		end

		spawn_interval = 60
	end

	--advance nodes
	for i=1, #spawner do

		if spawner[i].spawning then

			--move nodes
			for ii=1, #spawner[i].linked_table do
				if spawner[i].direction == 'down' then
					spawner[i].linked_table[ii].y = spawner[i].linked_table[ii].y + 8
				end
			end

			--decrement timer
			spawner[i].spawn_timer = spawner[i].spawn_timer - 1
			if spawner[i].spawn_timer == 0 then
				spawner[i].spawning = false
			end
		end
	end

	--update angle of nodes
	for i=1, #topcolumn_1 do
		topcolumn_1[i].angle = topcolumn_1[i].angle + 1
	end
	for i=1, #topcolumn_2 do
		topcolumn_2[i].angle = topcolumn_2[i].angle + 1
	end
	for i=1, #topcolumn_3 do
		topcolumn_3[i].angle = topcolumn_3[i].angle + 1
	end
	for i=1, #topcolumn_4 do
		topcolumn_4[i].angle = topcolumn_4[i].angle + 1
	end

	--reset key press table
	key_pressed['up'] = false
	key_pressed['down'] = false
	key_pressed['left'] = false
	key_pressed['right'] = false

	--reset key held table
	if not love.keyboard.isDown('up') then
		key_held['up'] = false
	end
	if not love.keyboard.isDown('down') then
		key_held['down'] = false
	end
	if not love.keyboard.isDown('left') then
		key_held['left'] = false
	end
	if not love.keyboard.isDown('right') then
		key_held['right'] = false
	end

	--check if keys are pressed
	if love.keyboard.isDown('up') 
	and not key_held['up'] then
		key_pressed['up'] = true
		key_held['up'] = true
	end

	if love.keyboard.isDown('down')
	and not key_held['down'] then
		key_pressed['down'] = true
		key_held['down'] = true
	end

	if love.keyboard.isDown('left')
	and not key_held['left'] then
		key_pressed['left'] = true
		key_held['left'] = true
	end

	if love.keyboard.isDown('right')
	and not key_held['right'] then
		key_pressed['right'] = true
		key_held['right'] = true
	end

	local _mouse_input = false

	--triangle mouse input
	if not (triangle.between_squares) then

		--cancel click
		if not love.mouse.isDown('1') then
			mouse.held = false
			swiped = false
		end

		--initiate mouse click
		if love.mouse.isDown('1') 
		and not mouse.held then

			mouse.og_x = love.mouse.getX()
			mouse.og_y = love.mouse.getY()

			mouse.held = true
		end

		if mouse.held 
		and not swiped then

			mouse.x = love.mouse.getX()
			mouse.y = love.mouse.getY()

			--swipe left
			if mouse.og_x - mouse.x > 64 then

				if (triangle.grid_x > 1) then
					triangle.direction = 'left'
					triangle.goal_angle = 270
					triangle.between_squares = true
					triangle.grid_x = triangle.grid_x - 1
					swiped = true
				end

			elseif mouse.og_x - mouse.x < -64 then

				if (triangle.grid_x < 4) then
					triangle.direction = 'right'
					triangle.goal_angle = 90
					triangle.between_squares = true
					triangle.grid_x = triangle.grid_x + 1
					swiped = true
				end

			elseif mouse.og_y - mouse.y > 64 then

				if (triangle.grid_y > 1) then
					triangle.direction = 'up'
					triangle.goal_angle = 0
					triangle.between_squares = true
					triangle.grid_y = triangle.grid_y - 1
					swiped = true
				end

			elseif mouse.og_y - mouse.y < -64 then

				if (triangle.grid_y < 4) then
					triangle.direction = 'down'
					triangle.goal_angle = 180
					triangle.between_squares = true
					triangle.grid_y = triangle.grid_y + 1
					swiped = true
				end
			end
		end
	end

	--triangle key input
	if not (triangle.between_squares) 
	and not _mouse_input then

		if key_pressed['up'] then

			if (triangle.grid_y > 1) then 

				triangle.direction = 'up'
				triangle.goal_angle = 0
				triangle.between_squares = true
				triangle.grid_y = triangle.grid_y - 1
			end
		
		elseif key_pressed['down'] then
			
			if (triangle.grid_y < 4) then

				triangle.direction = 'down'
				triangle.goal_angle = 180
				triangle.between_squares = true
				triangle.grid_y = triangle.grid_y + 1
			end
		
		elseif key_pressed['left'] then

			if (triangle.grid_x > 1) then

				triangle.direction = 'left'
				triangle.goal_angle = 270
				triangle.between_squares = true
				triangle.grid_x = triangle.grid_x - 1
			end
		
		elseif key_pressed['right'] then
			
			if (triangle.grid_x < 4) then

				triangle.direction = 'right'
				triangle.goal_angle = 90
				triangle.between_squares = true
				triangle.grid_x = triangle.grid_x + 1
			end
		end
	end

	--triangle between squares
	if (triangle.between_squares) then

		--move triangle
		if triangle.direction == 'up' then
			triangle.y = triangle.y - 8
		elseif triangle.direction == 'down' then
			triangle.y = triangle.y + 8
		elseif triangle.direction == 'left' then
			triangle.x = triangle.x - 8
		elseif triangle.direction == 'right' then
			triangle.x = triangle.x + 8
		end

		triangle.between_squares_counter = triangle.between_squares_counter + 1

		if (triangle.between_squares_counter == 4) then

			triangle.between_squares = false
			triangle.between_squares_counter = 0
		end
	end

	--adjust triangle angle
	--calculate which angle direction is the shortest path
    local _diff = (triangle.goal_angle - triangle.angle + 360) % 360
    if _diff > 0
    and _diff <= 180 then
        triangle.angle = triangle.angle + 22.5
    elseif _diff > 180 then
        triangle.angle = triangle.angle - 22.5
    end
end