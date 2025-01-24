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

@onready var attack_range: Area2D = $"../../AttackRange"

func _ready() -> void:
	hitbox_component.hit.connect(set_knockback)
	state_machine = get_parent()
	enemy_speed = state_machine.enemy.speed
	if state_machine.body.left_weapon_scene:
		left_hand_weapon_sprite = state_machine.body.left_weapon_scene
	if state_machine.body.right_weapon_scene:
		right_hand_weapon_sprite = state_machine.body.right_weapon_scene
	attack_range.body_entered.connect(_enter_attack_state)
	
	state_machine.body.play_run_right_animation()

func enter():
	set_process(true)
	state_machine.enemy.speed = enemy_speed

func exit():
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
		
		if knockback_direction:
			state_machine.enemy.velocity = knockback_direction * state_machine.enemy.speed * knockback_force
		else: 
			state_machine.enemy.velocity = state_machine.enemy.position.direction_to(target_position) * state_machine.enemy.speed
		
		knockback_direction = knockback_direction.lerp(Vector2.ZERO, 0.3)
		if knockback_direction.length() < 0.1:
			knockback_direction = Vector2.ZERO
			
		#sprite flips
		if state_machine.enemy.position.x <= state_machine.target.position.x:
			state_machine.body.scale.x = 1
		else:
			state_machine.body.scale.x = -1
	state_machine.enemy.move_and_slide()

func weapon_facing_direction(left: bool, right: bool) -> void:
	if left_hand_weapon_sprite:
		left_hand_weapon_sprite.flip_h = left
	if right_hand_weapon_sprite:
		right_hand_weapon_sprite.flip_h = right

func _enter_attack_state(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.change_state(self, "attack")
