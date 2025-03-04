extends Node2D

@export var animations: AnimationPlayer
@export var player: Player
@onready var saver_loader: SaverLoader = $SaverLoader

func _ready() -> void:
	saver_loader.load_game()
	AttackCooldowns.instantiate_cooldown_container()
	player.set_camera_zoom(1.1)
	animations.play("load")

func play_unload_animation() -> void:
	animations.play("change_scene")
