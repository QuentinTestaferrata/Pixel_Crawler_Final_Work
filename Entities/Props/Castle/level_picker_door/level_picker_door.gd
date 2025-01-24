extends Node2D

const DUNGEON_LEVEL_PICKER = preload("res://UI/LevelPicker/dungeon/dungeon_level_picker.tscn")

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	var level_info: Control = DUNGEON_LEVEL_PICKER.instantiate()
	var canvas_layer: CanvasLayer = get_parent().get_child(0)
	canvas_layer.add_child(level_info)
