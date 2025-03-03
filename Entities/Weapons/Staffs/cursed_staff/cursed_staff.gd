extends Node2D

const CURSE_SPAWNER = preload("res://Entities/Weapons/Staffs/cursed_staff/projectiles/secondary/curse_spawner.tscn")

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

var player: CharacterBody2D
var spawner_node2D: Node2D
var spawner_locations: Array[Vector2] = [Vector2(11, -25), Vector2(-11, -25), Vector2(-27, -12),Vector2(27, -12)]
var current_spawners: Array = []

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack") and AttackCooldowns.check_cd(1):
		projectile_instantiater.instantiate_multiple_projectiles(primary_attack_scene, spread_array, marker_2d)
		AttackCooldowns.start_cd(1)
	if event.is_action_pressed("secondary_attack") and AttackCooldowns.check_cd(2):
		activate_spawners()
		#projectile_instantiater.instantiate_projectiles_different_locations(secondary_attack_scene, spawner_locations)
		AttackCooldowns.start_cd(2)

func activate_spawners() -> void:
	spawner_node2D = Node2D.new()
	spawner_node2D.position = Vector2(0, -30)
	
	player.add_child(spawner_node2D)
	for i in spawner_locations:
		var temp_curse_spawner = CURSE_SPAWNER.instantiate()
		temp_curse_spawner.position = i
	
		current_spawners.append(temp_curse_spawner)
		spawner_node2D.add_child(temp_curse_spawner)
		
		await get_tree().create_timer(.3).timeout
	
	
