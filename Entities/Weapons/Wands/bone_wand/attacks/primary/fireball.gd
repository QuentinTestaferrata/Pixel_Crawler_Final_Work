extends Area2D

@export var projectile_data: PROJECTILE

var direction: Vector2

func _process(delta: float) -> void:
	position += direction * projectile_data.SPEED * delta 

func set_direction(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	return direction

func _on_area_entered(area: Area2D) -> void:
	if "HitboxComponent" in area.name:
		area.take_damage(projectile_data, direction)
		queue_free()
