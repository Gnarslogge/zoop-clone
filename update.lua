function love.update(dt) 


	--
	if not (end_game) then


		--decrement spawn interval
		spawn_interval = spawn_interval - 1

		--do spawn
		if spawn_interval == 0 then

			--pick a spawner to spawn
			local _chosen = math.random(16)
			spawner[_chosen].chosen_to_spawn = true

			--pick a color
			local _color = math.random(4)
			if _color == 1 then _color = 'red' end
			if _color == 2 then _color = 'green' end
			if _color == 3 then _color = 'blue' end
			if _color == 4 then _color = 'yellow' end

			--update spawners
			for i=1, #spawner do

				if spawner[i].chosen_to_spawn then

					table.insert(spawner[i].linked_table, {

						type = 'node',
						spr = spr.ball,
						x = spawner[i].x,
						y = spawner[i].y,
						grid_x = spawner[i].grid_x,
						grid_y = spawner[i].grid_y,
						angle = 0,
						color = _color
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
					elseif spawner[i].direction == 'right' then
						spawner[i].linked_table[ii].x = spawner[i].linked_table[ii].x + 8
					elseif spawner[i].direction == 'up' then
						spawner[i].linked_table[ii].y = spawner[i].linked_table[ii].y - 8
					elseif spawner[i].direction == 'left' then
						spawner[i].linked_table[ii].x = spawner[i].linked_table[ii].x - 8
					end
				end

				--decrement timer
				spawner[i].spawn_timer = spawner[i].spawn_timer - 1
				if spawner[i].spawn_timer == 0 then
					spawner[i].spawning = false
					
					--adjust all nodes grid position
					--down
					if spawner[i].direction == 'down' then
						for ii=1, #spawner[i].linked_table do

							spawner[i].linked_table[ii].grid_y = spawner[i].linked_table[ii].grid_y + 1

							--end game
							if spawner[i].linked_table[ii].grid_y == up_bound_grid_y then
								end_game = true
								break
							end
						end
					end
					--right
					if spawner[i].direction == 'right' then

						for ii=1, #spawner[i].linked_table do

							spawner[i].linked_table[ii].grid_x = spawner[i].linked_table[ii].grid_x + 1

							--end game
							if spawner[i].linked_table[ii].grid_x == left_bound_grid_x then
								end_game = true
								break
							end
						end
					end
					--up
					if spawner[i].direction == 'up' then
						
						for ii=1, #spawner[i].linked_table do

							spawner[i].linked_table[ii].grid_y = spawner[i].linked_table[ii].grid_y - 1

							--end game
							if spawner[i].linked_table[ii].grid_y == down_bound_grid_y then
								end_game = true
								break
							end
						end
					end
					--left
					if spawner[i].direction == 'left' then

						for ii=1, #spawner[i].linked_table do

							spawner[i].linked_table[ii].grid_x = spawner[i].linked_table[ii].grid_x - 1

							--end game
							if spawner[i].linked_table[ii].grid_x == right_bound_grid_x then
								end_game = true
								break
							end
						end
					end
				end
			end
		end

		--update angle of nodes
		for i=1, #topcolumn do
			for ii=1, #topcolumn[i] do
				topcolumn[i][ii].angle = topcolumn[i][ii].angle + 2
			end
		end

		for i=1, #leftrow do
			for ii=1, #leftrow[i] do
				leftrow[i][ii].angle = leftrow[i][ii].angle + 2
			end
		end

		for i=1, #bottomcolumn do
			for ii=1, #bottomcolumn[i] do
				bottomcolumn[i][ii].angle = bottomcolumn[i][ii].angle + 2
			end
		end

		for i=1, #rightrow do
			for ii=1, #rightrow[i] do
				rightrow[i][ii].angle = rightrow[i][ii].angle + 2
			end
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

			--attempt to swipe
			if mouse.held 
			and not swiped then

				mouse.x = love.mouse.getX()
				mouse.y = love.mouse.getY()

				--swipe left
				if mouse.og_x - mouse.x > 16 then

					if (triangle.grid_x > left_bound_grid_x) then
						triangle.direction = 'left'
						triangle.goal_angle = 270
						triangle.between_squares = true
						triangle.grid_x = triangle.grid_x - 1
					else
						triangle.zooping = true
						triangle.zoop_status = 'out'
						triangle.direction = 'left'
						triangle.goal_angle = 270
					end

					swiped = true
					_mouse_input = true

				--swipe right
				elseif mouse.og_x - mouse.x < -16 then

					if (triangle.grid_x < right_bound_grid_x) then
						triangle.direction = 'right'
						triangle.goal_angle = 90
						triangle.between_squares = true
						triangle.grid_x = triangle.grid_x + 1
					else
						triangle.zooping = true
						triangle.zoop_status = 'out'
						triangle.direction = 'right'
						triangle.goal_angle = 90
					end

					swiped = true
					_mouse_input = true

				--swipe up
				elseif mouse.og_y - mouse.y > 16 then

					if (triangle.grid_y > up_bound_grid_y) then
						triangle.direction = 'up'
						triangle.goal_angle = 0
						triangle.between_squares = true
						triangle.grid_y = triangle.grid_y - 1
					else
						triangle.zooping = true
						triangle.zoop_status = 'out'
						triangle.direction = 'up'
						triangle.goal_angle = 0
					end
					swiped = true
					_mouse_input = true

				--swipe down
				elseif mouse.og_y - mouse.y < -16 then

					if (triangle.grid_y < down_bound_grid_y) then
						triangle.direction = 'down'
						triangle.goal_angle = 180
						triangle.between_squares = true
						triangle.grid_y = triangle.grid_y + 1
					else
						triangle.zooping = true
						triangle.zoop_status = 'out'
						triangle.direction = 'down'
						triangle.goal_angle = 180
					end

					swiped = true
					_mouse_input = true
				end
			end
		end

		--triangle key input
		if not (triangle.between_squares) 
		and not (triangle.zooping)
		and not _mouse_input then

			if key_pressed['up'] then

				if (triangle.grid_y > up_bound_grid_y) then 

					triangle.direction = 'up'
					triangle.goal_angle = 0
					triangle.between_squares = true
					triangle.grid_y = triangle.grid_y - 1
				
				else
					triangle.zooping = true
					triangle.direction = 'up'
					triangle.goal_angle = 0
					triangle.zoop_status = 'out'
				end
			
			elseif key_pressed['down'] then
				
				if (triangle.grid_y < down_bound_grid_y) then

					triangle.direction = 'down'
					triangle.goal_angle = 180
					triangle.between_squares = true
					triangle.grid_y = triangle.grid_y + 1
				else
					triangle.zooping = true
					triangle.zoop_status = 'out'
					triangle.direction = 'down'
					triangle.goal_angle = 180
				end
			
			elseif key_pressed['left'] then

				if (triangle.grid_x > left_bound_grid_x) then

					triangle.direction = 'left'
					triangle.goal_angle = 270
					triangle.between_squares = true
					triangle.grid_x = triangle.grid_x - 1
				
				else
					triangle.zooping = true
					triangle.zoop_status = 'out'
					triangle.direction = 'left'
					triangle.goal_angle = 270
				end
			
			elseif key_pressed['right'] then
				
				if (triangle.grid_x < right_bound_grid_x) then

					triangle.direction = 'right'
					triangle.goal_angle = 90
					triangle.between_squares = true
					triangle.grid_x = triangle.grid_x + 1
				else
					triangle.zooping = true
					triangle.zoop_status = 'out'
					triangle.direction = 'right'
					triangle.goal_angle = 90
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

		--triangle zooping
		if (triangle.zooping) then

			--move triangle
			if triangle.direction == 'up' then

				triangle.y = triangle.y - 32
				triangle.grid_y = triangle.grid_y - 1

				--stop triangle in center
				if triangle.grid_y == down_bound_grid_y then
					triangle.zooping = false
				end

			elseif triangle.direction == 'down' then

				triangle.y = triangle.y + 32
				triangle.grid_y = triangle.grid_y + 1

				--stop triangle in center
				if triangle.grid_y == up_bound_grid_y then
					triangle.zooping = false
				end

			elseif triangle.direction == 'left' then

				triangle.x = triangle.x - 32
				triangle.grid_x = triangle.grid_x - 1

				--stop triangle in center
				if triangle.grid_x == right_bound_grid_x then
					triangle.zooping = false
				end
			
			elseif triangle.direction == 'right' then

				triangle.x = triangle.x + 32
				triangle.grid_x = triangle.grid_x + 1

				--stop triangle in center
				if triangle.grid_x == left_bound_grid_x then
					triangle.zooping = false
				end
			end

			--attempt to interact with nodes
			if triangle.zoop_status == 'out' then

				if triangle.direction == 'up' then

					--cycle through columns
					for i=1, #topcolumn do
						--cycle through nodes
						for ii=1, #topcolumn[i] do
							--if node is matched with triangle's x coord
							if topcolumn[i][ii].grid_x == triangle.grid_x then

								--do color swap OR take out node
								if topcolumn[i][ii].grid_y == triangle.grid_y then

									if triangle.color ~= topcolumn[i][ii].color then

										local _color_storage = triangle.color
										triangle.color 		 = topcolumn[i][ii].color
										topcolumn[i][ii].color = _color_storage

										triangle.zoop_status = 'in'
										triangle.direction = 'down'

									else
										table.remove(topcolumn[i], ii)
									end

									break
								end

							else break end
						end
					end
				
				elseif triangle.direction == 'left' then

					--cycle through rows
					for i=1, #leftrow do
						--cycle through nodes
						for ii=1, #leftrow[i] do
							--if row is matched with triangles y coord
							if leftrow[i][ii].grid_y == triangle.grid_y then

							
								if leftrow[i][ii].grid_x == triangle.grid_x then

									if leftrow[i][ii].color ~= triangle.color then

										local _color_storage = triangle.color
										triangle.color 		 = leftrow[i][ii].color
										leftrow[i][ii].color = _color_storage

										triangle.zoop_status = 'in'
										triangle.direction = 'right'

									else
										table.remove(leftrow[i], ii)
									end

									break
								end
							else break end
						end
					end

				elseif triangle.direction == 'down' then

					--cycle through columns
					for i=1, #bottomcolumn do
						for ii=1, #bottomcolumn[i] do
							--if column is matched with triangles x coord
							if bottomcolumn[i][ii].grid_x == triangle.grid_x then

								if bottomcolumn[i][ii].grid_y == triangle.grid_y then

									if bottomcolumn[i][ii].color ~= triangle.color then

										local _color_storage = triangle.color
										triangle.color 		 = bottomcolumn[i][ii].color
										bottomcolumn[i][ii].color = _color_storage

										triangle.zoop_status = 'in'
										triangle.direction = 'up'

									else 
										table.remove(bottomcolumn[i], ii)
									end
									break
								end

							else break end
						end
					end
				elseif triangle.direction == 'right' then

					--cycle through rows
					for i=1, #rightrow do
						--cycle through nodes
						for ii=1, #rightrow[i] do
							--if row is matched with triangles y coord
							if rightrow[i][ii].grid_y == triangle.grid_y then

								if rightrow[i][ii].grid_x == triangle.grid_x then

									if rightrow[i][ii].color ~= triangle.color then

										local _color_storage = triangle.color
										triangle.color 		 = rightrow[i][ii].color
										rightrow[i][ii].color = _color_storage

										triangle.zoop_status = 'in'
										triangle.direction = 'left'

									else
										table.remove(rightrow[i], ii)
									end
									break
								end

							else break end
						end
					end
				end
			end

			--flip triangle around
			if triangle.grid_y == 1 then
				triangle.zoop_status = 'in'
				triangle.direction = 'down'
				triangle.goal_angle = 180
			end
			if triangle.grid_x == 1 then
				triangle.zoop_status = 'in'
				triangle.direction = 'right'
				triangle.goal_angle = 90
			end
			if triangle.grid_x == 20 then
				triangle.zoop_status = 'in'
				triangle.direction = 'left'
				triangle.goal_angle = 270
			end
			if triangle.grid_y == 14 then
				triangle.zoop_status = 'in'
				triangle.direction = 'up'
				triangle.goal_angle = 0
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
	

	--end game
	else

		--spin triangle
		triangle.angle = triangle.angle + 15

	end
end