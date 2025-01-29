class_name Inventory

signal new_item_obtained

const SLOT_COUNT: int = 40

var content: Array[Item] = []

func add_item(item: Item, amount: int = 1):
	new_item_obtained.emit()
	if item.stackable and content.has(item):
		item.amount += amount
	else:
		content.append(item)
		item.amount = amount

func remove(item:Item):
	content.erase(item)

func get_items() -> Array[Item]:
	for i in content:
		print(i.name, " amount: ", i.amount)
		
	clear_items()
	return content

func clear_items() -> void:
	var items_to_remove = []
	
	for i in content:
		print(i.amount)
		if i.amount < 1:
			print("removing: ", i.name)
			items_to_remove.append(i)
	
	for item in items_to_remove:
		content.erase(item)
