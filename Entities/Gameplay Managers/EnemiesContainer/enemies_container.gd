extends Node

signal enemy_died

func _ready() -> void:
	pass

func emit_kill_signal() -> void:
	enemy_died.emit()
