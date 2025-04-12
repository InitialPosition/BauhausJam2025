extends Node2D


var EnemyCar: Resource = preload('res://Scenes/SceneRoad/EnemyCar.tscn')
var timer_spawn_car: Timer
const CAR_SPAWN_LOCATIONS: Array[Vector2] = [
	Vector2(-70, 60),
	Vector2(254, 60)
]
var MAX_CARS: int = GameManager.MAX_CARS_PER_STAGE[GameManager.current_stage] if GameManager.current_stage <= 4 else GameManager.current_stage
var current_cars: int = 0

var EnemyHeli: Resource = preload('res://Scenes/SceneRoad/EnemyHelicopter.tscn')
var timer_spawn_heli: Timer
const HELI_SPAWN_LOCATIONS: Array[Vector2] = [
	Vector2(-48, 12),
	Vector2(240, 12)
]
var MAX_HELIS: int = GameManager.MAX_HELIS_PER_STAGE[GameManager.current_stage] if GameManager.current_stage <= 4 else GameManager.current_stage - 2
var current_helis: int = 0

func _ready() -> void:
	timer_spawn_car = Timer.new()
	add_child(timer_spawn_car)

	timer_spawn_car.timeout.connect(_spawn_enemy_car)
	timer_spawn_car.start(6.0)

	timer_spawn_heli = Timer.new()
	add_child(timer_spawn_heli)

	timer_spawn_heli.timeout.connect(_spawn_enemy_heli)
	timer_spawn_heli.start(15.0)

	SignalEmitter.enemy_defeated.connect(_on_enemy_defeated)

func _spawn_enemy_car():
	timer_spawn_car.start(randf_range(4.0, 8.0))

	# cancel if we have max amount of cars
	if current_cars >= MAX_CARS:
		return

	print('Spawning car')
	# find place to spawn car
	var spawn_location = CAR_SPAWN_LOCATIONS.pick_random()
	var new_car = EnemyCar.instantiate()
	add_child(new_car)

	new_car.global_position = spawn_location

	current_cars += 1

func _spawn_enemy_heli():
	timer_spawn_heli.start(randf_range(8.0, 15.0))

	# cancel if we have max amount of cars
	if current_helis >= MAX_HELIS:
		return

	print('Spawning heli')
	# find place to spawn heli
	var spawn_location = HELI_SPAWN_LOCATIONS.pick_random()
	var new_heli = EnemyHeli.instantiate()
	add_child(new_heli)

	new_heli.global_position = spawn_location

	current_helis += 1

func _on_enemy_defeated(other):
	match other:
		GameManager.SCORE_ENEMY_CAR:
			current_cars -= 1
		GameManager.SCORE_ENEMY_HELI:
			current_helis -= 1
