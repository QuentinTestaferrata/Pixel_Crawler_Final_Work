extends AnimatedSprite2D

const CURSED_PROJECTILE_SPAWNER = preload("res://Entities/Weapons/Staffs/cursed_staff/projectiles/secondary/cursed_projectile_spawner.tscn")

var projectile_holder: Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void :
	projectile_holder = get_tree().get_first_node_in_group("projectiles")

func _on_timer_timeout() -> void:
	var temp_attack = CURSED_PROJECTILE_SPAWNER.instantiate()
	temp_attack.global_position = global_position
	
	var dir = temp_attack.set_direction(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	temp_attack.rotation = angle
	
	projectile_holder.add_child(temp_attack)


func _on_despawn_timer_timeout() -> void:
	animation_player.play("despawn")
