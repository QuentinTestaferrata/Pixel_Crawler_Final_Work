extends PanelContainer

## 16x14 size for small shop items
## 28x28 size for showcase shop items

const WEAPON_HOLDER = preload("res://UI/Shop/weapon_holder.tscn")
const ITEM_HOLDER = preload("res://UI/Shop/item_holder.tscn")
const SHOP_ITEMS = preload("res://Common/Shop/shop_items.tres")

var amount: int = 1
var item_price: int
var player: CharacterBody2D
var selected_item
var selected_item_is_weapon: bool = false
var saver_loader: SaverLoader
var buy_tab: bool = true

@onready var consumables: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Consumables
@onready var weapons: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Weapons
@onready var idk: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Idk
@onready var idk_2: TextureButton = $HBoxContainer/Items/VBoxContainer/Tabs/Idk2
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
		
		for x in player.inventory.weapons:
			if x.weapon_name == i.weapon_name:
				print(x.weapon_name, " obtained")
				
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
	
	amount_label.visible = true
	add_button.visible = true
	substract_button.visible = true
	coin_sprite.visible = true
	shadow.visible = true
	buy_button.visible = true
	texture_holder.visible = true 
	amount_number.visible = true
	
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
	update_amount()
	selected_item = i

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
		if selected_item == Item:
			item_price_label.text = str(item_price * amount, "/", StatsManager.gold)
		else: 
			item_price_label.text = str(item_price * amount, "/", StatsManager.gold)
	else:
		amount_number.text = str(amount, "/", selected_item.amount)
		item_price_label.text = str(selected_item.value * amount)
	
	if ((item_price * amount ) > StatsManager.gold):
		buy_button.disabled = true
	else:
		buy_button.disabled = false


func _on_texture_button_pressed() -> void:
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

func _on_sell_button_pressed() -> void:
	buy_tab = false
	consumables.visible = false
	weapons.visible = false
	idk.visible = false
	idk_2.visible = false
	clear_shop_items()
	get_inventory_items()
	
func _on_buy_tab_button_pressed() -> void:
	buy_tab = true
	consumables.visible = true
	weapons.visible = true
	idk.visible = true
	idk_2.visible = true
	clear_shop_items()
	get_shop_items()
	
func _on_buy_button_pressed() -> void:
	if buy_tab:
		if amount <= StatsManager.gold:
			if !selected_item_is_weapon:
				player.inventory.add_item(selected_item, amount)
				StatsManager.spend_gold(selected_item.price)
				saver_loader.save_game()
			else:
				StatsManager.shop_weapons.erase(selected_item)
				player.inventory.add_weapon(selected_item)
				StatsManager.spend_gold(selected_item.price)
				saver_loader.save_game()
				clear_shop_items()
				get_shop_weapons()
			amount = 1
			update_amount()
	else:
		StatsManager.gain_gold(selected_item.value * amount)
		player.inventory.remove_item(selected_item, amount)
		if selected_item.amount >= 1:
			amount = 1
			print_debug("test")
		else: 
			amount = 0
			buy_tab = false
			consumables.visible = false
			weapons.visible = false
			idk.visible = false
			idk_2.visible = false
		update_amount()
		clear_shop_items()
		get_inventory_items()
