extends Node

@export var stats: WEAPON

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Shield equipped: ", stats.WEAPON_TYPE)
