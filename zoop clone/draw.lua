function love.draw()

	--prepare draw order table
	draw_order = {}

	for i=1, #topcolumn_1 do
		table.insert(draw_order, topcolumn_1[i])
	end
	for i=1, #topcolumn_2 do
		table.insert(draw_order, topcolumn_2[i])
	end
	for i=1, #topcolumn_3 do
		table.insert(draw_order, topcolumn_3[i])
	end
	for i=1, #topcolumn_4 do
		table.insert(draw_order, topcolumn_4[i])
	end

	table.sort(draw_order, function(a, b)
		if a.y < b.y then return true end
	end)
	
	--draw background square
	love.graphics.rectangle('fill', 256, 176, 128, 128)

	for i=1, #draw_order do
		if draw_order[i].type == 'node' then
			for ii=1, #spr.ball do
				love.graphics.draw(spr.ball[ii], draw_order[i].x, draw_order[i].y-ii, math.rad(draw_order[i].angle), 1, 1, 16, 16)
			end
		end
	end


	--draw triangle
	for i=1, #spr.triangle do
		love.graphics.draw(spr.triangle[i], triangle.x, triangle.y-i-1, math.rad(triangle.angle), 1, 1, 16, 16) 
	end

end