class_name Player
extends CharacterBody2D

signal player_died

const INVENTORY_HUD = preload("res://UI/inventory/inventory_&_profile.tscn")
const PAUSE_MENU = preload("res://UI/Pause_Menu/pause_menu.tscn")

var speed: int = 140
var inventory: Inventory = Inventory.new()
var inventory_open: bool = false
var temp_pause_menu: PanelContainer

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var camera: Camera2D = $Camera
@onready var player_dash: GPUParticles2D = $PlayerDash
@onready var text_position: Node2D = $TextPosition
@onready var gpu_particles_2d: CPUParticles2D = $GPUParticles2D
@onready var shadow: Sprite2D = $Shadow

func on_item_picked_up(item: Item) -> void:
	inventory.add_item(item)

func _ready() -> void:
	player_dash.emitting = false

func _input(event: InputEvent) -> void:
	var hud_scene: CanvasLayer = get_parent().get_child(0)
	
	if event.is_action_pressed("open_inventory") and !inventory_open:
		var _inventory = INVENTORY_HUD.instantiate()
		hud_scene.add_child(_inventory)
		inventory_open = true
		
	elif event.is_action_pressed("open_inventory") and inventory_open:
		var temp_inv = hud_scene.find_child("Inventory", true, false)
		temp_inv.close_inventory()
		inventory_open = false
		
	if event.is_action_pressed("esc") and temp_pause_menu == null:
		temp_pause_menu = PAUSE_MENU.instantiate()
		hud_scene.add_child(temp_pause_menu)
		get_tree().paused = true
		
	elif event.is_action_pressed("esc") and temp_pause_menu != null:
		get_tree().paused = false
		var temp_menu = hud_scene.find_child("PauseMenu", true, false)
		temp_menu.close_menu()
	
	
	if event.is_action_pressed("heal") and StatsManager.current_potions > 0:
		StatsManager.current_potions -= 1
		play_heal_animation()

func play_heal_animation() -> void:
	gpu_particles_2d.top_level = false
	gpu_particles_2d.local_coords = true
	gpu_particles_2d.emitting = true

func display_message(text: String, color: Color, duration: float) -> void:
	print_debug("Message sent")
	var message = Label.new()
	
	message.global_position = Vector2(text_position.position.x - 13, text_position.position.y - 2)
	message.text = text
	message.z_index = 6
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.set_anchor(SIDE_TOP, 1)
	message.add_theme_font_override("font", load("res://Common/Poco.ttf"))
	
	message.label_settings = LabelSettings.new()
	message.label_settings.font_color = color
	message.label_settings.font_size = 9
	message.label_settings.outline_color = "#000"
	message.label_settings.outline_size = 3
	
	call_deferred("add_child", message)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(message, "position:y", message.position.y - 5, .5)
	if duration > .7:
		tween.tween_property(message, "scale", Vector2(1,1), (duration - .7))
	
	tween.tween_property(message, "modulate:a", 0, .2)
	tween.tween_callback(message.queue_free)

func flip_sprite() -> void:
	if character_sprite.flip_h == true:
		shadow.position.x -= 10
