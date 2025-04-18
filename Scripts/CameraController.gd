extends Camera2D


var current_shake_strength: float = 0.0
var shake_decay: float = 0.7

const MAX_SHAKE: float = 20.0

@onready var start_pos = global_position
func _ready() -> void:
	SignalEmitter.bullet_fired.connect(shake_screen)
	SignalEmitter.player_hit.connect(shake_screen_hard)

func shake_screen(_bullet: Node2D):
	var strength = 0.05
	if current_shake_strength < strength:
		current_shake_strength = strength

func shake_screen_hard(strength: float = 0.5):
	if current_shake_strength < strength:
		current_shake_strength = strength

func _process(delta: float) -> void:
	# apply and decay shake
	if current_shake_strength > 0:
		global_position = start_pos + Vector2(randf_range(-MAX_SHAKE, MAX_SHAKE) * current_shake_strength, randf_range(-MAX_SHAKE, MAX_SHAKE) * current_shake_strength)
		current_shake_strength -= shake_decay * delta
	
	if current_shake_strength < 0:
		current_shake_strength = 0
