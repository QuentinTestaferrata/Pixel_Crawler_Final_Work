extends Node

@export var player:Player


func save_game():
	var saved_game : SavedGame = SavedGame.new()
	print("this is saved, ", player.inventory.content)
	
	#inventory
	saved_game.inventory = player.inventory.content
	print("saved potions: ", saved_game.inventory[0].amount)
	#Potions
	print(StatsManager.current_potions)
	saved_game.current_potions = StatsManager.current_potions
	saved_game.max_potions = StatsManager.max_potions
	
	ResourceSaver.save(saved_game, "res://savegame.tres")

	print("Saving")

func load_game() -> void:
	var saved_game:SavedGame = load("res://savegame.tres") as SavedGame
	
	#inventory
	player.inventory.content = saved_game.inventory
	
	#Potions
	StatsManager.current_potions = saved_game.current_potions
	StatsManager.max_potions = saved_game.max_potions
	
	print("Loading")
