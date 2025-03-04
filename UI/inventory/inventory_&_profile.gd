extends Control
class_name InventoryUI

const Slot = preload("res://UI/inventory/slots/slot.tscn")

var total_slots_amount: int = 40
var inventory: Inventory = null
var player: Player = null
var inventory_items: Array[Item]
var inventory_slots: Array[TextureButton]

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/GridContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	inventory = player.inventory
	inventory.new_item_obtained.connect(update_inventory)
	
	for slot in total_slots_amount:
		var new_slot: TextureButton = Slot.instantiate()
		grid_container.add_child(new_slot)
		inventory_slots.append(new_slot)
	
	update_inventory()

func update_inventory() -> void:
	inventory_items = inventory.get_items()
	var total_items: int = inventory_items.size()
	
	for i in total_items:
		#if inventory_items[i].amount > 0:
			inventory_slots[i].set_label(str(inventory_items[i].amount))
			inventory_slots[i].set_texture(inventory_items[i].sprite, Vector2(.85, .85))
			inventory_slots[i].item_name = inventory_items[i].name
			inventory_slots[i].description = inventory_items[i].description
			inventory_slots[i].value = inventory_items[i].value
			inventory_slots[i].rarity = inventory_items[i].rarity_string

func close_inventory() -> void:
	animation_player.play("close")

func get_slot_item_information(slot_id: int) -> Item:
	return inventory_items[slot_id]
