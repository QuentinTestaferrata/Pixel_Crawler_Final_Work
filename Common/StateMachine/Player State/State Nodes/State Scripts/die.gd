extends PlayerState

@onready var character_sprite: AnimatedSprite2D = $"../../CharacterSprite"
@onready var state_machine: PlayerStateMachine = $".."
@onready var run: Node = $"../Run"
@onready var camera: Camera2D = $"../../Camera"

func enter() -> void:
	character_sprite.play("die")
	run.set_process(false)
	run.set_physics_process(false)
	camera.alive = false
	state_machine.player.player_died.emit()

func update(_delta: float) -> void: 
	pass

func exit () -> void:
	pass
