extends Node2D


signal resolution_changed(old_resolution: int, new_resolution: int)
signal fullscreen_changed(is_now_fullscreen: bool)
signal settings_saved
signal settings_loaded

signal bullet_fired

signal enemy_defeated(score: int)

signal player_moved(new_pos: Vector2)
signal player_hit

signal road_game_complete

signal money_collected
