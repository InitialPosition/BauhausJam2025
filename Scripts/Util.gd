extends Node2D


func set_window_resolution(width: int, height: int):
	var old_resolution = get_current_window_resolution()

	var new_size = Vector2i(width, height)
	DisplayServer.window_set_size(new_size)

	get_window().move_to_center()

	SignalEmitter.resolution_changed.emit(old_resolution, new_size)

func get_current_window_resolution():
	return get_window().size

func set_window_fullscreen(fullscreen: bool):
	var new_mode

	if fullscreen:
		new_mode = DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	else:
		new_mode = DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(new_mode)

	SignalEmitter.fullscreen_changed.emit(fullscreen)

func window_is_fullscreen():
	return DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

func save_settings():
	var config = ConfigFile.new()

	config.set_value("audio", "volume_main", ConfigValues.volume_main)
	config.set_value("audio", "volume_music", ConfigValues.volume_music)
	config.set_value("audio", "volume_sfx", ConfigValues.volume_sfx)

	config.save("user://conf.cfg")

	SignalEmitter.settings_saved.emit()

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")

	if err != OK:
		return
	
	# read saved values into config values directly
	ConfigValues.volume_main = config.get_value("audio", "volume_main")
	ConfigValues.volume_music = config.get_value("audio", "volume_music")
	ConfigValues.volume_sfx = config.get_value("audio", "volume_sfx")

	SignalEmitter.settings_loaded.emit()
