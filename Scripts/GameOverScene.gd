extends Node2D


var stats_text: Label

func _ready() -> void:
	Engine.time_scale = 1.0
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	stats_text = $Stats
	stats_text.text = 'SCORE\n' + str(GameManager.current_score) + '\nFINAL STAGE\n' + str(GameManager.current_stage) + '\n\nENTER: MAIN MENU'

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept'):
		if not Fade.is_fading:
			Fade.change_scene('res://Scenes/SceneMenu.tscn', 0.01)
