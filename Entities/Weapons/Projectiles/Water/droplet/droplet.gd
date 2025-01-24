extends Area2D

@export var projectile: PROJECTILE

@onready var despawner: Timer = $Despawner
@onready var knockback_component: Node2D = $KnockbackComponent
var spawnpoint: Vector2
var direction = Vector2.ZERO

func _ready():
	spawnpoint = global_position
	despawner.start(projectile.LIFETIME)
	set_as_top_level(true)

func _physics_process(delta: float) -> void:
	position += direction * projectile.SPEED * delta 

func _on_despawner_timeout() -> void:
	queue_free()


func set_direction(target_position: Vector2) -> void:
	direction = (target_position - position).normalized()

#Projectile
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent: #enemy
		var enemy = area.get_parent()
		direction = spawnpoint.direction_to(area.global_position)
		var knockback_force = direction * projectile.KNOCKBACK_FORCE
		enemy.set_axis(direction)
		enemy.knockback = knockback_force
		area.take_damage(projectile)
		queue_free()
	else:
		print("No hurtbox: ", area.name)

func _on_body_entered(body: Node2D) -> void:
	if "Walls" or "Interior" in body.name:
		queue_free()
	elif "Player" in body.name:
		pass
