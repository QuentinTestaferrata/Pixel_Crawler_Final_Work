extends Area2D

@export var projectile: PROJECTILE
@export var time_to_charge: float
@export var max_target_hits: int = 3
var current_target_hits = 0

@onready var stage_1: Sprite2D = $Stage1
@onready var stage_2: Sprite2D = $Stage2
@onready var stage_3: Sprite2D = $Stage3
@onready var hitbox: CollisionShape2D = $hitbox
@onready var despawner: Timer = $Despawner
@onready var charge_attack: Timer = $ChargeAttack
@onready var particles: GPUParticles2D = $WaterParticles

var is_charging: bool = false
var direction: Vector2 = Vector2.ZERO
var current_stage = 1
var particles_material = ParticleProcessMaterial.new()
var spawnpoint

func _ready() -> void:
	projectile.DAMAGE = 20
	projectile.KNOCKBACK_FORCE = 2
	stage_1.visible = true
	stage_2.visible = false
	stage_3.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(stage_1, "scale", Vector2(0.8, 0.8), 0.1)
	tween.tween_property(stage_1, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(stage_1, "scale", Vector2(1, 1) , 0.1)
	charge_attack.start()
	hitbox.scale = Vector2(1, 1)
	z_index = 2
	particles.process_material = particles_material
	particles.amount = 4
	particles_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	particles_material.emission_sphere_radius = 3.5
	

func _process(_delta: float) -> void:
	spawnpoint = global_position
func _physics_process(delta: float) -> void:
	if not is_charging: 
		position += direction * projectile.SPEED * delta
	
	
		
func upgrade_stage_2() -> void:
	charge_attack.start()
	stage_1.visible = false
	stage_2.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(stage_2, "scale", Vector2(0.8, 0.8), 0.1)
	tween.tween_property(stage_2, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(stage_2, "scale", Vector2(1, 1) , 0.1)
	hitbox.scale = Vector2(1.5, 1.5)
	particles.amount = 7
	particles_material.emission_sphere_radius = 7
	projectile.KNOCKBACK_FORCE = 5
	projectile.DAMAGE = 45

func upgrade_stage_3() -> void:
	stage_2.visible = false
	stage_3.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(stage_3, "scale", Vector2(0.8, 0.8), 0.1)
	tween.tween_property(stage_3, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(stage_3, "scale", Vector2(1, 1) , 0.1)
	hitbox.scale = Vector2(2.2, 2.2)
	particles.amount = 10
	particles_material.emission_sphere_radius = 10
	projectile.KNOCKBACK_FORCE = 10
	projectile.DAMAGE = 80
#Scan for hits
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent and not is_charging and current_target_hits < max_target_hits: #enemy
		var enemy = area.get_parent()
		direction = spawnpoint.direction_to(area.global_position)
		var knockback_force = direction * projectile.KNOCKBACK_FORCE
		area.take_damage(projectile)
		enemy.set_axis(direction)
		enemy.knockback = knockback_force
		current_target_hits += 1
		if current_target_hits == max_target_hits:
			queue_free()
	else:
		print("No hurtbox: ", area.name)

func _on_body_entered(body: Node2D) -> void:
	if ("Walls" or "Interior" in body.name) and not is_charging:
		queue_free()
		pass

#Despawn projectile after x time
func start_despawn_timer() -> void:
	despawner.start(projectile.LIFETIME)
func _on_despawner_timeout() -> void:
	#queue_free()
	pass

#checks if player is pressing, after x time, upgrade projectile
func _on_charge_attack_timeout() -> void:
	match current_stage:
		1:
			upgrade_stage_2()
			current_stage = 2
		2: 
			upgrade_stage_3()
			current_stage = 3

func set_direction(target_position: Vector2) -> void:
	direction = (target_position - position).normalized()
