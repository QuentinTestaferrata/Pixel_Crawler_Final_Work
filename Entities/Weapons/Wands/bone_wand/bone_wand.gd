extends Node2D

const FIREBALL = preload("res://Entities/Weapons/Wands/bone_wand/attacks/primary/fireball.tscn")
const MINI_FIREBALL = preload("res://Entities/Weapons/Wands/bone_wand/attacks/secondary/mini_fireball.tscn")

@export var primary_attack: PROJECTILE
@export var secondary_attack: PROJECTILE

var fireballs = []

@onready var markers: Node2D = $Markers
@onready var projectile_holder = get_tree().get_first_node_in_group("projectiles")
@onready var fireball_holder: Node = $FireballHolder
@onready var marker: Marker2D = $Marker

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack"):
		shoot_primary()
	if event.is_action_pressed("secondary_attack"):
		shoot_secondary()

func shoot_primary() -> void:
	for n in 3:
		var temp_fireball = FIREBALL.instantiate()
		var dir: Vector2
		
		temp_fireball.global_position = Vector2(marker.global_position.x , marker.global_position.y - 5)
		
		dir = temp_fireball.set_direction(get_global_mouse_position())
		var angle = Vector2.RIGHT.angle_to(dir)
		
		temp_fireball.rotation = angle
		projectile_holder.add_child(temp_fireball)
		
		await get_tree().create_timer(.3).timeout 

func shoot_secondary() -> void:
	for _marker in markers.get_children():
		var temp_mini_fireball = MINI_FIREBALL.instantiate()
		
		temp_mini_fireball.global_position = Vector2(_marker.position.x, _marker.position.y + 20)
		_marker.add_child(temp_mini_fireball)
		
		await get_tree().create_timer(.2).timeout
