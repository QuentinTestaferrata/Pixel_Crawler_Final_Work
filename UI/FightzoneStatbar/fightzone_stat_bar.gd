extends Control

@onready var kills_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/KillsLabel
@onready var kills_left: TextureRect = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/KillsLeft
@onready var kills_left_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer4/KillsLeftLabel
@onready var hud_fightzone: CanvasLayer = $".."

var wave_manager

func _ready() -> void:
	#Connect signals
	hud_fightzone.kill.connect(update_kill_label)
	hud_fightzone.kill.connect(update_kills_left_label)
	hud_fightzone.wave_cleared.connect(update_wave_label)
	
	wave_manager = get_parent().get_parent().get_node("WaveManager")
	update_kills_left_label()

func update_wave_label() -> void:
	pass

func update_kill_label() -> void:
	kills_label.text = str(wave_manager.total_kills)

func update_kills_left_label() -> void:
	kills_left_label.text = str(wave_manager.current_wave_kills, "/", wave_manager.enemies_per_wave)
