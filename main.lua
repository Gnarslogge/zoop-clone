function load_scene(load_file, update_file, draw_file)
	require (load_file)
	require (update_file)
	require (draw_file)
	love.load()
end

load_scene('scene.menu.load',
		   'scene.menu.update',
		   'scene.menu.draw')