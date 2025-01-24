extends EnemyState

@onready var state_machine: EnemyStateMachine

func _ready() -> void:
	state_machine = get_parent()

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass
