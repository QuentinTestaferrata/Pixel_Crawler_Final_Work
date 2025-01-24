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
	print("Inventory Content")
	for i in content:
		print(i.name, " amount: ", i.amount)
	return content
