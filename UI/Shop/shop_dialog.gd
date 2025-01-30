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

@onready var scroll_container: ScrollContainer = $HBoxContainer/Items/VBoxContainer/ShopItems/ScrollContainer
@onready var grid_container: GridContainer = $HBoxContainer/Items/VBoxContainer/ShopItems/ScrollContainer/GridContainer
@onready var item_name_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/ItemNameLabel
@onready var item_description_label: RichTextLabel = $HBoxContainer/MarginContainer/VBoxContainer/ItemDescriptionLabel
@onready var item_image: TextureRect = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/TextureHolder/ItemImage
@onready var item_price_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/PriceLabel
@onready var coin_sprite: TextureRect = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureRect
@onready var amount_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/AmountLabel
@onready var add_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AddButton
@onready var substract_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/SubstractButton
@onready var buy_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/BuyButton
@onready var texture_holder: TextureRect = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/TextureHolder
@onready var shadow: Sprite2D = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/TextureHolder/ItemImage/Shadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buy_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/BuyButton/BuyLabel
@onready var amount_number: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/Amount

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	get_shop_items()

func get_shop_items() -> void:
	print("Shop items: ")
	for i in SHOP_ITEMS.shop_items:
		var temp_item_holder: TextureButton = ITEM_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		sprite.texture = i.sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)
		
		temp_item_holder.pressed.connect(get_item_info.bind(i))
		temp_item_holder.item = i
		temp_item_holder.weapon = null
		
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)
		
		print(i.name)

func get_shop_weapons() -> void:
	print("Shop Weapons: ")
	for i in SHOP_ITEMS.shop_weapons:
		var temp_item_holder: TextureButton = WEAPON_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		sprite.texture = i.shop_sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)
		
		temp_item_holder.pressed.connect(get_weapon_info.bind(i))
		temp_item_holder.item = null
		temp_item_holder.weapon = i
		
		temp_item_holder.add_child(sprite)
		grid_container.add_child(temp_item_holder)
		
		print(i.weapon_name)

func get_item_info(i: Item) -> void:
	amount_label.visible = true
	add_button.visible = true
	substract_button.visible = true
	coin_sprite.visible = true
	shadow.visible = true
	buy_button.visible = true
	texture_holder.visible = true 
	amount_number.visible = true
	
	item_image.texture = i.sprite
	item_name_label.text = i.name
	item_description_label.text = i.description
	item_price = i.price
	item_price_label.text = str(i.price)
	update_amount()
	
	selected_item = i

func get_weapon_info(i: WeaponData) -> void:
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
	amount += 1
	update_amount()

func _on_substract_button_pressed() -> void:
	if amount > 1:
		amount -= 1
		update_amount()

func update_amount() -> void:
	amount_number.text = str(amount)
	item_price_label.text = str(item_price * amount)
	
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
	clear_shop_items()
	get_shop_items()

func _on_weapons_pressed() -> void:
	clear_shop_items()
	get_shop_weapons()

func _on_buy_button_pressed() -> void:
	player.inventory.add_item(selected_item, amount)
	print(selected_item.amount)
