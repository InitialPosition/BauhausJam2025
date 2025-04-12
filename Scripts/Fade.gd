extends CanvasLayer


var animation_player: AnimationPlayer
var scene_reference: String

var is_fading: bool

func _ready() -> void:
	animation_player = $AnimationPlayer
	animation_player.animation_finished.connect(_on_animation_finished)

	animation_player.play('fade_out')

	is_fading = false

func change_scene(new_scene: String, delay: float = 0.5):
	is_fading = true
	scene_reference = new_scene

	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timeout)
	timer.one_shot = true
	timer.start(delay)

func _on_timeout():
	animation_player.play('fade')

func _on_animation_finished(anim_name: StringName):
	match anim_name:
		'fade':
			get_tree().change_scene_to_file(scene_reference)
			animation_player.play('fade_out')

			is_fading = false
