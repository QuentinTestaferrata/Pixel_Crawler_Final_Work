extends EnemyState

@export var available_attacks: Array[int]
@export var attack_cooldown: int
@export var rotate_hands: bool = false

var angle_to_target: float
var target_position: Vector2
var direction_to_target: Vector2
var knockback_force: float = 0
var knockback_direction: Vector2 = Vector2.ZERO
var sprites: Node2D
var attacks: Array = []
var attack_animations: AnimationPlayer
var is_animation_finished: bool = true
var cooldown_timer: Timer
var nav_agent: NavigationAgent2D
var direction: Vector2
var enemy: CharacterBody2D

@onready var attack_range: Area2D = $"../../AttackRange"
@onready var hitbox_component: HurtboxComponent = $"../../HitboxComponent"
@onready var state_machine: EnemyStateMachine

func _ready() -> void:
	attack_range.body_exited.connect(_leave_attack_state)
	hitbox_component.hit.connect(set_knockback)
	state_machine = get_parent()
	nav_agent = state_machine.pathfind
	enemy = state_machine.enemy
	
	cooldown_timer = Timer.new()
	cooldown_timer.timeout.connect(attack)
	add_child(cooldown_timer)
	
	set_process(false)

func enter():
	set_knockback(0, Vector2(0,0))
	set_process(true)
	state_machine.body.play_run_right_animation()
	if attack_animations == null:
		attack_animations = state_machine.attack_animations
	
	attack()

func attack() -> void:
	if attack_range.get_overlapping_bodies().is_empty():
			state_machine.change_state(self, "chase")
			cooldown_timer.stop()
	else: 
		pick_random_attack()
		
	cooldown_timer.start(attack_cooldown)

func pick_random_attack() -> void:
	var random_attack = randi() % available_attacks.size()
	attacks = state_machine.attack_animations.get_animation_list()
	
	match random_attack:
		0:
			state_machine.attack_animations.play(attacks[available_attacks[random_attack]])
		1: 
			state_machine.attack_animations.play(attacks[available_attacks[random_attack]])

func exit():
	cooldown_timer.stop()
	set_process(false)

func update(_delta: float):
	pass

func set_knockback(force, dir) -> void:
	knockback_force = force
	knockback_direction = dir

func _process(_delta):
	if state_machine.target:
		target_position = state_machine.target.global_position
		nav_agent.target_position = target_position
		direction = (nav_agent.get_next_path_position() - enemy.global_position).normalized()
		
		#enemy speed & direction
		if knockback_direction:
			state_machine.enemy.velocity = knockback_direction * state_machine.enemy.speed * knockback_force
		else: 
			enemy.velocity = enemy.velocity.lerp(direction * enemy.speed, .1)
		
		knockback_direction = knockback_direction.lerp(Vector2.ZERO, 0.3)
		if knockback_direction.length() < 0.1:
			knockback_direction = Vector2.ZERO
		
		#weapons angle and body flips
		if rotate_hands and state_machine.enemy.position.x <= state_machine.target.position.x:
			direction_to_target = state_machine.enemy.position.direction_to(target_position)
			angle_to_target = direction_to_target.angle()
			state_machine.hand_sprites.rotation = lerp_angle(state_machine.hand_sprites.rotation, angle_to_target + PI / 2, 15.0 * _delta)
		elif rotate_hands and !(state_machine.enemy.position.x <= state_machine.target.position.x):
			direction_to_target = state_machine.enemy.position.direction_to(target_position)
			angle_to_target = direction_to_target.angle()
			state_machine.hand_sprites.rotation = lerp_angle(state_machine.hand_sprites.rotation, -(angle_to_target + PI / 2), 15.0 * _delta)
		
		#Spriteflip
		if state_machine.enemy.position.x <= state_machine.target.position.x:
			state_machine.body.scale.x = 1
		else:
			state_machine.body.scale.x = -1
		
	state_machine.enemy.move_and_slide()

func _leave_attack_state(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.change_state(self, "chase")
