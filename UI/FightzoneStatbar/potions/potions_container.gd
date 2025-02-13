extends PanelContainer

@onready var health_potion_cooldown: Timer = $HealthPotionCooldown
@onready var speed_potion_cooldown: Timer = $SpeedPotionCooldown
@onready var health_potion: TextureButton = $MarginContainer/HBoxContainer/VBoxContainer/HealthPotion
@onready var speed_potion: TextureButton = $MarginContainer/HBoxContainer/VBoxContainer2/SpeedPotion
@onready var speed_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer2/SpeedPotion/SpeedBar
@onready var health_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/HealthPotion/HealthBar

var player: CharacterBody2D

@export var health_cooldown: int
@export var speed_cooldown: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("heal") && health_bar.value == 0:
		player.play_heal_animation()
		health_potion_cooldown.start()
		health_potion.button_pressed = true
		health_bar.value = 100
	if event.is_action_released("heal"):
		health_potion.button_pressed = false
	
	elif event.is_action_pressed("speed") && speed_bar.value == 0:
		speed_potion_cooldown.start()
		speed_potion.button_pressed = true
		speed_bar.value = 100
	if event.is_action_released("speed"):
		speed_potion.button_pressed = false

func _on_health_potion_cooldown_timeout() -> void:
	if health_bar.value > 0:
		health_bar.value -= 3.3
	else:
		health_potion_cooldown.stop()

func _on_speed_potion_cooldown_timeout() -> void:
	if speed_bar.value > 0:
		speed_bar.value -= 1.6
	else:
		speed_potion_cooldown.stop()
