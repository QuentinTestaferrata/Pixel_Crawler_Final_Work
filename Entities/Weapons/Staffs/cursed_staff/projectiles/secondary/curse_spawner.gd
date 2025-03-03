extends AnimatedSprite2D

const CURSED_PROJECTILE_SPAWNER = preload("res://Entities/Weapons/Staffs/cursed_staff/projectiles/secondary/cursed_projectile_spawner.tscn")

var projectile_holder: Node2D
var tween: Tween

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void :
	projectile_holder = get_tree().get_first_node_in_group("projectiles")
	set_tween()

func _on_timer_timeout() -> void:
	var temp_attack = CURSED_PROJECTILE_SPAWNER.instantiate()
	temp_attack.global_position = global_position
	
	var dir = temp_attack.set_direction(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	temp_attack.rotation = angle
	
	projectile_holder.add_child(temp_attack)

func _on_despawn_timer_timeout() -> void:
	tween.kill()
	animation_player.play("despawn")

func set_tween() -> void :
	tween = get_tree().create_tween()

	tween.tween_property(self, "position:y", position.y - 5, 0.7)
	tween.tween_property(self, "position:y", position.y - 4, 0.7)  
	tween.set_ease(Tween.EASE_IN)
	tween.set_loops()

func _exit_tree() -> void:
	tween.kill()
