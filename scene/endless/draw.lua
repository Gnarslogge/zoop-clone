function love.draw()


	if game_state == 'show_level_title' then

		love.graphics.setFont(font.title)
		love.graphics.print('ENDLESS', 144, 128)
		return
	
	end

	--prepare draw order table
	draw_order = {
		triangle
	}

	for i=1, #topcolumn do
		for ii=1, #topcolumn[i] do
			table.insert(draw_order, topcolumn[i][ii])
		end
	end

	for i=1, #leftrow do
		for ii=1, #leftrow[i] do
			table.insert(draw_order, leftrow[i][ii])
		end
	end
	
	for i=1, #bottomcolumn do
		for ii=1, #bottomcolumn[i] do
			table.insert(draw_order, bottomcolumn[i][ii])
		end
	end

	for i=1, #rightrow do
		for ii=1, #rightrow[i] do
			table.insert(draw_order, rightrow[i][ii])
		end
	end

	table.sort(draw_order, function(a, b)
		if a.y < b.y then return true end
	end)
	
	--draw bricks
	for y=1, 15 do
		for x=1, 20 do
			love.graphics.draw(spr.hexagon, (x-1)*32, (y-1)*32)
		end
	end

	--draw squares
	for y=0, 5 do
		for x=9, 12 do
			love.graphics.draw(spr.squares, (x-1)*32, (y-1)*32 + 16)
		end
	end
	for y=10, 15 do
		for x=9, 12 do
			love.graphics.draw(spr.squares, (x-1)*32, (y-1)*32 + 16)
		end
	end
	for x=1, 8 do
		for y=6, 9 do
			love.graphics.draw(spr.squares, (x-1)*32, (y-1)*32 + 16)
		end
	end
	for x=13, 20 do
		for y=6, 9 do
			love.graphics.draw(spr.squares, (x-1)*32, (y-1)*32 + 16)
		end
	end

	--draw center square
	for y=6, 9 do
		for x=9, 12 do
			love.graphics.draw(spr.claybricks, (x-1)*32, (y-1)*32 + 16)
		end
	end
	--draw background square
	--love.graphics.rectangle('fill', 256, 176, 128, 128)

	for i=1, #draw_order do
		--get color
		if draw_order[i].color == 'red' then
			love.graphics.setColor(1, 0, 0, 1)
		elseif draw_order[i].color == 'blue' then
			love.graphics.setColor(0, 0, 1, 1)
		elseif draw_order[i].color == 'green' then
			love.graphics.setColor(0, 1, 0, 1)
		elseif draw_order[i].color == 'yellow' then
			love.graphics.setColor(1, 1, 0, 1)
		end

		--draw ball slices
		for ii=1, #draw_order[i].spr do
			love.graphics.draw(draw_order[i].spr[ii], draw_order[i].x, draw_order[i].y-ii, math.rad(draw_order[i].angle), 1, 1, 16, 16)
		end

		--reset color to white
		love.graphics.setColor(1, 1, 1, 1)
	end

	--draw tubes

	--first determine level to draw tube at
	if not draining_cylinders then
		local _fill_unit = 64 / color_level.max
		local _fill_amount = {
			['blue'] = color_level.blue * _fill_unit,
			['red'] = color_level.red * _fill_unit,
			['green'] = color_level.green * _fill_unit,
			['yellow'] = color_level.yellow * _fill_unit
		}


		for i=1, #tube do

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.circle('line', tube[i].x, tube[i].y, 32)
			set_color('white')

			for ii=1, 64 do
				--color tube
				if ii <= _fill_amount[tube[i].color] then
					set_color(tube[i].color)
				else
					love.graphics.setColor(0.1, 0.2, 0.5, 0.05)
				end
				love.graphics.draw(spr.circle, tube[i].x, tube[i].y-ii+1, 0, 1, 1, 32, 32)
				love.graphics.setColor(1, 1, 1, 1)
			end

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.circle('line', tube[i].x, tube[i].y-64, 32)
			love.graphics.line(tube[i].x-32, tube[i].y+8, tube[i].x-32, tube[i].y-64)
			love.graphics.line(tube[i].x+32, tube[i].y+8, tube[i].x+32, tube[i].y-64)
			set_color('white')
		end
	else
		for i=1, #tube do

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.circle('line', tube[i].x, tube[i].y, 32)
			set_color('white')

			for ii=1, 64 do
				if ii <= cylinder_drain_countdown then
					set_color(tube[i].color)
				else
					love.graphics.setColor(0.1, 0.2, 0.5, 0.05)
				end
				love.graphics.draw(spr.circle, tube[i].x, tube[i].y-ii+1, 0, 1, 1, 32, 32)
				set_color('white')
			end

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.circle('line', tube[i].x, tube[i].y-64, 32)
			love.graphics.line(tube[i].x-32, tube[i].y+8, tube[i].x-32, tube[i].y-64)
			love.graphics.line(tube[i].x+32, tube[i].y+8, tube[i].x+32, tube[i].y-64)
			set_color('white')
		end

		love.graphics.setFont(font.title)
		if cylinder_drain_countdown > 60 then

			local _increment = 64 - cylinder_drain_countdown

			love.graphics.print('DRAIN', 188, 0 + _increment * 40)
		
		elseif cylinder_drain_countdown > 30 then

			love.graphics.print('DRAIN', 188, 200)
		else
			love.graphics.print('DRAIN', 188, 200 + (30-cylinder_drain_countdown)*16)
		end
	end
	--[[]
	love.graphics.setFont(font.small)
	love.graphics.print(triangle.grid_x)
	love.graphics.print(triangle.grid_y, 0, 16)
	love.graphics.print(triangle.color, 0, 32)
	love.graphics.print(tostring(triangle.zooping), 0, 48)
	love.graphics.print(triangle.zoop_status, 0, 64)
	love.graphics.print(triangle.direction, 0, 80)
	--]]

	if game_state == 'level_title_scroll_out' then

		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle('fill', 0, 0, 640, 240 - level_title_scroll)
		love.graphics.rectangle('fill', 0, 240 + level_title_scroll, 640, 240)
		set_color('white')
		love.graphics.setFont(font.title)
		love.graphics.print('ENDLESS', 144, 128 - level_title_scroll)
	end
end