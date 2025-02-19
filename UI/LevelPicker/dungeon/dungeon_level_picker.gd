extends Control

#@export var _zone_name: String


var _hud: CanvasLayer

@onready var zone_name: Label = $PanelContainer/MarginContainer/VBoxContainer/ZoneName
@onready var dungeon_image: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/DungeonImage
@onready var available_loot: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/AvailableLoot

func _on_start_button_pressed() -> void:
	_hud = get_parent()
	_hud.saver_loader.save_game()
	get_tree().change_scene_to_file("res://Entities/Zones/FightZones/1_dungeon.tscn")
	#get_tree().change_scene_to_file("res://Entities/Zones/FightZones/2_cemetery.tscn")
	AttackCooldowns.reset_cooldowns()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		queue_free()
		print("Esc pressed")

func _ready() -> void:
	pass
