function love.update()

	--press up
	if love.keyboard.isDown('up')
	and not key_held['up'] then

		if button_selected > 1 then
			button_selected = button_selected - 1
		end

		key_held['up'] = true
	end

	--press down
	if love.keyboard.isDown('down')
	and not key_held['down'] then

		if button_selected < 2 then
			button_selected = button_selected + 1
		end

		key_held['down'] = true
	end

	--unpress keys
	if not love.keyboard.isDown('up') then
		key_held['up'] = false
	end
	if not love.keyboard.isDown('down') then
		key_held['down'] = false
	end

	--select button
	if love.keyboard.isDown('z') then

		if button_selected == 1 then

			load_scene('scene.endless.load',
					   'scene.endless.update',
					   'scene.endless.draw')
		end
	end
end