extends Area2D

@export var projectile_data: PROJECTILE

var direction: Vector2
var timer: Timer

@onready var spawn_animation_player: AnimationPlayer = $SpawnerDespawner

func _ready() -> void:
	if !spawn_animation_player:
		#print("Please attach a spawn animation to your projectile")
		pass
	else:
		spawn_animation_player.play("spawn")
	timer = Timer.new()
	area_entered.connect(_area_entered)
	add_child(timer)
	timer.start(projectile_data.LIFETIME)
	timer.timeout.connect(despawn)

func _process(delta: float) -> void:
	position += direction * projectile_data.SPEED * delta 

func set_direction(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	direction = direction.rotated(deg_to_rad(randf_range(-(projectile_data.SPREAD / 2),(projectile_data.SPREAD / 2))))

	return direction

func set_direction_no_spread(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	return direction
	
func set_direction_BG(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	
	return direction

func set_multi_direction(target_position: Vector2, amount: int) -> Array[Vector2]:
	var directions: Array[Vector2] = []
	var spread_per_shot: float = projectile_data.SPREAD / amount
	var middle: Vector2 = (target_position - global_position).normalized()
	var multiplyer: int  = 1
	
	if amount % 2 == 0:
		while amount > 0:
			var x: Vector2 = middle.rotated(deg_to_rad(-(spread_per_shot * multiplyer)))
			var y: Vector2 = middle.rotated(deg_to_rad(spread_per_shot * multiplyer))
			#var x: Vector2 = middle - Vector2.RIGHT.from_angle(spread_per_shot) * multiplyer
			#var y: Vector2 = middle + Vector2.RIGHT.from_angle(spread_per_shot) * multiplyer
			directions.append(x)
			directions.append(y)
			amount -= 2
			multiplyer += 1
	else:
		amount -= 1
		directions.append(middle)
		while amount > 0:
			var x: Vector2 = middle.rotated(deg_to_rad(-(spread_per_shot * multiplyer)))
			var y: Vector2 = middle.rotated(deg_to_rad(spread_per_shot * multiplyer))
			#var x: Vector2 = middle - Vector2.RIGHT.from_angle(spread_per_shot) * multiplyer
			#var y: Vector2 = middle + Vector2.RIGHT.from_angle(spread_per_shot) * multiplyer
			directions.append(x)
			directions.append(y)
			amount -= 2
			multiplyer += 1
	print(directions)
	return directions

#func _on_area_entered(area: Area2D) -> void:
	#print(area.name)
	#if "HitboxComponent" in area.name:
		#area.take_damage(projectile_data, direction)
		#queue_free()

func _area_entered(area: Area2D) -> void:
	if "HitboxComponent" in area.name:
		area.take_damage(projectile_data, direction)
		queue_free()

func despawn() -> void:
	if !spawn_animation_player:
		#print("Please attach a spawn animation to your projectile")
		pass
	else:
		spawn_animation_player.play("despawn")
