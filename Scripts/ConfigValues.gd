extends Node2D

var fullscreen: bool = false

var volume_main: float = 0.5
var volume_music: float = 0.5
var volume_sfx: float = 0.5
var volume_music_effective: float = linear_to_db(volume_main * volume_music)
var volume_sfx_effective: float = linear_to_db(volume_main * volume_sfx)

var screen_scale: int = 1

func update_volumes():
	volume_music_effective = linear_to_db(volume_main * volume_music)
	volume_sfx_effective = linear_to_db(volume_main * volume_sfx)

func set_volume_main(new_value):
	volume_main = new_value
	update_volumes()

func set_volume_music(new_volume):
	volume_music = new_volume
	update_volumes()

func set_volume_sfx(new_volume):
	volume_sfx = new_volume
	update_volumes()
