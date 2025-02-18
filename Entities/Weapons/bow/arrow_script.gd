extends Area2D

@export var sprite: Texture

var bow: Bow
var arrow: Arrow
var speed: int
var direction: Vector2
var timer = Timer.new()

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	set_collision_mask_value(6, true)
	
	bow = get_parent()
	speed = bow.arrow.speed
	arrow = bow.arrow
	area_entered.connect(on_hit)
	
	add_child(timer)
	timer.one_shot = true
	timer.start(3)
	timer.timeout.connect(despawn_arrow)
	
	call_deferred("set_monitorable", (false))
	call_deferred("set_monitoring", (false))
	
	if sprite == null:
		print("Set arrow texture!")
	else:
		sprite_2d.texture = sprite

func on_hit(area: Area2D) -> void:
	if "HitboxComponent" in area.name:
		area.take_arrow_damage(arrow, direction)
		await get_tree().create_timer(.1).timeout
		queue_free()

func despawn_arrow() -> void:
	queue_free()

func _process(delta: float) -> void:
	position += direction * speed * delta 

func set_direction(target_position: Vector2) -> Vector2:
	direction = (target_position - global_position).normalized()
	call_deferred("set_monitorable", (true))
	call_deferred("set_monitoring", (true))
	return direction
