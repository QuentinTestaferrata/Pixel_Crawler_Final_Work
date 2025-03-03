extends Node2D

@export_category("Primary Attack")
@export var primary_attack_scene: PackedScene
@export var primary_attack_data: PROJECTILE

@export_category("Secondary Attack")
@export var secondary_attack_scene: PackedScene
@export var secondary_attack_data: PROJECTILE

@export_category("Spawn")
@export var primary_spawn_position: Marker2D
@export var secondary_spawn_position: Marker2D

var temp_attack: Area2D
var dir: Vector2
var projectile_holder: Node2D

func _ready() -> void:
	projectile_holder = get_tree().get_first_node_in_group("projectiles")

func instantiate_projectile(attack: int, projectile_amount: int) -> void:
	match attack:
		1:
			for i in projectile_amount:
				_instantiate_projectile(primary_attack_scene, primary_spawn_position)
				await get_tree().create_timer(primary_attack_data.FIRERATE).timeout
		2:
			for i in projectile_amount:
				_instantiate_projectile(secondary_attack_scene, secondary_spawn_position)
				await get_tree().create_timer(secondary_attack_data.FIRERATE).timeout
		_:
			print("Attack has to be 1 or 2 - (ProjectileInstatianter)")

func _instantiate_projectile(attack: PackedScene, pos: Marker2D) -> void:
	temp_attack = attack.instantiate()
	temp_attack.global_position = pos.global_position
	
	dir = temp_attack.set_direction(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	temp_attack.rotation = angle
	
	projectile_holder.add_child(temp_attack)

func instantiate_projectiles_different_locations(attack: PackedScene, locations: Array[Vector2]) -> void:
	var staff = get_parent()
	var positions = staff.current_spawners
	
	for i in positions:
		temp_attack = attack.instantiate()
		temp_attack.global_position = i.global_position

		dir = temp_attack.set_direction(get_global_mouse_position())
		var angle = Vector2.RIGHT.angle_to(dir)
		temp_attack.rotation = angle
	
		projectile_holder.add_child(temp_attack)
		
		await get_tree().create_timer(.5).timeout

func instantiate_multiple_projectiles(attack: PackedScene, spread_array: Array[int], pos: Marker2D) -> void:
	for spread in spread_array:
		var _temp_attack = attack.instantiate()
		_temp_attack.global_position = pos.global_position
		
		var _dir = _temp_attack.set_direction_with_spread(get_global_mouse_position(), spread)
		#var angle = Vector2.RIGHT.angle_to(_dir)
		#_temp_attack.rotation = angle
		
		projectile_holder.add_child(_temp_attack)
	
