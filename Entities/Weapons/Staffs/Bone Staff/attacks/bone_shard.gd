extends Area2D

@export var projectile_data: PROJECTILE

var direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var despawner: Timer = $Despawner
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	despawner.start(projectile_data.LIFETIME)

func _on_despawner_timeout() -> void:
	animation_player.play("despawn")

func _physics_process(delta: float) -> void:
	position += direction * projectile_data.SPEED * delta 

func set_direction(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	direction = direction.rotated(deg_to_rad(randf_range(-(projectile_data.SPREAD / 2),(projectile_data.SPREAD / 2))))
	
	return direction

func _on_area_entered(area: Area2D) -> void:
	if "HitboxComponent" in area.name:
		area.take_damage(projectile_data, direction)
		queue_free()
