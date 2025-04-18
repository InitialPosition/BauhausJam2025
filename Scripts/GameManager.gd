extends Node2D


# ingame values
var current_score: int
var current_stage: int

var saved_player_position: Vector2
var current_hp: int
var current_money: int

var current_car_speed: float

var bullet_firing_speed: float
var bullet_spread: Vector2

# purchases
var has_motor_upgrade_1: bool
var has_fire_rate_upgrade: bool
var has_fire_accuracy_upgrade: bool

const MAX_CARS_PER_STAGE: Dictionary[int, int] = {
	1: 3,
	2: 4,
	3: 4,
	4: 5
}
const MAX_HELIS_PER_STAGE: Dictionary[int, int] = {
	1: 0,
	2: 1,
	3: 1,
	4: 2
}

# score values
const SCORE_ENEMY_CAR: int = 5000
const SCORE_ENEMY_HELI: int = 10000

func _ready() -> void:
	SignalEmitter.enemy_defeated.connect(_on_enemy_defeated)
	SignalEmitter.player_moved.connect(_on_player_move)
	SignalEmitter.player_hit.connect(_on_player_hit)

	reset_game_manager()

func reset_game_manager():
	saved_player_position = Vector2.ZERO

	current_score = 0
	current_stage = 1

	current_car_speed = 80.0

	current_money = 10
	current_hp = 5

	bullet_spread = Vector2(0.2, 0.2)
	bullet_firing_speed = 0.2

	has_motor_upgrade_1 = false
	has_fire_rate_upgrade = false
	has_fire_accuracy_upgrade = false

	Engine.time_scale = 1.0

func _on_enemy_defeated(score: int):
	current_score += score

func _on_player_move(new_pos: Vector2):
	saved_player_position = new_pos

func _on_player_hit():
	current_hp -= 1
	if current_hp == 0:
		Engine.time_scale = 0.3
		if not Fade.is_fading:
			Fade.change_scene('res://Scenes/GameOverScene.tscn', 0.01)
