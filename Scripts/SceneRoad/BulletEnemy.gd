extends Node2D


var is_player_bullet: bool = false

const BULLET_SPEED: float = 100.0
var movement_vector: Vector2 = Vector2.ZERO

const OOB_REMOVE_MARGIN: float = 50.0

var shot_parent: String

@onready var window_size: Vector2 = DisplayServer.window_get_size()
@onready var collider: Area2D = $Collider_Bullet_Enemy
func _ready() -> void:
	collider.area_entered.connect(_on_area_enter)
	# render bullets over enemies
	z_index = 100

func _process(delta: float) -> void:
	global_position.x += movement_vector.x * BULLET_SPEED * delta
	global_position.y += movement_vector.y * BULLET_SPEED * delta
	
	# remove outside room (ugly but this is still a game jam)
	if global_position.x < -OOB_REMOVE_MARGIN or global_position.x > window_size.x + OOB_REMOVE_MARGIN or global_position.y < -OOB_REMOVE_MARGIN or global_position.y > window_size.y + OOB_REMOVE_MARGIN:
		queue_free()

func _on_area_enter(other):
	print(other.name)
	# enemy bullets ignore other enemies
	if other.name == 'Collider_EnemyCar' or other.name == 'Collider_EnemyHeli' or other.name == 'Collider_Bullet':
		return
	
	SignalEmitter.player_hit.emit()
	queue_free()
