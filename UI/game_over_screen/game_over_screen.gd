extends Control

const GAME_OVER_SCREEN = preload("res://UI/game_over_screen/GameOverScreen.tscn")
@onready var game_over_screen: Control = $"."
@onready var retry_button: TextureButton = $shader/ColorRect/HBoxContainer/RetryButton
@onready var back_to_castle_button: TextureButton = $shader/ColorRect/HBoxContainer/BackToCastleButton
@onready var quit_game_button: TextureButton = $shader/ColorRect/HBoxContainer/QuitGameButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var hud_layer: CanvasLayer
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	hud_layer = get_tree().get_first_node_in_group("hud")
	animation_player.play("fade_to_black")
# Change z_index player

# TODO: After button pressed player needs to go back to z index 0 

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Entities/Zones/dungeon.tscn")
	AttackCooldowns.reset_cooldowns()
	animation_player.play("fade_to_normal")
	StatsManager.current_health = StatsManager.max_health
	StatsManager.health_changed.emit()


func _on_back_to_castle_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Entities/Zones/castle.tscn")
	AttackCooldowns.reset_cooldowns()
	animation_player.play("fade_to_normal")
	StatsManager.current_health = StatsManager.max_health
	StatsManager.health_changed.emit()


func _on_quit_game_button_pressed() -> void:
	pass # Replace with function body.
