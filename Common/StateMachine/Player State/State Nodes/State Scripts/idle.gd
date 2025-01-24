extends PlayerState

@export var sprite: AnimatedSprite2D
@export var player: CharacterBody2D
@onready var state_machine: PlayerStateMachine = $".."

func enter():
	sprite.play("idle")

func update(_delta: float):
	if Input.get_vector("left", "right", "up", "down"):
		state_machine.change_state(self, "run")

	if Input.is_action_just_pressed("interact"):
		print("interacting")
		pass
	
	if Input.is_action_just_pressed("primary_attack") or Input.is_action_just_pressed("secondary_attack"):
		#TODO Transit -> Attack state
		pass

func exit():
	pass
