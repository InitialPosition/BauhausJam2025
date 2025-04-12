extends Control


var label_score: Label
var label_stage: Label
var progress_indicator_head: Sprite2D
var progress_indicator_line: Line2D

var progress_start: float

var current_stage_progress: float = 0.0
var stage_progress_speed: float = 0.02
var progress_length: float

func _ready() -> void:
	label_score = $Label_Score
	label_stage = $Label_Stage
	progress_indicator_head = $ProgressIndicator_Head
	progress_indicator_line = $ProgressIndicator_Line

	progress_start = progress_indicator_head.global_position.x

	label_score.text = 'SCORE ' + str(GameManager.current_score)
	label_stage.text = 'STAGE ' + str(GameManager.current_stage)

	progress_length = progress_indicator_line.points[0].x - progress_indicator_line.points[1].x
	
	SignalEmitter.enemy_defeated.connect(_on_enemy_defeated)

func _process(delta: float) -> void:
	current_stage_progress += stage_progress_speed
	if current_stage_progress > 100:
		# TODO exit driving stage here
		current_stage_progress = 100
		pass
	
	progress_indicator_head.global_position.x = (progress_length / 100 * current_stage_progress) + progress_start

func _on_enemy_defeated(new_score: int):
	label_score.text = 'SCORE ' + str(GameManager.current_score)
