extends Node2D

@export var animations: AnimationPlayer

@onready var saver_loader: SaverLoader = $SaverLoader

func _ready() -> void:
	saver_loader.load_game()
	AttackCooldowns.instantiate_cooldown_container()
	animations.play("load")

func play_unload_animation() -> void:
	animations.play("change_scene")
