extends Node2D

const THORN = preload("res://Entities/Weapons/Staffs/Basic Staff/attacks/primary/thorn.tscn")

var dir: Vector2
var projectile_holder: Node2D
var projectile_directions: Array[Vector2] = [
	Vector2(1, 0),
	Vector2(-1, 0),
	Vector2(0, 1), 
	Vector2(0, -1), 
	Vector2(1, 1), 
	Vector2(-1, 1),
	Vector2(1, -1),
	Vector2(-1, -1)
]

@onready var timer: Timer = $"../Timer"

func _ready() -> void:
	projectile_holder = get_tree().get_first_node_in_group("projectiles")

func _on_timer_timeout() -> void:
	for i in projectile_directions:
		var attack = _instantiate_projectile(THORN, position, i)
		attack.reparent(projectile_holder)
	

func _instantiate_projectile(attack: PackedScene, pos: Vector2, direction: Vector2):
	var temp_attack = attack.instantiate()
	temp_attack.position = pos
	
	dir = temp_attack.set_direction(direction)
	var angle = Vector2.RIGHT.angle_to(dir)
	temp_attack.rotation = angle
	
	add_child(temp_attack)
	return temp_attack #For cool blizzard or tornado effect do not return attack
	#and do not reparent the attack to projectile holder on line 26
