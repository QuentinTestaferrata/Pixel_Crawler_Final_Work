extends PanelContainer

@export var time_between_waves: int

var seconds_waited: int
var wave: int
var wave_manager: Node

@onready var text: Label = $Text
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	wave_manager = get_tree().get_first_node_in_group("wave_manager")
	wave = wave_manager.current_wave
	text.text = str("Starting wave ", wave, " in: ", time_between_waves)
	timer.start()


func _on_timer_timeout() -> void:
	if time_between_waves != 0:
		time_between_waves -= 1
		text.text = str("Starting wave ", wave, " in: ", time_between_waves)
	else:
		timer.stop()
		wave_manager.start_wave()
		animation_player.play("start_wave")
