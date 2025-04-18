extends Node2D


func _ready() -> void:
    SignalEmitter.bullet_fired.connect(_on_bullet_fired)

func _on_bullet_fired(new_bullet: Node2D):
    add_child(new_bullet)