extends CharacterBody2D

var speed = 70  # speed in pixels/sec
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var camera: Camera2D = $Camera
@onready var timer: Timer = $Timer


func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
