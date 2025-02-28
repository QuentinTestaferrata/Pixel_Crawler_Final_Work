extends StaticBody2D


const GEAR_UI = preload("res://UI/Gear_UI/gear_ui.tscn")

var hud_layer: CanvasLayer

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	hud_layer = get_tree().get_first_node_in_group("hud")

func on_interact():
	var temp_gear_ui = GEAR_UI.instantiate()
	hud_layer.add_child(temp_gear_ui)
