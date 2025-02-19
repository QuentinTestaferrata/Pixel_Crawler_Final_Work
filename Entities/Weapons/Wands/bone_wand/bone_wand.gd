extends Node2D

const FIREBALL = preload("res://Entities/Weapons/Wands/bone_wand/attacks/primary/fireball.tscn")
const MINI_FIREBALL = preload("res://Entities/Weapons/Wands/bone_wand/attacks/secondary/mini_fireball.tscn")

@export_category("Primary Attack")
@export var primary_attack: PROJECTILE
@export_category("Secondary Attack")
@export var secondary_attack: PROJECTILE
@export var fireballs_amount: int
@export var firerate: float

var fireballs = []
var dir: Vector2

@onready var markers: Node2D = $Markers
@onready var projectile_holder = get_tree().get_first_node_in_group("projectiles")
@onready var marker: Marker2D = $Marker
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var fireball_cooldown: Timer = $Timers/FireballCooldown
@onready var fireball_timer: Timer = $Timers/FireballTimer
@onready var fireball_spawner: Marker2D = $Markers/FireballSpawner
@onready var primary_attack_cooldown: Timer = $Timers/PrimaryAttackCooldown
@onready var fire_particles: CPUParticles2D = $Markers/FireParticles


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack") and AttackCooldowns.check_cd(1):#primary_attack_cooldown.is_stopped():
		#primary_attack_cooldown.start(primary_attack.COOLDOWN)
		AttackCooldowns.start_cd(1)
		shoot_primary()
	if event.is_action_pressed("secondary_attack") and AttackCooldowns.check_cd(2): #fireball_cooldown.is_stopped():
		fireball_cooldown.start(secondary_attack.COOLDOWN)
		AttackCooldowns.start_cd(2)
		animation_player_2.play("show")
		await get_tree().create_timer(.5).timeout
		shoot_secondary()

func shoot_primary() -> void:
	for n in 3:
		var temp_fireball = FIREBALL.instantiate()
		
		temp_fireball.global_position = Vector2(marker.global_position.x , marker.global_position.y - 5)
		
		dir = temp_fireball.set_direction(get_global_mouse_position())
		var angle = Vector2.RIGHT.angle_to(dir)
		
		temp_fireball.rotation = angle
		projectile_holder.add_child(temp_fireball)
		
		await get_tree().create_timer(.3).timeout 

func shoot_secondary() -> void:
	fire_particles.emitting = true
	for x in fireballs_amount:
		spawn_mini_fireball()
		await get_tree().create_timer(firerate).timeout
	animation_player_2.play("hide")
	fire_particles.emitting = false

func spawn_mini_fireball() -> void:
	var temp_fireball = MINI_FIREBALL.instantiate()
	
	temp_fireball.position = fireball_spawner.global_position
	
	dir = temp_fireball.set_direction(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	
	temp_fireball.rotation = angle
	projectile_holder.add_child(temp_fireball)
	
	await get_tree().create_timer(.3).timeout
