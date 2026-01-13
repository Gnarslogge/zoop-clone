function love.draw()

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
	
	--draw background square
	love.graphics.rectangle('fill', 256, 176, 128, 128)

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

	love.graphics.print(triangle.grid_x)
	love.graphics.print(triangle.grid_y, 0, 16)
	love.graphics.print(triangle.color, 0, 32)
	love.graphics.print(tostring(triangle.zooping), 0, 48)
	love.graphics.print(triangle.zoop_status, 0, 64)
	love.graphics.print(triangle.direction, 0, 80)

end