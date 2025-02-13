extends Node2D

@export var rotation_speed: int
@export var projectile_data: PROJECTILE

var direction: Vector2
var player: CharacterBody2D

@onready var timer: Timer = $Offset/Timer
@onready var spawn_animation: AnimationPlayer = $Offset/SpawnAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if "HitboxComponent" in area.name:
		direction = player.global_position.direction_to(area.global_position)
		area.take_damage(projectile_data, direction)
		

func _on_timer_timeout() -> void:
	spawn_animation.play("despawn")
