extends Node2D

const DROPLET = preload("res://Entities/Weapons/Projectiles/Water/droplet/droplet.tscn")
const WATERBALL = preload("res://Entities/Weapons/Projectiles/Water/Waterball/waterball.tscn")

var ball
var waterball_bobbing: bool = false
var waterball_charging: bool = false
var waterball_follow_speed: float = 10

@onready var marker_2d: Marker2D = $Marker2D
@onready var projectile_holder = get_tree().get_first_node_in_group("projectiles")
@onready var primary_firerate_timer: Timer = $Primary_Firerate
@onready var secondary_firerate_timer: Timer = $Secondary_Firerate

#Wooden staff Attacks
@export var stats: WeaponData
@export_group("Primary")
@export var primary_attack: PROJECTILE
@export var firerate_primary: float
@export_group("Secondary")
@export var secondary_attack: PROJECTILE
@export var firerate_secondary: float
@export_group("Special")
@export var special_attack: PROJECTILE

var primary_firing: bool = false
var secondary_firing: bool = false

func _ready() -> void:
	print("Staff equipped: ", stats.weapon_type)

func _process(delta: float) -> void:
	# Primary attack handling
	if Input.is_action_just_pressed("primary_attack"):
		if primary_firerate_timer.is_stopped():
			shoot_droplet()
			primary_firerate_timer.start(firerate_primary)
		primary_firing = true
	elif Input.is_action_just_released("primary_attack"):
		primary_firing = false

	# Secondary attack handling
	if Input.is_action_pressed("secondary_attack") and not waterball_charging:
		ball = shoot_waterball()
		ball.is_charging = true
		waterball_charging = true
	elif Input.is_action_just_released("secondary_attack"):
		var mouse_position = get_global_mouse_position()
		ball.is_charging = false
		ball.set_direction(mouse_position)
		waterball_charging = false
		
	if waterball_charging and ball.is_charging:
		ball.position = lerp(ball.position, Vector2(marker_2d.global_position.x, marker_2d.global_position.y - 17), waterball_follow_speed * delta)

func shoot_waterball():
	var waterball = WATERBALL.instantiate()
	projectile_holder.add_child(waterball)
	waterball.position = Vector2(marker_2d.global_position.x, marker_2d.global_position.y - 17)

	return waterball
func shoot_droplet() -> void:
	var temp_droplet = DROPLET.instantiate()
	temp_droplet.position = marker_2d.global_position
	projectile_holder.add_child(temp_droplet)
	
	#set the direction towards the mouse position
	var mouse_position = get_global_mouse_position()
	temp_droplet.set_direction(mouse_position)


func _on_secondary_firerate_timeout() -> void:
	print("Secondary")

func _on_primary_firerate_timeout() -> void:
	if primary_firing:
		shoot_droplet()
		primary_firerate_timer.start(firerate_primary)
	else: 
		primary_firerate_timer.stop()
