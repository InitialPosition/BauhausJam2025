extends Node2D

var animation_heli: AnimatedSprite2D
var collider: Area2D

var particles_exhaust_start_y: float

var target_position: Vector2

var hitpoints: int = 20

var flicker_timer: Timer
const HIT_FLICKER_LENGTH: float = 0.05

var new_position_timer: Timer
var new_position_duration: float

const CAR_SPEED: float = 75.0

var CAR_X_BOUNDARIES: Vector2 = Vector2(15, DisplayServer.window_get_size().x / ConfigValues.screen_scale - 15)
var CAR_Y_BOUNDARIES: Vector2 = Vector2(8, (DisplayServer.window_get_size().y / ConfigValues.screen_scale) / 2 - 16)

var shoot_timer: Timer
var shoot_cooldown: float

var Bullet: Resource = preload('res://Scenes/SceneRoad/BulletEnemy.tscn')

# constant animation offset for car bobbing animation
# (we could do this using sprite.position.y, but this is a game jam)
const ANIM_OFFSET: int = 1

func _ready() -> void:
	# get handlers
	animation_heli = $Animation_Heli
	collider = $Collider_EnemyHeli

	collider.area_entered.connect(_on_area_enter)

	flicker_timer = Timer.new()
	add_child(flicker_timer)

	flicker_timer.one_shot = true
	flicker_timer.timeout.connect(_on_flicker_timer_end)

	move_to_new_position()

	new_position_timer = Timer.new()
	add_child(new_position_timer)
	new_position_timer.one_shot = true
	new_position_timer.timeout.connect(_timer_move_to_new_position)

	_timer_move_to_new_position()

	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_timer_shoot_bullet)

	shoot_timer.start(3.0)

func set_target_position(new_pos: Vector2):
	target_position = new_pos

func generate_new_target_position() -> Vector2:
	var random_new_x: int = randi_range(CAR_X_BOUNDARIES.x, CAR_X_BOUNDARIES.y)
	var random_new_y: int = randi_range(CAR_Y_BOUNDARIES.x, CAR_Y_BOUNDARIES.y)
	var new_target: Vector2 = Vector2(random_new_x, random_new_y)

	return new_target

func move_to_new_position():
	var new_position = generate_new_target_position()
	set_target_position(new_position)

func _timer_move_to_new_position():
	new_position_duration = randf_range(6.0, 9.0)
	new_position_timer.start(new_position_duration)

	move_to_new_position()

func _timer_shoot_bullet():
	var new_bullet = Bullet.instantiate()
	add_child(new_bullet)

	new_bullet.global_position = global_position
	new_bullet.shot_parent = 'Collider_EnemyHeli'

	# calculate path to player and shoot
	var shoot_direction = GameManager.saved_player_position - new_bullet.global_position
	new_bullet.movement_vector = shoot_direction.normalized()
	
	shoot_cooldown = randf_range(4.0, 7.0)
	shoot_timer.start(shoot_cooldown)

func _process(delta: float) -> void:
	if global_position != target_position:
		global_position.x = move_toward(global_position.x, target_position.x, delta * CAR_SPEED)
		global_position.y = move_toward(global_position.y, target_position.y, delta * CAR_SPEED)

func _on_area_enter(other: Area2D):
	match other.name:
		'Collider_Bullet':
			visible = false
			flicker_timer.start(HIT_FLICKER_LENGTH)

			hitpoints -= 1

			if hitpoints <= 0:
				SignalEmitter.enemy_defeated.emit(GameManager.SCORE_ENEMY_HELI)
				queue_free()

func _on_flicker_timer_end():
	visible = true
