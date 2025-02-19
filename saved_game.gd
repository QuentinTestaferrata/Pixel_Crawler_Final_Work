class_name SavedGame
extends Resource

@export_category("Player Inventory")
@export var items : Array[Item]
@export var weapons: Array[WeaponData]

@export_category("Shop Items")
@export var shop_items: Array[Item]
@export var shop_weapons: Array[WeaponData]

@export_category("Equipped Weapons")
@export var equiped_weapon_1: WeaponData
@export var equiped_weapon_2: WeaponData

@export_category("Player Stats")
@export var gold: int
@export var current_exp: int
@export var needed_exp: int
@export var level: int
@export var current_hp: int
@export var total_hp: int

@export_category("Quests")
@export var quests : Array[Quest]
@export var player_quests : Array[Quest]
