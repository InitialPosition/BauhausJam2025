extends Node2D

const MONEY_SPEED: float = 64.0
var collider: Area2D

func _ready() -> void:
    collider = $Collider_Money
    collider.area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
    global_position.x -= MONEY_SPEED * delta

    if global_position.x < -50:
        queue_free()

func _on_area_entered(other: Area2D):
    print(other.name)
    match other.name:
        'Collider_DuckCar':
            SignalEmitter.money_collected.emit()
            queue_free()
