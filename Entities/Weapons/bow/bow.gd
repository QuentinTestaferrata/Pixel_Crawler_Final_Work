extends Node2D
class_name Bow

const BONE_ARROW = preload("res://Entities/Weapons/bow/bone_bow/secondary/bone_arrow_projectile.tscn")

@export_enum("basic", "bone") var bow: String
@export var arrow: Arrow
@export var bow_frames: SpriteFrames
@export var multishot_arrows: int

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
	if event.is_action_pressed("primary_attack") and !cooldown and (bow == "basic" or bow == "bone"):
		cooldown = true
		var temp_arrow: Area2D = arrow.scene.instantiate()
		current_arrow = temp_arrow
		add_child(temp_arrow)
		bow_sprite.play()
	if event.is_action_pressed("secondary_attack") and bow == "bone" and AttackCooldowns.check_cd(2):
		spread_shot()
		AttackCooldowns.start_cd(2)

func spread_shot() -> void:
	var temp_arrow = BONE_ARROW.instantiate()
	add_child(temp_arrow)
	temp_arrow.reparent(projectile_holder)
	
	var dir = temp_arrow.set_direction_no_spread(get_global_mouse_position())
	var angle = Vector2.RIGHT.angle_to(dir)

	temp_arrow.rotation = angle
	for i in multishot_arrows - 1:
		var _temp_arrow = BONE_ARROW.instantiate()
		add_child(_temp_arrow)
		_temp_arrow.set_direction(get_global_mouse_position())
		_temp_arrow.reparent(projectile_holder)
		
		var _dir = _temp_arrow.set_direction(get_global_mouse_position())
		var _angle = Vector2.RIGHT.angle_to(_dir)

		_temp_arrow.rotation = _angle

#func spread_shot_bg() -> void:
	#var temp_arrow = BONE_ARROW.instantiate()
	#var dir:Array[Vector2] = temp_arrow.set_multi_direction(get_global_mouse_position(), 6)
	#
	#for i in dir:
		#var _temp_arrow = BONE_ARROW.instantiate()
		#add_child(_temp_arrow)
		#_temp_arrow.set_direction(i)
		#_temp_arrow.reparent(projectile_holder)
		#
		#var _dir = _temp_arrow.set_direction(i)
		#var _angle = Vector2.RIGHT.angle_to(_dir)
#
		#_temp_arrow.rotation = _angle

	
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
