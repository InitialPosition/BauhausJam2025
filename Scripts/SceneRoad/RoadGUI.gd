extends Control


var label_score: Label
var label_money: Label
var progress_indicator_head: Sprite2D
var progress_indicator_line: Line2D
var hp_display: AnimatedSprite2D

var progress_start: float

var current_stage_progress: float = 0.0
var stage_progress_speed: float = 10.0
var progress_length: float

var splash_timer: Timer

const SPLASH_MESSAGES: Array = [
	'DUCK EM UP!',
	'IT\'S TIME FOR PAYQUACK!',
	'EVERYONE DUCK FOR COVER!',
	'🦆',
	'DUCK AROUND AND FIND OUT!',
	'ADDICTIVE LIKE QUACK!',
	'BREAD OR ALIVE!',
	'QUACK SOME SKULLS!'
]

func _ready() -> void:
	label_score = $Label_Score
	label_money = $Label_Money
	progress_indicator_head = $ProgressIndicator_Head
	progress_indicator_line = $ProgressIndicator_Line
	hp_display = $HealthDisplay

	hp_display.frame = 5

	progress_start = progress_indicator_head.global_position.x

	label_score.text = 'SCORE ' + str(GameManager.current_score)
	label_money.text = str(GameManager.current_money)

	SignalEmitter.money_collected.connect(_on_money_collected)

	progress_length = progress_indicator_line.points[0].x - progress_indicator_line.points[1].x

	$Label_StartMessage.text = SPLASH_MESSAGES.pick_random()
	splash_timer = Timer.new()
	add_child(splash_timer)
	splash_timer.one_shot = true
	splash_timer.timeout.connect(_hide_splash)
	splash_timer.start(2.0)
	
	SignalEmitter.enemy_defeated.connect(_on_enemy_defeated)
	SignalEmitter.player_hit.connect(_on_player_hit)

func _hide_splash():
	$Label_StartMessage.visible = false

func _process(delta: float) -> void:
	if current_stage_progress >= 100:
		SignalEmitter.road_game_complete.emit()
		if not Fade.is_fading:
			Fade.change_scene('res://Scenes/SceneMechanic/SceneMechanic.tscn', 0.1)
		current_stage_progress = 100
	else:
		current_stage_progress += stage_progress_speed * delta
	
	progress_indicator_head.global_position.x = (progress_length / 100 * current_stage_progress) + progress_start

func _on_enemy_defeated(_new_score: int):
	label_score.text = 'SCORE ' + str(GameManager.current_score)

func _on_player_hit():
	hp_display.frame = GameManager.current_hp

	if GameManager.current_hp == 0:
		$Label_StartMessage.text = "GAME OVER"
		$Label_StartMessage.visible = true

func _on_money_collected():
	GameManager.current_money += 1
	label_money.text = str(GameManager.current_money)
