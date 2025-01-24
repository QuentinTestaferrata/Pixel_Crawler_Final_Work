extends PlayerState

@export var sprite: AnimatedSprite2D
@export var player: CharacterBody2D

var knockback_force: float = 0
var knockback_direction: Vector2 = Vector2.ZERO

@onready var state_machine: PlayerStateMachine = $".."
@onready var player_hurtbox: Area2D = $"../../PlayerHurtbox"

func _ready() -> void: 
	player_hurtbox.hit.connect(set_knockback)

func enter():
	sprite.play("run")

func update(_delta: float):
	if !Input.get_vector("left", "right", "up", "down"):
		state_machine.change_state(self, "idle")
		pass
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state(self, "dash")

func exit():
	pass

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if knockback_direction:
		player.velocity = knockback_direction * player.speed * knockback_force
	else: 
		player.velocity = direction * player.speed
	
	knockback_direction = knockback_direction.lerp(Vector2.ZERO, 0.3)
	if knockback_direction.length() < 0.1:
		knockback_direction = Vector2.ZERO
	
	player.move_and_slide()

func set_knockback(force: float, dir: Vector2) -> void:
	knockback_force = force
	knockback_direction = dir
func _process(_delta):
	pass
