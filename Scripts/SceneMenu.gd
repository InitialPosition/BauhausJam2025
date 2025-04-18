extends Node2D


@onready var version_string: Label = $Version
@onready var start_text: Label = $StartText

var timer_blink: Timer

func _ready() -> void:
	if MusicPlayerMainTheme.playing:
		MusicPlayerMainTheme.stop()
	
	if not MusicPlayerMainMenu.playing:
		MusicPlayerMainMenu.play()

	version_string.text = "v." + str(ProjectSettings.get_setting("application/config/version"))

	timer_blink = Timer.new()
	add_child(timer_blink)

	timer_blink.timeout.connect(_on_blink_timer)
	timer_blink.start(0.5)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_blink_timer():
	start_text.visible = !start_text.visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept'):
		if not Fade.is_fading:
			MusicPlayerMainMenu.stop()
			$SelectSound.play()
			
			GameManager.reset_game_manager()
			Fade.change_scene('res://Scenes/SceneRoad/SceneRoad.tscn', 1.5)

			timer_blink.start(0.1)
