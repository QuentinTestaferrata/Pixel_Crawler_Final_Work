extends Node

const ITEM_DROP = preload("res://Items and Drops/Drops/item_drop.tscn")

@export var drops: Array[DropData]

func drop_items() -> void:
	if drops.size() == 0: #if no drops ignore
		return
	for drop in drops.size():
		if drops[drop] == null:
			continue #go on to the nextone
		var drop_count: int = drops[drop].get_drop_count()
		for x in drop_count:
			var drop_instance: ItemDrop = ITEM_DROP.instantiate() as ItemDrop
			drop_instance.item_data = drops[drop].item
			var drop_holder = get_parent().get_parent().get_parent().get_node("Drops")
			drop_instance.global_position = get_parent().global_position
			drop_instance.velocity = get_parent().velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
			drop_holder.call_deferred("add_child", drop_instance)
	pass
