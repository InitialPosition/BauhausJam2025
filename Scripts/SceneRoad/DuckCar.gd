extends Node2D

var animation_car: AnimatedSprite2D
var animation_duck: AnimatedSprite2D
var animation_gun: AnimatedSprite2D
var particles_exhaust: GPUParticles2D
var particles_break_front: GPUParticles2D
var particles_break_back: GPUParticles2D

var animation_duck_start_y: float
var animation_gun_start_y: float
var particles_exhaust_start_y: float

# constant animation offset for car bobbing animation
# (we could do this using sprite.position.y, but this is a game jam)
const ANIM_OFFSET: int = 1

const CAR_MAX_SPEED: float = 2.0
const CAR_ACCEL: float = 0.3
const CAR_ACCEL_TURNING: float = 1.5
const CAR_ACCEL_BREAKING: float = 0.3

var CAR_X_BOUNDARIES: Vector2 = Vector2(15, DisplayServer.window_get_size().x / ConfigValues.screen_scale - 15)
var CAR_Y_BOUNDARIES: Vector2 = Vector2(48, DisplayServer.window_get_size().y / ConfigValues.screen_scale - 8)

# holds the calculated movement for the current frame
var current_movement: Vector2 = Vector2.ZERO
var current_speed_change: float = 0.0
var current_target_speed: float = 0.0

func _ready() -> void:
	print(DisplayServer.window_get_size() / ConfigValues.screen_scale)
	# get handlers
	animation_car = $Animation_Car
	animation_duck = animation_car.get_node('Animation_Duck')
	animation_gun = animation_car.get_node('Animation_Gun')

	particles_exhaust = animation_car.get_node('Particles_Exhaust')
	particles_break_front = animation_car.get_node('Particles_Break_Front')
	particles_break_back = animation_car.get_node('Particles_Break_Back')

	particles_break_front.emitting = false
	particles_break_back.emitting = false

	# get start positions for 
	# register car frame change controller to control duck and gun height
	animation_duck_start_y = animation_duck.position.y
	animation_gun_start_y = animation_gun.position.y
	particles_exhaust_start_y = particles_exhaust.position.y
	animation_car.frame_changed.connect(_on_car_frame_changed)

	animation_car.play('default')

func _on_car_frame_changed() -> void:
	if animation_car.animation == 'default':
		if animation_car.frame == 1:
			animation_duck.position.y += ANIM_OFFSET
			animation_gun.position.y += ANIM_OFFSET
			particles_exhaust.position.y += ANIM_OFFSET
		else:
			animation_duck.position.y -= ANIM_OFFSET
			animation_gun.position.y -= ANIM_OFFSET
			particles_exhaust.position.y -= ANIM_OFFSET
	else:
		animation_duck.position.y = animation_duck_start_y
		animation_gun.position.y = animation_gun_start_y
		particles_exhaust.position.y = particles_exhaust_start_y

func _process(delta: float) -> void:
	# process input
	var horizontal_movement: float = Input.get_axis('car_left', 'car_right')
	var vertical_movement: float = Input.get_axis('car_up', 'car_down')

	particles_break_front.emitting = false
	particles_break_back.emitting = false

	if horizontal_movement:
		if horizontal_movement > 0:
			animation_car.play('accel')
		else:
			animation_car.play('break')
			particles_break_front.emitting = true
			particles_break_back.emitting = true

		var current_h_speed: float = horizontal_movement * delta
		current_speed_change = CAR_ACCEL
		current_target_speed = CAR_MAX_SPEED * sign(horizontal_movement)

		if current_h_speed > 0 and current_movement.x < 0 or current_h_speed < 0 and current_movement.x > 0:
			current_speed_change = CAR_ACCEL_TURNING
			current_target_speed = 0

		current_movement.x = move_toward(current_movement.x, current_target_speed, current_speed_change)
	else:
		animation_car.play('default')
		current_movement.x = move_toward(current_movement.x, 0, CAR_ACCEL_BREAKING)
	
	if vertical_movement:
		var current_v_speed: float = vertical_movement * delta
		current_speed_change = CAR_ACCEL
		current_target_speed = CAR_MAX_SPEED * sign(vertical_movement)

		if current_v_speed > 0 and current_movement.y < 0 or current_v_speed < 0 and current_movement.y > 0:
			current_speed_change = CAR_ACCEL_TURNING
			current_target_speed = 0

		current_movement.y = move_toward(current_movement.y, current_target_speed, current_speed_change)
	else:
		current_movement.y = move_toward(current_movement.y, 0, CAR_ACCEL_BREAKING)
	
	# clamp max speed
	if current_movement.x > CAR_MAX_SPEED:
		current_movement.x = CAR_MAX_SPEED
	if current_movement.y > CAR_MAX_SPEED:
		current_movement.y = CAR_MAX_SPEED
	
	# stop at boundaries
	if current_movement.x < 0:
		if global_position.x - current_movement.x < CAR_X_BOUNDARIES.x:
			current_movement.x = 0
	elif current_movement.x > 0:
		if global_position.x + current_movement.x > CAR_X_BOUNDARIES.y:
			current_movement.x = 0
	
	if current_movement.y < 0:
		if global_position.y - current_movement.y < CAR_Y_BOUNDARIES.x:
			current_movement.y = 0
	elif current_movement.y > 0:
		if global_position.y + current_movement.y > CAR_Y_BOUNDARIES.y:
			current_movement.y = 0
	
	SignalEmitter.player_moved.emit(global_position)
	
	global_position += current_movement
