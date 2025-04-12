extends Node2D


var is_player_bullet: bool = false

const BULLET_SPEED: float = 150.0
var movement_vector: Vector2 = Vector2.ZERO

const OOB_REMOVE_MARGIN: float = 50.0

var shot_parent: String

@onready var window_size: Vector2 = DisplayServer.window_get_size()
@onready var collider: Area2D = $Collider_Bullet
func _ready() -> void:
	collider.area_entered.connect(_on_area_enter)

func _process(delta: float) -> void:
	global_position.x += movement_vector.x * BULLET_SPEED * delta
	global_position.y += movement_vector.y * BULLET_SPEED * delta
	
	# remove outside room (ugly but this is still a game jam)
	if global_position.x < -OOB_REMOVE_MARGIN or global_position.x > window_size.x + OOB_REMOVE_MARGIN or global_position.y < -OOB_REMOVE_MARGIN or global_position.y > window_size.y + OOB_REMOVE_MARGIN:
		queue_free()

func _on_area_enter(other):
	# ignore player bullets for the player
	if other.name == shot_parent or other.name == 'Collider_Bullet_Enemy' or other.name == 'Collider_Money' or other.name == 'Collider_Bullet':
		return
	
	queue_free()
