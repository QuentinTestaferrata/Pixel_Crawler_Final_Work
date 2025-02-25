extends Node2D

@export var all_zones: Array[PackedScene]

var current_selected_zone: int
var canvas_layer: CanvasLayer
var current_page: Control
var ability_cooldowns: PanelContainer

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	current_selected_zone = 0
	canvas_layer = get_parent().get_child(0)

func on_interact():
	current_selected_zone = 0
	instantiate_zone_page(0)

func instantiate_zone_page(i: int) -> void:
	var level_info: Control = all_zones[i].instantiate()
	
	level_info.connect("next_pressed", next)
	level_info.connect("prev_pressed", prev)
	
	current_page = level_info
	
	canvas_layer.add_child(level_info)

func next() -> void:
	if current_selected_zone < all_zones.size() - 1:
		current_selected_zone += 1
		print(current_selected_zone)
		current_page.play_animation("despawn")
		current_page.queue_free()
		instantiate_zone_page(current_selected_zone)

func prev() -> void:
	if current_selected_zone > 0:
		current_selected_zone -= 1
		print(current_selected_zone)
		current_page.play_animation("despawn")
		current_page.queue_free()
		instantiate_zone_page(current_selected_zone)
