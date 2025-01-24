extends Node
class_name PlayerStateMachine

var states: Dictionary = {}
var current_state: PlayerState
@export var initial_state: PlayerState
@export var player: CharacterBody2D

func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)

	if initial_state:
		initial_state.enter()
		current_state = initial_state
	else:
		print("No player initial state setup")

func change_state(source_state: PlayerState, new_state_name: String):
	if source_state != current_state:
		print("cannot change_state from: ", source_state.name, " but curr in: ", current_state.name)
		return
	
	#checking in dictionary if the state exists
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("the new state doesn't exist in the dictionary")
		return
	
	if current_state:
		current_state.exit()
		##print("Leaving state: ", current_state.name)
	
	new_state.enter()
	current_state = new_state
	##print("New state: ", current_state.name)

func force_change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("the new state doesn't exist in the dictionary")
		return
	
	if current_state == new_state:
		print("Can't force state change to state change")
		return
	
	if current_state:
		var exit_callable = Callable(current_state, "exit")
		exit_callable.call_deferred()
	
	new_state.enter()
	current_state = new_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
