extends EnemyState

@export var shooting_cooldown: int
@export var available_spells: Array[int]

var state_machine: Node
var target_position: Vector2
var knockback_force: float = 0
var knockback_direction: Vector2 = Vector2.ZERO
var is_animation_finished: bool = true
var attack_animations: AnimationPlayer
var enemy_speed: int

@onready var attack_range: Area2D = $"../../AttackRange"
@onready var cooldown: Timer = $Cooldown
@onready var hitbox_component: HurtboxComponent = $"../../HitboxComponent"

func _ready() -> void:
	state_machine = get_parent()
	hitbox_component.hit.connect(set_knockback)
	attack_range.body_exited.connect(_leave_attack_state)
	enemy_speed = state_machine.enemy.speed
	set_process(false)

func enter() -> void:
	set_process(true)
	state_machine.enemy.speed = 0
	state_machine.body.play_idle_animation()
	shoot()
	cooldown.start(3)
	if attack_animations == null:
		attack_animations = state_machine.attack_animations
		attack_animations.animation_finished.connect(test)
		print(attack_animations)

func test(_animation_name: String) -> void:
	is_animation_finished = true
	if attack_range.get_overlapping_bodies().is_empty():
		state_machine.change_state(self, "chase")
	else: 
		shoot()

func exit() -> void:
	set_process(false)

func shoot() -> void:
	is_animation_finished = false
	var random_spell = randi() % available_spells.size()
	var spells = state_machine.attack_animations.get_animation_list()
	match random_spell:
		0:
			state_machine.attack_animations.play(spells[available_spells[random_spell]])
		1: 
			state_machine.attack_animations.play(spells[available_spells[random_spell]])

func _leave_attack_state(body: Node2D) -> void:
	if body.is_in_group("player") and is_animation_finished:
		set_knockback(0, 0)
		state_machine.change_state(self, "chase")

func set_knockback(force, dir) -> void:
	knockback_force = force
	knockback_direction = dir

func _process(_delta):
	if state_machine.target:
		target_position = state_machine.target.global_position
		
		#enemy speed & direction
		if knockback_direction:
			state_machine.enemy.speed = enemy_speed
			state_machine.enemy.velocity = knockback_direction * state_machine.enemy.speed * knockback_force
		else: 
			state_machine.enemy.velocity = state_machine.enemy.position.direction_to(target_position) * state_machine.enemy.speed
		
		knockback_direction = knockback_direction.lerp(Vector2.ZERO, 0.3)
		if knockback_direction.length() < 0.1:
			knockback_direction = Vector2.ZERO
			state_machine.enemy.speed = 0

		if state_machine.enemy.position.x <= state_machine.target.position.x:
			state_machine.body.scale.x = 1
		else:
			state_machine.body.scale.x = -1
		
	state_machine.enemy.move_and_slide()
