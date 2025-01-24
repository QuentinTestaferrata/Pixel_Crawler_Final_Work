extends Marker2D

@export var zone: Area2D

var active: bool

@onready var spawn_points: Node = %SpawnPoints

func _ready() -> void:
	spawn_points.add_spawn_point(global_position)
	var area: Area2D = get_child(0)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		spawn_points.remove_spawn_point(global_position)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		spawn_points.add_spawn_point(global_position)
