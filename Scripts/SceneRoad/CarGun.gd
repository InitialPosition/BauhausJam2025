extends AnimatedSprite2D

const UPL_DIRECTION: float = 0.75 * PI
const UP_DIRECTION: float = 0.5 * PI
const UPR_DIRECTION: float = 0.25 * PI
const R_DIRECTION: float = 0.0

const UPL_BULLET_VECTOR: Vector2 = Vector2(-1, -1)
const UP_BULLET_VECTOR: Vector2 = Vector2(0, -1)
const UPR_BULLET_VECTOR: Vector2 = Vector2(1, -1)
const R_BULLET_VECTOR: Vector2 = Vector2(1, 0)

var current_bullet_spread: Vector2 = GameManager.bullet_spread
var current_bullet_firing_speed: float = GameManager.bullet_firing_speed

var Bullet: Resource = preload('res://Scenes/SceneRoad/Bullet.tscn')
var bullet_timer: Timer

func _ready() -> void:
	bullet_timer = Timer.new()
	add_child(bullet_timer)

	bullet_timer.one_shot = false
	bullet_timer.stop()
	bullet_timer.timeout.connect(_on_bullet_timer_timeout)

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var angle_to_mouse = get_angle_to(mouse_pos)

	# if mouse is under car, set hard left or hard right
	if sign(angle_to_mouse) > 0:
		if angle_to_mouse < PI / 2:
			frame = 0
		else:
			frame = 4
	else:
		# iterate over all angles and find which one is closest to the mouse angle
		var best_match: float = INF
		var best_direction: float = INF
		for current_direction in [UPL_DIRECTION, UP_DIRECTION, UPR_DIRECTION, R_DIRECTION]:
			var abs_angle: float = abs(abs(angle_to_mouse) - current_direction)
			if abs_angle < best_match:
				best_match = abs_angle
				best_direction = current_direction

		# set the animation frame based on which direction fits best
		match best_direction:
			UPL_DIRECTION:
				frame = 3
			UP_DIRECTION:
				frame = 2
			UPR_DIRECTION:
				frame = 1
			R_DIRECTION:
				frame = 0

func _on_bullet_timer_timeout():
	$AudioShoot.pitch_scale = randf_range(0.9, 1.1)
	$AudioShoot.play()
	
	var new_bullet = Bullet.instantiate()

	new_bullet.is_player_bullet = true
	new_bullet.global_position = global_position
	new_bullet.shot_parent = 'Collider_DuckCar'

	# generate bullet vector
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var bullet_movement: Vector2 = mouse_pos - global_position
	bullet_movement = bullet_movement.normalized()
	
	bullet_movement.x += randf_range(-current_bullet_spread.x, current_bullet_spread.x)
	bullet_movement.y += randf_range(-current_bullet_spread.y, current_bullet_spread.y)
	
	new_bullet.movement_vector = bullet_movement

	SignalEmitter.bullet_fired.emit(new_bullet)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			# fire once when starting
			# this allows for rapid fire when rapid clicking, but i'll allow it
			_on_bullet_timer_timeout()
			bullet_timer.start(current_bullet_firing_speed)
		else:
			bullet_timer.stop()
