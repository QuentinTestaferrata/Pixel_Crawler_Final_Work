extends PanelContainer

## 16x14 size for small shop items
## 28x28 size for showcase shop items

const WEAPON_HOLDER = preload("res://UI/Shop/weapon_holder.tscn")
const ITEM_HOLDER = preload("res://UI/Shop/item_holder.tscn")
const SHOP_ITEMS = preload("res://Common/Shop/shop_items.tres")
const GEAR_HOLDER = preload("res://UI/Gear_UI/GearHolder.tscn")

var amount: int = 1
var item_price: int
var player: CharacterBody2D
var selected_item
var selected_item_is_weapon: bool = false
var selected_item_is_gear: bool = false
var saver_loader: SaverLoader
var buy_tab: bool = true
var ability_cooldowns: PanelContainer

@onready var resources_tab: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Resources
@onready var consumables: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Consumables
@onready var weapons: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Weapons
@onready var gear: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Gear
@onready var scroll_container: ScrollContainer = $HBoxContainer/Items/VBoxContainer/ShopItems/ScrollContainer
@onready var grid_container: GridContainer = $HBoxContainer/Items/VBoxContainer/ShopItems/ScrollContainer/GridContainer
@onready var item_name_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/ItemNameLabel
@onready var item_description_label: RichTextLabel = $HBoxContainer/MarginContainer/VBoxContainer/ItemDescriptionLabel
@onready var item_image: TextureRect = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/TextureHolder/ItemImage
@onready var item_price_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/PriceLabel
@onready var amount_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/AmountLabel
@onready var add_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AddButton
@onready var substract_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/SubstractButton
@onready var buy_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/BuyButton
@onready var texture_holder: TextureRect = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/TextureHolder
@onready var shadow: Sprite2D = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/TextureHolder/ItemImage/Shadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buy_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/BuyButton/BuyLabel
@onready var amount_number: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/Amount
@onready var coin_sprite: TextureRect = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer2/TextureRect
@onready var sell_button: TextureButton = $HBoxContainer/Items/VBoxContainer/BuySellButtons/SellButton
@onready var buy_tab_button: TextureButton = $HBoxContainer/Items/VBoxContainer/BuySellButtons/BuyTabButton

func _ready() -> void:
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	ability_cooldowns.visible = false
	player = get_tree().get_first_node_in_group("player")
	saver_loader = get_tree().get_first_node_in_group("saver_loader")
	get_shop_items()

func get_shop_items() -> void:
	for i in StatsManager.shop_items:
		var temp_item_holder: TextureButton = ITEM_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		buy_label.text = "Buy"
		
		sprite.texture = i.sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)
		
		temp_item_holder.pressed.connect(get_item_info.bind(i))
		temp_item_holder.item = i
		temp_item_holder.weapon = null
		
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)
		
func get_shop_resources() -> void:
	for i in StatsManager.shop_resources:
		var temp_item_holder: TextureButton = ITEM_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		buy_label.text = "Buy"
		
		sprite.texture = i.sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)
		
		temp_item_holder.pressed.connect(get_item_info.bind(i))
		temp_item_holder.item = i
		temp_item_holder.weapon = null
		temp_item_holder.gear = null
		
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)
		
func get_shop_weapons() -> void:
	for i in StatsManager.shop_weapons:
		var temp_item_holder: TextureButton = WEAPON_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		buy_label.text = "Buy"
		
		sprite.texture = i.shop_sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)

		temp_item_holder.pressed.connect(get_weapon_info.bind(i))
		temp_item_holder.item = null
		temp_item_holder.weapon = i
		temp_item_holder.gear = null
		
		for x in player.inventory.weapons:
			if x.weapon_name == i.weapon_name:
				print(x.weapon_name, " obtained")
				
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)

func get_shop_gears() -> void:
	for i in StatsManager.shop_gears:
		var temp_item_holder: TextureButton = GEAR_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		buy_label.text = "Buy"
		
		sprite.texture = i.shop_sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)

		temp_item_holder.pressed.connect(get_gear_info.bind(i))
		temp_item_holder.item = null
		temp_item_holder.weapon = null
		temp_item_holder.gear = i
		
		for x in player.inventory.gears:
			if x.gear_name == i.gear_name:
				print(x.gear_name, " obtained")
				
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)

func get_inventory_items() -> void:
	for i in player.inventory.content:
		var temp_item_holder: TextureButton = ITEM_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		buy_label.text = "Sell"
		
		sprite.texture = i.sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)
		
		temp_item_holder.pressed.connect(get_item_info.bind(i))
		temp_item_holder.item = i
		temp_item_holder.weapon = null
		
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)

func get_item_info(i: Item) -> void:
	selected_item = i
	amount = 1
	selected_item_is_weapon = false
	selected_item_is_gear = false
	
	amount_label.visible = true
	add_button.visible = true
	substract_button.visible = true
	coin_sprite.visible = true
	shadow.visible = true
	buy_button.visible = true
	texture_holder.visible = true 
	amount_number.visible = true
	coin_sprite.texture = preload("res://UI/coin.png")
	if buy_tab:
		item_image.texture = i.sprite
		item_name_label.text = i.name
		item_description_label.text = i.description
		item_price = i.price
		item_price_label.text = str(i.price)
	else: 
		item_image.texture = i.sprite
		item_name_label.text = i.name
		item_description_label.text = i.description
		item_price = i.price
		item_price_label.text = str(i.price)
	update_amount()

