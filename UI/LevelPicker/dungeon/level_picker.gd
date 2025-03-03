extends Control

signal next_pressed
signal prev_pressed

@export var _zone: PackedScene
@export var close_button: TextureButton

var _hud: CanvasLayer
var ability_cooldowns: PanelContainer
var zone: Node2D

@onready var dungeon_image: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/DungeonImage
@onready var available_loot: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/AvailableLoot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var next_button: Button = $NextButton
@onready var previous_button: Button = $PreviousButton

func _ready() -> void:
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	ability_cooldowns.visible = false
	
	zone = get_parent().get_parent()
	
	next_button.connect("pressed", _next_pressed)
	close_button.pressed.connect(close_window)
	previous_button.pressed.connect(_previous_pressed)

func _on_start_button_pressed() -> void:
	_hud = get_parent()
	_hud.saver_loader.save_game()
	#ability_cooldowns.visible = true
	zone.play_unload_animation()
	await get_tree().create_timer(.6).timeout
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
		ability_cooldowns.visible = true

func close_window() -> void:
	ability_cooldowns.visible = true
	queue_free()
