extends Label
@onready var state_machine: EnemyStateMachine = $"../StateMachine"

func _process(_delta: float) -> void:
	text = str(state_machine.current_state.name)
