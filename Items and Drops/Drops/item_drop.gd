extends CharacterBody2D
class_name ItemDrop

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var collision_shape_2d2: CollisionShape2D = $CollisionShape2D
@onready var item_data: Item
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var item_drop: ItemDrop = $"."
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var shadow: Sprite2D = $Shadow

var picked_up: bool = false
var target: CharacterBody2D
var target_position

func _ready() -> void:
	sprite_2d.texture = item_data.sprite
	sprite_2d.global_position = item_drop.global_position
	if item_data.rarity == 1:
		pass
		#shadow.modulate

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.inventory.add_item(item_data)
		animation.play("picked_up")
		target = body
		picked_up = true
		shadow.visible = false

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(-velocity * delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4
	
	if picked_up:
		target_position = target.global_position
		global_position = lerp(global_position, Vector2(target_position.x -5 , target_position.y), 5*delta)
