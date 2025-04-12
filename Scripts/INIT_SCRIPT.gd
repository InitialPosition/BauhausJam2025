extends Node2D


func _ready() -> void:
	# scale game
	var current_scale: int = 1
	var window_dimensions: Vector2 = DisplayServer.window_get_size()
	var display_dimensions: Vector2 = DisplayServer.screen_get_size()

	while window_dimensions.x * current_scale < display_dimensions.x and window_dimensions.y * current_scale < display_dimensions.y:
		current_scale += 1
	
	# we overshoot by one so remove it
	current_scale -= 4
	ConfigValues.screen_scale = current_scale

	var new_window_dimensions = window_dimensions * current_scale	
	Util.set_window_resolution(new_window_dimensions.x, new_window_dimensions.y)

	# Util.set_window_fullscreen(true)

	call_deferred('start_game')


func start_game():
	get_tree().change_scene_to_file('res://Scenes/SceneRoad/SceneRoad.tscn')
