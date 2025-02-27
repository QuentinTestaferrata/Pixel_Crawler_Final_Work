extends Node
class_name SaverLoader

@export var player:Player

func save_game():
	var saved_game : SavedGame = SavedGame.new()
	
	#Inventory
	saved_game.items = player.inventory.content
	saved_game.weapons = player.inventory.weapons
	saved_game.gears = player.inventory.gears
	
	#Shop Items
	saved_game.shop_items = StatsManager.shop_items
	saved_game.shop_resources = StatsManager.shop_resources
	saved_game.shop_weapons = StatsManager.shop_weapons
	saved_game.shop_gears = StatsManager.shop_gears
	
	#Active Weapons
	saved_game.equiped_weapon_1 = player.weapon_manager.equiped_weapon_1
	saved_game.equiped_weapon_2 = player.weapon_manager.equiped_weapon_2
	
	#Stats
	saved_game.gold = StatsManager.gold
	saved_game.current_exp = StatsManager.exp_current
	saved_game.needed_exp = StatsManager.exp_needed
	saved_game.level = StatsManager.level
	saved_game.current_hp = StatsManager.current_health
	saved_game.total_hp = StatsManager.max_health
	

	#Quests
	saved_game.quests = StatsManager.quests
	saved_game.player_quests = StatsManager.player_quests
	
	ResourceSaver.save(saved_game, "res://SaveFile/savegame.tres")

	print("Saving Game")

func load_game() -> void:
	var saved_game:SavedGame = load("res://SaveFile/savegame.tres") as SavedGame
	
	#Inventory
	player.inventory.content = saved_game.items
	player.inventory.weapons = saved_game.weapons
	player.inventory.gears = saved_game.gears
	
	#Shop Items
	StatsManager.shop_items = saved_game.shop_items
	StatsManager.shop_resources = saved_game.shop_resources
	StatsManager.shop_weapons = saved_game.shop_weapons 
	StatsManager.shop_gears = saved_game.shop_gears 
	
	#Active Weapons
	StatsManager.equiped_weapon_1 = saved_game.equiped_weapon_1
	StatsManager.equiped_weapon_2 = saved_game.equiped_weapon_2
	
	#Stats
	StatsManager.gold = saved_game.gold
	StatsManager.exp_current = saved_game.current_exp
	StatsManager.exp_needed = saved_game.needed_exp
	StatsManager.level = saved_game.level
	StatsManager.current_health = saved_game.current_hp
	StatsManager.max_health = saved_game.total_hp
	
# Quests
	StatsManager.quests = saved_game.quests 
	StatsManager.player_quests = saved_game.player_quests
	
	print("Loading")
