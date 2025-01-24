extends PanelContainer

const CASTLE = preload("res://Entities/Zones/castle.tscn")
const WAVE_TIMER = preload("res://UI/wave_finished_dialog/wave_timer.tscn")

@onready var wave_label: Label = $MarginContainer/VBoxContainer/Wave_label
@onready var next_wave_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/NextWaveButton/NextWaveLabel
@onready var leave_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/BackToLobbyButton/LeaveLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var HUD: CanvasLayer
var wave: int
var wave_manager: Node

func _ready() -> void:
	HUD = get_parent()
	wave_manager = get_tree().get_first_node_in_group("wave_manager")
	wave = wave_manager.current_wave
	wave_label.text = str("wave ", wave, " completed!")
	next_wave_label.text = "Next wave"
	leave_label.text = "Leave"

func _on_next_wave_button_pressed() -> void:
	animation_player.play("next_wave")
	var temp_wave_timer = WAVE_TIMER.instantiate()
	HUD.add_child(temp_wave_timer)
	queue_free()
	

func _on_back_to_lobby_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Entities/Zones/castle.tscn")
