extends PanelContainer

@onready var health_potion_cooldown: Timer = $HealthPotionCooldown
@onready var speed_potion_cooldown: Timer = $SpeedPotionCooldown
<<<<<<< Updated upstream
@onready var health_potion: TextureButton = $MarginContainer/HBoxContainer/VBoxContainer/HealthPotion
@onready var speed_potion: TextureButton = $MarginContainer/HBoxContainer/VBoxContainer2/SpeedPotion
@onready var speed_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer2/SpeedPotion/SpeedBar
@onready var health_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/HealthPotion/HealthBar
=======
@onready var health_potion: TextureButton = $MarginContainer/HBoxContainer/HealthPotion
@onready var speed_potion: TextureButton = $MarginContainer/HBoxContainer/SpeedPotion

@onready var health_bar: ProgressBar = $MarginContainer/HBoxContainer/HealthPotion/HealthBar
@onready var speed_bar: ProgressBar = $MarginContainer/HBoxContainer/SpeedPotion/SpeedBar
>>>>>>> Stashed changes

@export var health_cooldown: int
@export var speed_cooldown: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("heal") && health_bar.value == 0:
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

<<<<<<< Updated upstream
func _on_health_potion_cooldown_timeout() -> void:
	if health_bar.value > 0:
		health_bar.value -= 3.3
	else:
		health_potion_cooldown.stop()

func _on_speed_potion_cooldown_timeout() -> void:
	if speed_bar.value > 0:
		speed_bar.value -= 1.6
=======

func _on_health_potion_cooldown_timeout() -> void:
	if health_bar.value > 0:
		health_bar.value -= 10
	else:
		health_potion_cooldown.stop()


func _on_speed_potion_cooldown_timeout() -> void:
	if speed_bar.value > 0:
		speed_bar.value -= 5
>>>>>>> Stashed changes
	else:
		speed_potion_cooldown.stop()
