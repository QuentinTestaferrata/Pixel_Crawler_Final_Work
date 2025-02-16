extends EnemyState

@export var entity: CharacterBody2D

var angle_to_target: float
var target_position: Vector2
var direction_to_target: Vector2
var knockback_force: float = 0
var knockback_direction: Vector2 = Vector2.ZERO
var sprites: Node2D
var attacks: Array = []

@onready var attack_range: Area2D = $"../../AttackRange"
@onready var hitbox_component: HurtboxComponent = $"../../HitboxComponent"
@onready var state_machine: EnemyStateMachine

func _ready() -> void:
	attack_range.body_exited.connect(_leave_attack_state)
	hitbox_component.hit.connect(set_knockback)
	state_machine = get_parent()
	
	set_process(false)

func enter():
	set_process(true)
	state_machine.body.play_run_right_animation()
	state_machine.body.set_weapons_monitorable(true)
	attacks = state_machine.attack_animations.get_animation_list()
	randi_range(1, state_machine.attack_animations.get_animation_list().size() - 1)
	state_machine.attack_animations.play(attacks.pick_random())

func exit():
	set_process(false)
	state_machine.body.set_weapons_monitorable(false)

func update(_delta: float):
	pass

func set_knockback(force, dir) -> void:
	knockback_force = force
	knockback_direction = dir

func _process(_delta):
	if state_machine.target:
		target_position = state_machine.target.global_position
		
		#enemy speed & direction
		if knockback_direction:
			state_machine.enemy.velocity = knockback_direction * state_machine.enemy.speed * knockback_force
		else: 
			state_machine.enemy.velocity = state_machine.enemy.position.direction_to(target_position) * state_machine.enemy.speed
		
		knockback_direction = knockback_direction.lerp(Vector2.ZERO, 0.3)
		if knockback_direction.length() < 0.1:
			knockback_direction = Vector2.ZERO
		#weapons angle
		#direction_to_target = state_machine.enemy.position.direction_to(target_position)
		#angle_to_target = direction_to_target.angle()
		#state_machine.hand_sprites.rotation = lerp_angle(state_machine.hand_sprites.rotation, angle_to_target + PI / 2, 15.0 * _delta)
		#
		if state_machine.enemy.position.x <= state_machine.target.position.x:
			state_machine.body.scale.x = 1
		else:
			state_machine.body.scale.x = -1
		
	state_machine.enemy.move_and_slide()

func _leave_attack_state(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.change_state(self, "chase")
