extends Node2D


func _ready() -> void:
    # disable mouse
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta: float) -> void:
    global_position = get_viewport().get_mouse_position()
