extends Sprite2D

const RED_FIREBALL = preload("res://Entities/Enemy/dungeon_skeletons/mage/Weapon/projectiles/red_fireball.tscn")
@export var projectiles: Array[EnemyProjectile]

var state_machine: Node
var ShootState: Node
var enemy_position: Vector2
var projectile_holder: Node2D

@onready var marker_2d: Marker2D = $Marker2D

func _ready() -> void:
	state_machine = get_parent()
	projectile_holder = get_tree().get_first_node_in_group("projectiles")
	
	while state_machine is not CharacterBody2D:
		state_machine = state_machine.get_parent()
		
	state_machine = state_machine.get_node("StateMachine")
	ShootState = state_machine.get_node("ShootProjectile")
	ShootState.shoot_signal.connect(shoot_projectile)
	
	await get_tree().create_timer(.5).timeout
	enemy_position = state_machine.target.global_position

func shoot_projectile() -> void:
	var temp_projectile = RED_FIREBALL.instantiate() #projectiles.pick_random().scene.instantiate()
	temp_projectile.global_position = marker_2d.global_position
	var dir = temp_projectile.set_direction(get_enemy_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	
	temp_projectile.rotation = angle
	projectile_holder.add_child(temp_projectile)

func get_enemy_position() -> Vector2:
	enemy_position = state_machine.target.global_position
	return enemy_position

	
func _process(delta: float) -> void:
	pass
