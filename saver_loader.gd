extends Node
class_name SaverLoader

@export var player:Player

func save_game():
	var saved_game : SavedGame = SavedGame.new()
	
	#inventory
	saved_game.items = player.inventory.content

	#Potions
	saved_game.gold = StatsManager.gold
	saved_game.current_exp = StatsManager.exp_current
	saved_game.needed_exp = StatsManager.exp_needed
	saved_game.level = StatsManager.level
	saved_game.current_hp = StatsManager.current_health
	saved_game.total_hp = StatsManager.max_health
	
	ResourceSaver.save(saved_game, "res://savegame.tres")

	print("Saving")

func load_game() -> void:
	var saved_game:SavedGame = load("res://savegame.tres") as SavedGame
	
	#inventory
	player.inventory.content = saved_game.items
	
	StatsManager.gold = saved_game.gold
	StatsManager.exp_current = saved_game.current_exp
	StatsManager.exp_needed = saved_game.needed_exp
	StatsManager.level = saved_game.level
	StatsManager.current_health = saved_game.current_hp
	StatsManager.max_health = saved_game.total_hp
	
	print("Loading")
