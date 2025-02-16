extends Area2D
class_name EnemyProjectile

@export var projectile_data: EnemyProjectileData

var projectile_owner: CharacterBody2D
var direction: Vector2
var timer: Timer

@onready var spawn_animation_player: AnimationPlayer = $SpawnerDespawner

func _ready() -> void:
	if !spawn_animation_player:
		#print("Please attach a spawn animation to your projectile")
		pass
	else:
		spawn_animation_player.play("spawn")
	#area_entered.connect(_on_area_entered)
	timer = Timer.new()
	add_child(timer)
	timer.start(projectile_data.LIFETIME)
	timer.timeout.connect(despawn)

func _process(delta: float) -> void:
	position += direction * projectile_data.SPEED * delta 

func set_direction(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	direction = direction.rotated(deg_to_rad(randf_range(-(projectile_data.SPREAD / 2),(projectile_data.SPREAD / 2))))

	return direction

#func set_direction_no_spread(target_position: Vector2) -> Vector2:
	#direction = (target_position - global_position).normalized()
#
	#return direction
	
#func set_direction_BG(target_position: Vector2) -> Vector2:
	#direction = (target_position - global_position).normalized()
#
	#return direction

#func _on_area_entered(area: Area2D) -> void:
	##print(area.name)
	#if "PlayerHurtbox" in area.name:
		#print("Player Hit")

func despawn() -> void:
	if !spawn_animation_player:
		#print("Please attach a spawn animation to your projectile")
		pass
	else:
		spawn_animation_player.play("despawn")
