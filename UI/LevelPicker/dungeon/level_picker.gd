extends Control

signal next_pressed
signal prev_pressed

@export var _zone: PackedScene

var _hud: CanvasLayer

@onready var zone_name: Label = $PanelContainer/MarginContainer/VBoxContainer/ZoneName
@onready var dungeon_image: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/DungeonImage
@onready var available_loot: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/AvailableLoot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var next_button: Button = $NextButton
@onready var previous_button: Button = $PreviousButton

func _ready() -> void:
	next_button.connect("pressed", _next_pressed)
	previous_button.pressed.connect(_previous_pressed)

func _on_start_button_pressed() -> void:
	_hud = get_parent()
	_hud.saver_loader.save_game()
	get_tree().change_scene_to_file(_zone.resource_path)
	AttackCooldowns.reset_cooldowns()

func _next_pressed() -> void:
	next_pressed.emit()

func _previous_pressed() -> void:
	prev_pressed.emit()

func play_animation(anim_name: String) -> void: 
	animation_player.play(anim_name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		queue_free()
