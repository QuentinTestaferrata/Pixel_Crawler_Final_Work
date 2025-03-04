extends Node

@export var player: Player

@onready var saver_loader: SaverLoader = $SaverLoader
@onready var enemies: Node2D = $Enemies
@onready var animations: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	saver_loader.load_game()
	AttackCooldowns.instantiate_cooldown_container()
	player.set_camera_zoom(0.7)
	animations.play("load")

func play_unload_animation() -> void:
	animations.play("change_scene")
