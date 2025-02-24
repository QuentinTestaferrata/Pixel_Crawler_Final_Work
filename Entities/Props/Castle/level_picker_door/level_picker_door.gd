extends Node2D

const DUNGEON_LEVEL_PICKER = preload("res://UI/LevelPicker/dungeon/dungeon_level_picker.tscn")

@export var all_zones: Array[PackedScene]

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	var level_info: Control = all_zones[0].instantiate()
	var canvas_layer: CanvasLayer = get_parent().get_child(0)
	canvas_layer.add_child(level_info)
