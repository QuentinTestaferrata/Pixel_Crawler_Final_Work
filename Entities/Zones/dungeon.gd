extends Node

const ABILITY_COOLDOWN_CONTAINER = preload("res://UI/Ability Cooldowns/ability_cooldown_container.tscn")

@onready var saver_loader: SaverLoader = $SaverLoader
@onready var enemies: Node2D = $Enemies

func _ready() -> void:
	saver_loader.load_game()
	var temp_container = ABILITY_COOLDOWN_CONTAINER.instantiate() 
	var _hud = get_tree().get_first_node_in_group("hud")
	_hud.add_child(temp_container)
