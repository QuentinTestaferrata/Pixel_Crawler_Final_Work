class_name Inventory

signal new_item_obtained

const SLOT_COUNT: int = 40

var content: Array[Item]
var weapons: Array[WeaponData]
var gears: Array[GearData]

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
	var new_weapon: WeaponData = weapon.duplicate()
	new_weapon.obtained = true
	
	new_weapon.primary_attack = new_weapon.primary_attack.duplicate()
	new_weapon.secondary_attack = new_weapon.secondary_attack.duplicate()
	
	weapons.append(new_weapon)

func find_matching_weapon(weapon: WeaponData) -> WeaponData:
	for content_item in weapons:
		if content_item.weapon_name == weapon.weapon_name:
			return content_item
	return null

func remove_item(item:Item, amount: int):
	for i in content:
		if i.name == item.name:
			i.amount -= amount
			if amount == 0:
				content.erase(item)

func get_items() -> Array[Item]:
	clear_items()
	return content

func get_item_by_name(name: String) -> Item:
	for i in content:
		if i.name == name:
			return i
		else:
			print("item: ", name, " not found in inventory")
	return null

func clear_items() -> void:
	var items_to_remove = []
	for i in content:
		if i.amount < 1:
			items_to_remove.append(i)
	
	for item in items_to_remove:
		content.erase(item)

func add_gear(gear: GearData):
	new_item_obtained.emit()
	var new_gear: GearData = gear.duplicate()
	new_gear.obtained = true
	gears.append(new_gear)

func find_matching_gear(gear: GearData) -> GearData:
	for content_item in gears:
		if content_item.gear_name == gear.gear_name:
			return content_item
	return null
