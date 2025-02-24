extends StaticBody2D

const WEAPON_INVENTORY = preload("res://UI/Weapon Inventory/weapon_inventory.tscn")

@export var HUDLayer: CanvasLayer

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	var temp_weapon_inventory = WEAPON_INVENTORY.instantiate()
	HUDLayer.add_child(temp_weapon_inventory)
