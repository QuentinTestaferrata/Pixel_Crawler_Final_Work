extends Node

@onready var saver_loader: SaverLoader = $SaverLoader
@onready var enemies: Node2D = $Enemies
@onready var animations: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	saver_loader.load_game()
	AttackCooldowns.instantiate_cooldown_container()
	animations.play("load")

func play_unload_animation() -> void:
	animations.play("change_scene")
