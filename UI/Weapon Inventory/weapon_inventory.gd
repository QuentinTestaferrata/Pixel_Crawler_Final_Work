extends PanelContainer

const WEAPON_HOLDER = preload("res://UI/Shop/weapon_holder.tscn")

@onready var weapon_image_holder: TextureRect = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/WeaponImageHolder
@onready var weapon_name: Label = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/VBoxContainer/MarginContainer/WeaponName
@onready var weapons_grid: GridContainer = $MarginContainer/VBoxContainer/MarginContainer/ShopItems/ScrollContainer/WeaponsGrid
@onready var weapon_description: RichTextLabel = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/VBoxContainer/ScrollContainer/WeaponDescription

var player: CharacterBody2D
var weapon_inventory: Array[WeaponData]

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	weapon_inventory = player.inventory.weapons
	print(weapon_inventory)
	_show_weapons()

func _show_weapons() -> void:
	for i in weapon_inventory:
		var temp_item_holder: TextureButton = WEAPON_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		sprite.texture = i.shop_sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,14)
		sprite.position = Vector2(3, 3)
		
		temp_item_holder.pressed.connect(_showcase_weapon.bind(i))
		temp_item_holder.item = null
		temp_item_holder.weapon = i
		
		temp_item_holder.add_child(sprite)
		weapons_grid.add_child(temp_item_holder)

func _showcase_weapon(weapon: WeaponData) -> void:
	weapon_image_holder.texture = weapon.sprite
	weapon_name.text = weapon.weapon_name
	weapon_description.text = weapon.description
