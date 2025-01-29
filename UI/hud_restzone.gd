extends Node

class_name hud

var player: CharacterBody2D
var player_HP_Component: HealthComponent

@export var saver_loader: Node

func save_game() -> void:
	saver_loader.save_game()
	print("Game saved succesfully")
