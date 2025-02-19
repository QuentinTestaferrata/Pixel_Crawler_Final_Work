extends Node

const ABILITY_COOLDOWN_CONTAINER = preload("res://UI/Ability Cooldowns/ability_cooldown_container.tscn")

@onready var saver_loader: SaverLoader = $SaverLoader
@onready var enemies: Node2D = $Enemies

func _ready() -> void:
	saver_loader.load_game()
	AttackCooldowns.instantiate_cooldown_container()
