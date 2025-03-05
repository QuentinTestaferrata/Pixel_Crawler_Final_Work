extends Node

@onready var health_label: Label = $MarginContainer/Textlabels/VBoxContainer/HealthLabel
@onready var exp_label: Label = $MarginContainer/Textlabels/VBoxContainer/ExpLabel
@onready var level_label: Label = $MarginContainer/MarginContainer2/VBoxContainer/HBoxContainer/LevelLabel
@onready var coins_label: Label = $MarginContainer/MarginContainer2/VBoxContainer/HBoxContainer/CoinsLabel

@onready var exp_bar: TextureProgressBar = $MarginContainer/VBoxContainer/EXP/EXPBar
@onready var health_bar: TextureProgressBar = $MarginContainer/VBoxContainer/Health/HealthBar
var health

func _ready() -> void:
	StatsManager.exp_changed.connect(update_exp_label)
	StatsManager.level_changed.connect(update_level_label)
	StatsManager.health_changed.connect(update_health_label)
	StatsManager.healed.connect(update_health_label)
	StatsManager.gold_changed.connect(update_coins_label)
	
	update_health_label()
	update_exp_label()
	update_coins_label()
	update_level_label()

func update_health_label() -> void:
	health_label.text = str(StatsManager.current_health, "/", StatsManager.max_health)
func update_exp_label() -> void:
	exp_label.text = str(( int(StatsManager.exp_current)), "/", str( int(StatsManager.exp_needed) ))
func update_coins_label() -> void:
	coins_label.text = str(StatsManager.gold)
func update_level_label() -> void:
	level_label.text = str("LVL: ", StatsManager.level)
