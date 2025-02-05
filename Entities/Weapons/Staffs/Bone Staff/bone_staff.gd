extends Node2D

const BONE_SHARD = preload("res://Entities/Weapons/Staffs/Bone Staff/attacks/Primary/bone_shard.tscn")
const BONE_SHIELD = preload("res://Entities/Weapons/Staffs/Bone Staff/attacks/Secondary/bone_shield.tscn")

var primary: PackedScene
var secondary: PackedScene

@export var primary_attack: PROJECTILE
@export var secondary_attack: PROJECTILE
@export var bone_amount: int = 2

@onready var primary_attack_timer: Timer = $PrimaryAttackTimer
@onready var marker: Marker2D = $Marker2D
@onready var projectile_holder = get_tree().get_first_node_in_group("projectiles")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack"):
		shoot_primary()
		primary_attack_timer.start(primary_attack.FIRERATE)
	if event.is_action_released("primary_attack"):
		primary_attack_timer.stop()
	if event.is_action_pressed("secondary_attack"):
		shoot_secondary()

func shoot_primary() -> void:
	var bone_shard = BONE_SHARD.instantiate()
	var dir: Vector2
	bone_shard.global_position = Vector2(marker.global_position.x , marker.global_position.y - 5)
	
	dir = bone_shard.set_direction(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	
	bone_shard.rotation = angle
	projectile_holder.add_child(bone_shard)

func _on_primary_attack_timer_timeout() -> void:
	shoot_primary()

func shoot_secondary() -> void:
	var player = get_tree().get_first_node_in_group("player")
	var time_to_wait: float = 1.5 / bone_amount 
	for i in bone_amount:
		var temp_bone_shield = BONE_SHIELD.instantiate()
		player.add_child(temp_bone_shield)
		await get_tree().create_timer(time_to_wait).timeout 
