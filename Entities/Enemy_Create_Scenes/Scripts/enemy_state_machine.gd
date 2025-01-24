extends Node
class_name EnemyStateMachine

var target: CharacterBody2D
var states: Dictionary = {}
var current_state: EnemyState
var hand_sprites: Node2D
var hand_animation_player: AnimationPlayer
var weaponsprite_left_hand: EnemyWeapon = null
var weaponsprite_right_hand: EnemyWeapon = null
var attack_animations: AnimationPlayer

@export var initial_state: EnemyState
@export var enemy: CharacterBody2D
@export var loot: Node2D
@export var body: EnemySprite
@export var attack_range: Area2D

func _ready() -> void:
	hand_sprites = body.get_child(3)
	
	attack_animations = body.set_attack_animation_player()
	print(attack_animations)
	
	target = get_tree().get_first_node_in_group("player")
	if not target:
		print("Enemy didn't find a target (Statemachine)")
	
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	else:
		print("No player initial state setup")

func change_state(source_state: EnemyState, new_state_name: String):
	if source_state != current_state:
		print("cannot change_state from: ", source_state.name, " but curr in: ", current_state.name)
		return
	
	#check in dictionary if the state exists
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("the new state", new_state.name, "doesn't exist in the dictionary")
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	############ print("New state: ", current_state)

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
