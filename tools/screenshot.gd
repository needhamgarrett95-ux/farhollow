extends SceneTree
## Screenshot tool - loads main scene and saves a viewport capture.

func _init():
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main = scene.instantiate()
	root.add_child(main)
	
	# Wait for town to build
	await process_frame
	await process_frame
	await process_frame
	
	# Move camera to show the town center nicely
	var camera = main.get_node("Player/Camera") as Camera2D
	if camera:
		# Temporarily detach to frame the town
		camera.position_smoothing_enabled = false
		# Center on town (tile 20,15)
		camera.global_position = Vector2(20 * 16, 15 * 16)
		await process_frame
		await process_frame
	
	var img = root.get_texture().get_image()
	img.save_png("/tmp/farhollow-godot.png")
	print("Screenshot saved to /tmp/farhollow-godot.png")
	quit()
