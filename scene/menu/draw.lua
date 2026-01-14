function love.draw()

	--draw hexagon
	for y=1, 15 do
		for x=1, 20 do
			love.graphics.draw(spr.hexagon, (x-1)*32, (y-1)*32)
		end
	end

	--draw buttons
	love.graphics.setFont(font.button)
	for i=1, #button do
		
		if button_selected == i then
			love.graphics.setColor(0.75, 0.5, 0.1, 1)
		end
		love.graphics.print(button[i].caption, button[i].x, button[i].y)
		love.graphics.setColor(1, 1, 1, 1)
	end

	--draw title
	love.graphics.setFont(font.title)
	love.graphics.setColor(0.75, 0.5, 0.1, 1)
	love.graphics.print('SUPER', 32, 32)
	love.graphics.print('ZOOPER', 64, 96)
	love.graphics.setColor(1, 1, 1, 1)
end