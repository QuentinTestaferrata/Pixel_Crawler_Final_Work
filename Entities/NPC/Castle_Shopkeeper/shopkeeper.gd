extends CharacterBody2D

const SHOP_DIALOG = preload("res://UI/Shop/shop_dialog.tscn")

enum States {WALKING, IDLE, INTERACTING}

@export var speed: int = 50

var current_state: States = States.IDLE

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hud_layer: hud = $"../HUDLayer"


var position_x: int
var position_y: int
var previous_position: Vector2
var new_position: Vector2
var tolerance: float = 2.0  # The distance at which the NPC considers it has reached its target

func _ready():
	set_state(States.WALKING)
	random_position_generator(-83, 41, 397, 339)
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	var temp_shop = SHOP_DIALOG.instantiate()
	hud_layer.add_child(temp_shop)
	

func set_state(new_state: States) -> void:
	current_state = new_state
	match current_state:
		States.IDLE:
			sprite.play("idle")
			wait_and_walk_again()
		States.WALKING:
			sprite.play("walk")
		States.INTERACTING:
			sprite.play("idle")

func wander_through_shop():
	if current_state == States.WALKING:
		# movement
		var direction  = (new_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		# tolerance for target position
		var distance_to_target = global_position.distance_to(new_position)
		if distance_to_target <= tolerance:
			set_state(States.IDLE)

func random_position_generator(x_min: int, x_max: int, y_min: int, y_max: int):
	var position_found = false
	previous_position = global_position
	while not position_found:
		randomize()
		position_x = randi_range(x_min, x_max)
		position_y = randi_range(y_min, y_max)
		new_position = Vector2(position_x, position_y)
		#print("finding new position: ", new_position)

		# Check if the new position collides with any obstacles
		ray_cast.enabled = true
		if not check_for_collisions(new_position):
			position_found = true
			#print("valid position found: ", new_position)
			if new_position.x <= previous_position.x:
				sprite.flip_h = true
			else: sprite.flip_h = false
		else:
			#print("collision detected and finding a new position.")
			ray_cast.enabled = false
			wait_and_walk_again()
		
func check_for_collisions(target_position: Vector2) -> bool:
	# raycast to new position
	ray_cast.target_position = new_position - previous_position
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		#print("Colliding")
		return true
	return false #no collision

func wait_and_walk_again():
	await get_tree().create_timer(3).timeout  #3  seconds
	random_position_generator(-83, 41, 397, 339)
	set_state(States.WALKING)

func _physics_process(_delta):
	if current_state == States.WALKING:
		wander_through_shop()
