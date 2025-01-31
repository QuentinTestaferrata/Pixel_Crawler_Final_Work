class_name Inventory

signal new_item_obtained

const SLOT_COUNT: int = 40

var content: Array[Item]
var weapons: Array[WeaponData]

func add_item(item: Item, amount: int = 1):
	new_item_obtained.emit()
	var existing_item = find_matching_item(item)
	if existing_item:
		existing_item.amount += amount
	else:
		var new_item = item.duplicate()
		content.append(new_item)
		new_item.amount = amount

func find_matching_item(item: Item) -> Item:
	for content_item in content:
		if content_item.name == item.name:
			return content_item
	return null

func add_weapon(weapon: WeaponData):
	new_item_obtained.emit()
	var existing_item = find_matching_weapon(weapon)
	var new_weapon = weapon.duplicate()
	weapons.append(new_weapon)

func find_matching_weapon(weapon: WeaponData) -> WeaponData:
	for content_item in weapons:
		if content_item.weapon_name == weapon.weapon_name:
			return content_item
	return null

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
