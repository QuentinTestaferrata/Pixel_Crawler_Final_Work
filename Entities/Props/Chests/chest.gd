extends StaticBody2D

const WEAPON_INVENTORY = preload("uid://bysjiaycf68tt")

@export var HUDLayer: CanvasLayer
var temp_weapon_inventory
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	if temp_weapon_inventory == null:
		temp_weapon_inventory = WEAPON_INVENTORY.instantiate()
		HUDLayer.add_child(temp_weapon_inventory)
	else:
		pass
