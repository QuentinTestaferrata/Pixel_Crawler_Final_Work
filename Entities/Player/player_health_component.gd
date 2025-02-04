extends Node
class_name PlayerHealthComponent

signal health_changed
signal died

@export var hittable: bool = false

var current_health: int = StatsManager.current_health
var max_health: int = StatsManager.max_health

@onready var state_machine: PlayerStateMachine = $"../StateMachine"

func _ready() -> void:
	current_health = max_health
	max_health = StatsManager.max_health
	current_health = max_health
	##print(max_health, "/", current_health)

func heal(amount: int) -> void:
	if StatsManager.current_health + amount > StatsManager.max_health:
		StatsManager.current_health = StatsManager.max_health
		StatsManager.health_changed.emit()
	elif amount < 0:
		print("Can't heal a negative amount")
	else: 
		StatsManager.current_health += amount
		StatsManager.health_changed.emit()

func take_damage(amount: int) -> void:
	if hittable: 
		if current_health - amount <= 0:
			current_health = 0
			StatsManager.current_health = current_health
			StatsManager.health_changed.emit()
			StatsManager.player_died.emit()
			state_machine.force_change_state("die")
			died.emit()
			_on_player_died()
		elif amount < 0:
			print("Can't take a positive amount of damage")
			return
		else:
			current_health -= amount
			StatsManager.current_health = current_health
			StatsManager.health_changed.emit()
			health_changed.emit()

func _on_player_died() -> void:
	#TODO remove level, lower stats, etc
	pass

func _set_max_health(amount: int) -> void:
	max_health += amount
