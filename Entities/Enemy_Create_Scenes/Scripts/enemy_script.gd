extends CharacterBody2D
class_name Enemy

const ITEM_DROP = preload("res://Items and Drops/Drops/item_drop.tscn")

@export var speed: int = 70
@export var damage_type: String

var enemy_container: Node2D

@onready var die: Node = $StateMachine/Die
@onready var hitbox_component: HurtboxComponent = $HitboxComponent

func _ready() -> void:
	set_collision_layer_value(1, true)
	set_collision_layer_value(6, true)
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true)
	
	hitbox_component.set_collision_layer_value(1, false)
	hitbox_component.set_collision_layer_value(7, true)
	
	hitbox_component.set_collision_mask_value(1, false)
	hitbox_component.set_collision_mask_value(2, false)
	enemy_container = get_parent()
	die.died.connect(test)
	
	StatsManager.player_died.connect(despawn)

func despawn() -> void:
	queue_free()

func test():
	if enemy_container.has_method("emit_kill_signal"):
		enemy_container.emit_kill_signal()
