extends Node2D


@export var max_selection: int = 0

var current_selection: int = 0
const SHOP_TEXTS: Array[String] = [
    '> Repair car (5$)\nBetter motor (15$)\nLeave shop',
    'Repair car (5$)\n> Better motor (15$)\nLeave shop',
    'Repair car (5$)\nBetter motor (15$)\n> Leave shop',
]
const SHOP_TEXTS_MOTOR_UPGRADED: Array[String] = [
    '> Repair car (5$)\nSOLD OUT\nLeave shop',
    'Repair car (5$)\nSOLD OUT\nLeave shop',
    'Repair car (5$)\nSOLD OUT\n> Leave shop',
]
const SHOP_DESCRIPTIONS: Array[String] = [
    'Fully restore your car.',
    'Makes you go faster. Good for ducks that need to evade bullets.',
    'Leave the shop.'
]

var shop_items: Label
var description: Label
var current_stats: Label

func _ready() -> void:
    shop_items = $ShopItems
    description = $Description
    current_stats = $CurrentStats

    shop_items.text = SHOP_TEXTS[current_selection] if not GameManager.has_motor_upgrade_1 else SHOP_TEXTS_MOTOR_UPGRADED[current_selection]
    description.text = '"Welcome to my shop!"'
    current_stats.text = 'Money: ' + str(GameManager.current_money) + '$\nCar: ' + str(GameManager.current_hp) + '/5 HP'

func _input(event: InputEvent) -> void:
    if event.is_action_pressed('car_down'):
        current_selection += 1

        # check if we have the motor upgrade and skip if yes
        if current_selection == 1:
            if GameManager.has_motor_upgrade_1:
                current_selection += 1

        if current_selection > max_selection:
            current_selection = 0

    if event.is_action_pressed('car_up'):
        current_selection -= 1

        # check if we have the motor upgrade and skip if yes
        if current_selection == 1:
            if GameManager.has_motor_upgrade_1:
                current_selection -= 1

        if current_selection < 0:
            current_selection = max_selection
    
    if event.is_action_pressed('ui_accept'):
        match current_selection:
            0:
                if GameManager.current_money < 5:
                    return
                if GameManager.current_hp == 5:
                    return

                GameManager.current_money -= 5
                GameManager.current_hp = 5
            1:
                if GameManager.current_money < 15:
                    return
                
                GameManager.current_money -= 15
                GameManager.current_car_speed = 125.0

                GameManager.has_motor_upgrade_1 = true

                current_selection = 2
            2:
                GameManager.current_stage += 1
                if not Fade.is_fading:
                    Fade.change_scene('res://Scenes/SceneRoad/SceneRoad.tscn', 0.1)
        
    shop_items.text = SHOP_TEXTS[current_selection] if not GameManager.has_motor_upgrade_1 else SHOP_TEXTS_MOTOR_UPGRADED[current_selection]
    # this if statement is a crime
    description.text = SHOP_DESCRIPTIONS[current_selection] if not Fade.is_fading else 'Come back soon!'
    current_stats.text = 'Money: ' + str(GameManager.current_money) + '$\nCar: ' + str(GameManager.current_hp) + '/5 HP'
