extends Node2D
class_name Bow

@export var arrow: Arrow
@export var bow_frames: SpriteFrames

var current_arrow: Area2D
var projectile_holder
var cooldown: bool = false
@onready var bow_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	var timer = Timer.new()
	projectile_holder = get_tree().get_first_node_in_group("projectiles")
	bow_frames.set_animation_loop("default", false)
	
	bow_sprite.frame_changed.connect(on_frame_changed)
	bow_sprite.animation_finished.connect(on_animation_finished)
	
	bow_sprite.sprite_frames = bow_frames

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack") and !cooldown:
		cooldown = true
		var temp_arrow: Area2D = arrow.scene.instantiate()
		current_arrow = temp_arrow
		add_child(temp_arrow)
		bow_sprite.play()

func on_animation_finished() -> void:
	bow_sprite.frame = 0
	current_arrow.set_direction(get_global_mouse_position())
	current_arrow.set_process(true)
	current_arrow.reparent(projectile_holder)
	var dir = current_arrow.set_direction(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)
	
	current_arrow.rotation = angle
	cooldown = false

func on_frame_changed() -> void:
	if bow_sprite.frame == 0:
		current_arrow.position.x = 5
	if bow_sprite.frame == 1:
		current_arrow.position.x = 3
	if bow_sprite.frame == 2:
		current_arrow.position.x = 0
