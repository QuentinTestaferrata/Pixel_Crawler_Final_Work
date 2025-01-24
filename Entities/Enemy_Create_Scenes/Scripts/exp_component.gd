extends Node

@export var exp_amount: int
@onready var _health_component: HealthComponent = $"../HealthComponent"

func _ready():
	_health_component.health_depleted.connect(receive_exp)

func receive_exp() -> void:
	StatsManager.gain_exp(exp_amount)
