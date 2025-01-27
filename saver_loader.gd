extends Node

@export var player:Player
func save_game():
	var saved_game : SavedGame = SavedGame.new()
	print("this is saved, ", player.inventory.content)
	saved_game.inventory = player.inventory.content
	
	ResourceSaver.save(saved_game, "res://savegame.tres")

	print("Saving")
	print(player.inventory.content[0].amount)

func load_game() -> void:
	var saved_game:SavedGame = load("res://savegame.tres") as SavedGame
	player.inventory.content = saved_game.inventory
	print("Loading")
