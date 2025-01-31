class_name SavedGame
extends Resource

@export_category("Player Inventory")
@export var items : Array[Item]
@export var weapons: Array[WeaponData]

@export_category("Player Stats")
@export var gold: int
@export var current_exp: int
@export var needed_exp: int
@export var level: int
@export var current_hp: int
@export var total_hp: int
