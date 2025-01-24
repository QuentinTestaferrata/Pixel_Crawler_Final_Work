extends Node

var spawn_points_array: Array[Vector2] = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	##var total_spawn_points = get_child_count()
	##print(spawn_points_array.size())
	##print("spawn points: ", spawn_points_array)
	pass

func add_spawn_point(point: Vector2) -> void:
	if !spawn_points_array.has(point):
		spawn_points_array.append(point)

func remove_spawn_point(point: Vector2) -> void:
	if spawn_points_array.has(point):
		spawn_points_array.erase(point)

func get_random_valid_spawnpoint() -> Vector2:
	var i = rng.randi_range(0, spawn_points_array.size() - 1)
	var random_spawnpoint = spawn_points_array[i]
	return random_spawnpoint
