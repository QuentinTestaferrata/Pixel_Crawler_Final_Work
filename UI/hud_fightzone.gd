extends CanvasLayer

@onready var wave_manager: Node = $"../WaveManager"
@onready var mob_manager: Node = $"../MobManager"
@onready var enemies: Node2D = $"../Enemies"

signal kill
signal wave_cleared

@export var saver_loader: Node

func _ready() -> void:
	wave_manager.connect("enemy_killed", enemy_killed)
	wave_manager.connect("wave_cleared", wave_ended)
	visible = true

func wave_ended() -> void:
	wave_cleared.emit()

func enemy_killed() -> void:
	kill.emit()

func save_game() -> void:
	saver_loader.save_game()
	print("Game saved succesfully")