func get_weapon_info(i: WeaponData) -> void:
	selected_item_is_weapon = true
	buy_tab = true
	
	amount_label.visible = false
	add_button.visible = false
	substract_button.visible = false
	coin_sprite.visible = true
	shadow.visible = false
	buy_button.visible = true
	texture_holder.visible = true 
	amount_number.visible = false
	
	item_image.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	
	if i.showcase_sprite != null:
		item_image.texture = i.showcase_sprite
	else: item_image.texture = i.sprite
	
	item_name_label.text = i.weapon_name
	item_description_label.text = i.description
	item_price = i.price
	item_price_label.text = str(i.price)
	coin_sprite.texture = preload("res://UI/coin.png")
	update_amount()
	selected_item = i

func get_gear_info(i: GearData) -> void:
	selected_item_is_gear = true
	buy_tab = true
	
	amount_label.visible = false
	add_button.visible = false
	substract_button.visible = false
	coin_sprite.visible = true
	shadow.visible = false
	buy_button.visible = true
	texture_holder.visible = true 
	amount_number.visible = false
	
	item_image.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	
	if i.shop_sprite != null:
		item_image.texture = i.shop_sprite
	else: item_image.texture = i.sprite
	
	item_name_label.text = i.gear_name
	item_description_label.text = ("Bonus Health: +" + str(i.extra_health) if i.extra_health != 0 else "") + "\n" + \
	("Bonus Speed: +" + str(i.speed_multiplier) + "%" if i.speed_multiplier != 0 else "")
	
	var required_item = player.inventory.get_item_by_name(i.item_name)
	if required_item != null:
		print("Item found in inventory:", required_item.name, "Amount:", required_item.amount)
		item_price_label.text = "Price: " + str(i.price) + "x " + required_item.name + str(required_item.amount) + ")"
		coin_sprite.texture = required_item.sprite
	else:
		pass
	
	item_price = i.price
	item_price_label.text = str(i.price)
	selected_item = i
	update_amount()
	

func _on_add_button_pressed() -> void:
	if buy_tab:
		amount += 1
		update_amount()
	else:
		if amount < selected_item.amount:
			amount += 1
			update_amount()

func _on_substract_button_pressed() -> void:
	if buy_tab:
		if amount > 1:
			amount -= 1
			update_amount()
	else:
		if amount > 0:
			amount -= 1
			update_amount()

func update_amount() -> void:
	if buy_tab:
		amount_number.text = str(amount)
		
		if selected_item_is_gear:
			var required_item = player.inventory.get_item_by_name(selected_item.item_name)
			var required_amount = required_item.amount if required_item != null else 0  
			
			item_price_label.text = str(item_price * amount) + " / " + str(required_amount)
			
			buy_button.disabled = (required_amount < item_price * amount)
		else:  
			item_price_label.text = str(item_price * amount) + " / " + str(StatsManager.gold)
			buy_button.disabled = ((item_price * amount) > StatsManager.gold)
	else:
		amount_number.text = str(amount) + " / " + str(selected_item.amount)
		item_price_label.text = str(selected_item.value * amount)


func _on_texture_button_pressed() -> void:
	ability_cooldowns.visible = true
	animation_player.play("close")

func clear_shop_items() -> void:
	var grid_children: Array = grid_container.get_children()
	for i in grid_children:
		i.queue_free()

## Show specific tabs
func _on_consumables_pressed() -> void:
	buy_tab = true
	clear_shop_items()
	get_shop_items()

func _on_weapons_pressed() -> void:
	buy_tab = true
	clear_shop_items()
	get_shop_weapons()

func _on_gear_pressed() -> void:
	buy_tab = true
	clear_shop_items()
	get_shop_gears()


func _on_resources_tab_pressed() -> void:
	buy_tab = true
	clear_shop_items()
	get_shop_resources()
	

func _on_sell_button_pressed() -> void:
	buy_tab = false
	consumables.visible = false
	weapons.visible = false
	resources_tab.visible = false
	gear.visible = false
	clear_shop_items()
	get_inventory_items()
	
func _on_buy_tab_button_pressed() -> void:
	buy_tab = true
	consumables.visible = true
	weapons.visible = true
	resources_tab.visible = true
	gear.visible = true
	clear_shop_items()
	get_shop_items()
	
func _on_buy_button_pressed() -> void:
	if buy_tab:
		if selected_item_is_gear:
			var required_item = player.inventory.get_item_by_name(selected_item.item_name)  
			
			if required_item != null and required_item.amount >= selected_item.price:
				player.inventory.remove_item(required_item, selected_item.price)  
				player.inventory.add_gear(selected_item) 
				StatsManager.shop_gears.erase(selected_item)
				saver_loader.save_game() 
				clear_shop_items()
				get_shop_gears()
				print("Gear bought:", selected_item.gear_name)
			else:
				print("Not enough", selected_item.gear_name)
				return  
		elif selected_item_is_weapon:
			if amount <= StatsManager.gold:
				StatsManager.shop_weapons.erase(selected_item)
				player.inventory.add_weapon(selected_item)
				StatsManager.spend_gold(selected_item.price)
				saver_loader.save_game()
				clear_shop_items()
				get_shop_weapons()
			else:
				print("Not enough", selected_item.gear_name)
				return  
		else:
			if amount <= StatsManager.gold:
				player.inventory.add_item(selected_item, amount)
				StatsManager.spend_gold(selected_item.price)
				saver_loader.save_game()
			else:
				print("Not enough", selected_item.gear_name)
				return  
		amount = 1
		update_amount()
	
	else:
		StatsManager.gain_gold(selected_item.value * amount)
		player.inventory.remove_item(selected_item, amount)
		if selected_item.amount >= 1:
			amount = 1
		else: 
			amount = 0
			buy_tab = false
			consumables.visible = false
			weapons.visible = false
			resources_tab.visible = false
			gear.visible = false
		update_amount()
		clear_shop_items()
		get_inventory_items()
