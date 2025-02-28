extends Node2D

@export var projectile_instantiater: Node2D

@export_category("Primary Attack")
@export var attack_resource_1: PROJECTILE
@export var primary_attack_scene: PackedScene
@export var primary_projectile_amount: int
@export var spread_array: Array[int]

@export_category("Secondary Attack")
@export var attack_resource_2: PROJECTILE
@export var secondary_attack_scene: PackedScene
@export var projectile_amount: int

@onready var marker_2d: Marker2D = $Marker2D
@onready var marker_2d_2: Marker2D = $Marker2D2


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack") and AttackCooldowns.check_cd(1):
		projectile_instantiater.instantiate_multiple_projectiles(primary_attack_scene, spread_array, marker_2d)
		AttackCooldowns.start_cd(1)
	if event.is_action_pressed("secondary_attack") and AttackCooldowns.check_cd(2):
		projectile_instantiater.instantiate_projectile(2, 1)
		AttackCooldowns.start_cd(2)
