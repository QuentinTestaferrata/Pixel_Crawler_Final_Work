extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text = '[E]: '

var active_areas = []
var can_interact = true

#Interaction Area = Class name of interaction component
func add_area(area: InteractionArea) -> void:
	active_areas.append(area)

func remove_area(area: InteractionArea) -> void:
	var index = active_areas.find(area)
	if index != -1: # does index exists
		active_areas.remove_at(index)

func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(sort_by_distance_to_player)
		#Set label properties
		label.text =  base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 48
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()

func sort_by_distance_to_player(area_1, area_2):
	#This is broken but i guess it's fine
	var area_1_to_player = player.global_position.distance_to(area_1.global_position)
	var area_2_to_player = player.global_position.distance_to(area_2.global_position)
	return area_1_to_player < area_2_to_player 

func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
