extends Node2D


@export var max_selection: int = 0

var current_selection: int = 0
const SHOP_SOLD_OUT = 'SOLD OUT'
const SHOP_UPGRADE_ACCURACY = 'Upgrade accuracy'
const SHOP_UPGRADE_SPEED = 'Upgrade speed'
const SHOP_LEAVE = 'Leave'

var SHOP_TEXTS: Array[String] = [
    '> Upgrade accuracy (10$)\nUpgrade firing speed (10$)\nLeave',
    'Upgrade accuracy (10$)\n> Upgrade firing speed (10$)\nLeave',
    'Upgrade accuracy (10$)\nUpgrade firing speed (10$)\n> Leave',
]
const SHOP_DESCRIPTIONS: Array[String] = [
    'Makes aiming a lot easier.',
    'Upgrade your firing speed.',
    'Leave.'
]

var shop_items: Label
var description: Label
var current_stats: Label

func _ready() -> void:
    shop_items = $ShopItems
    description = $Description
    current_stats = $CurrentStats

    if GameManager.has_fire_accuracy_upgrade:
        current_selection += 1
        if GameManager.has_fire_rate_upgrade:
            current_selection += 1

    shop_items.text = SHOP_TEXTS[current_selection]
    current_stats.text = 'Money: ' + str(GameManager.current_money) + '$\nCar: ' + str(GameManager.current_hp) + '/5 HP'

func _input(event: InputEvent) -> void:
    if event.is_action_pressed('car_down'):
        current_selection += 1

        if current_selection > max_selection:
            current_selection = 0
        
        # check if we have the motor upgrade and skip if yes
        if current_selection == 0:
            if GameManager.has_fire_accuracy_upgrade:
                current_selection += 1
        if current_selection == 1:
            if GameManager.has_fire_rate_upgrade:
                current_selection += 1

    if event.is_action_pressed('car_up'):
        current_selection -= 1

        if current_selection < 0:
            current_selection = max_selection
        
        # check if we have the motor upgrade and skip if yes
        if current_selection == 1:
            if GameManager.has_fire_accuracy_upgrade:
                current_selection -= 1
        if current_selection == 0:
            if GameManager.has_fire_rate_upgrade:
                current_selection -= 1
    
    if event.is_action_pressed('ui_accept'):
        match current_selection:
            0:
                if GameManager.current_money < 10:
                    return

                GameManager.current_money -= 10
                GameManager.bullet_spread = Vector2(0.05, 0.05)
                GameManager.has_fire_accuracy_upgrade = true

                current_selection = 1 if not GameManager.has_fire_rate_upgrade else 2
            1:
                if GameManager.current_money < 10:
                    return
                
                GameManager.current_money -= 10
                GameManager.bullet_firing_speed = 0.1
                GameManager.has_fire_rate_upgrade = true

                current_selection = 2
            2:
                GameManager.current_stage += 1
                if not Fade.is_fading:
                    Fade.change_scene('res://Scenes/SceneRoad/SceneRoad.tscn', 0.1)
        
    shop_items.text = SHOP_TEXTS[current_selection]
    # this if statement is a crime
    description.text = SHOP_DESCRIPTIONS[current_selection] if not Fade.is_fading else 'You never saw me.'
    current_stats.text = 'Money: ' + str(GameManager.current_money) + '$\nCar: ' + str(GameManager.current_hp) + '/5 HP'
