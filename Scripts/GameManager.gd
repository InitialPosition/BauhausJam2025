extends Node2D


# ingame values
var current_score: int = 0
var current_stage: int = 3

var saved_player_position: Vector2 = Vector2.ZERO
var current_hp: int = 5
var current_money: int = 0

var bullet_firing_speed: float = 0.2
var bullet_spread: Vector2 = Vector2(0.2, 0.2)

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

func reset_game_manager():
	current_score = 0
	current_stage = 1

func _on_enemy_defeated(score: int):
	current_score += score

func _on_player_move(new_pos: Vector2):
	saved_player_position = new_pos

func _on_player_hit():
	current_hp -= 1
	if current_hp == 0:
		Engine.time_scale = 0.1
