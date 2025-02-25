extends EnemyState

@onready var state_machine: EnemyStateMachine
@onready var hitbox_component: HurtboxComponent = $"../../HitboxComponent"

var enemy_speed: int
var target_position: Vector2
var knockback_force: float = 0
var knockback_direction: Vector2 = Vector2.ZERO
var is_facing_right: bool = true
var left_hand_weapon_sprite: Sprite2D
var right_hand_weapon_sprite: Sprite2D
var enemy: CharacterBody2D

#navigation
var nav_agent: NavigationAgent2D
var direction: Vector2
var next_path_position: Vector2

@onready var attack_range: Area2D = $"../../AttackRange"

func _ready() -> void:
	hitbox_component.hit.connect(set_knockback)
	state_machine = get_parent()
	enemy_speed = state_machine.enemy.speed
	enemy = state_machine.enemy
	if state_machine.body.left_weapon_scene:
		left_hand_weapon_sprite = state_machine.body.left_weapon_scene
	if state_machine.body.right_weapon_scene:
		right_hand_weapon_sprite = state_machine.body.right_weapon_scene
	attack_range.body_entered.connect(_enter_attack_state)
	
	state_machine.body.play_run_right_animation()
	
	# Navigation code
	nav_agent = state_machine.pathfind

func _on_nav_finished() -> void:
	nav_agent.target_position = state_machine.target.global_position

func _on_nav_velocity_computed(safe_velocity) -> void:
	enemy.velocity = enemy.velocity.move_toward(safe_velocity, 100)


func enter():
	set_knockback(0, Vector2(0,0))
	set_process(true)
	state_machine.enemy.speed = enemy_speed
	state_machine.body.play_run_right_animation()

func exit():
	set_knockback(0, Vector2(0,0))
	set_process(false)

func update(_delta: float):
	pass

func set_knockback(force, dir) -> void:
	knockback_force = force
	knockback_direction = dir

func _process(_delta):
	if state_machine.target:
		state_machine.hand_sprites.rotation = lerp_angle(state_machine.hand_sprites.rotation, 0, 10.0 * _delta)
		
		target_position = state_machine.target.global_position
		nav_agent.target_position = target_position
		direction = (nav_agent.get_next_path_position() - enemy.global_position).normalized()
		
		if knockback_direction:
			state_machine.enemy.velocity = knockback_direction * state_machine.enemy.speed * knockback_force
		else: 
			#direction = enemy.global_position.direction_to(next_path_position)
			#state_machine.enemy.velocity =  new_velocity#state_machine.enemy.position.direction_to(target_position) * state_machine.enemy.speed
			enemy.velocity = enemy.velocity.lerp(direction * enemy.speed, .1)
			
		knockback_direction = knockback_direction.lerp(Vector2.ZERO, 0.3)
		if knockback_direction.length() < 0.1:
			knockback_direction = Vector2.ZERO
			
		#sprite flips
		if state_machine.enemy.position.x <= state_machine.target.position.x:
			state_machine.body.scale.x = 1
		else:
			state_machine.body.scale.x = -1
		#if state_machine.enemy.velocity.x >= 0 and !knockback_direction:
			#state_machine.body.scale.x = 1
		#else:
			#state_machine.body.scale.x = -1
	state_machine.enemy.move_and_slide()

func weapon_facing_direction(left: bool, right: bool) -> void:
	if left_hand_weapon_sprite:
		left_hand_weapon_sprite.flip_h = left
	if right_hand_weapon_sprite:
		right_hand_weapon_sprite.flip_h = right

func _enter_attack_state(body: Node2D) -> void:
	if body.is_in_group("player") and state_machine.enemy_type == "melee":
		#print("Entered melee")
		set_knockback(0, Vector2(0,0))
		state_machine.change_state(self, "attack")
	elif body.is_in_group("player") and state_machine.enemy_type == "ranged":
		#print("entered ranged")
		set_knockback(0, Vector2(0,0))
		state_machine.change_state(self, "shootprojectile")
