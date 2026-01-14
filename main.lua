function load_scene(load_file, update_file, draw_file)
	require ('scene.menu.load')
  love.load()
	require (update_file)
	require (draw_file)
  require (load_file)
  love.load()
end

load_scene('scene.endless.load',
		   'scene.endless.update',
		   'scene.endless.draw')