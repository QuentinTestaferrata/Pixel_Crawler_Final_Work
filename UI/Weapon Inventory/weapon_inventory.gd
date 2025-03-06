extends PanelContainer

signal weapon_clicked

const WEAPON_HOLDER = preload("res://UI/Shop/weapon_holder.tscn")

@onready var weapon_image_holder: TextureRect = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/WeaponImageHolder
@onready var weapon_name: Label = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/VBoxContainer/MarginContainer/WeaponName
@onready var weapons_grid: GridContainer = $MarginContainer/VBoxContainer/MarginContainer/ShopItems/ScrollContainer/WeaponsGrid
@onready var weapon_description: RichTextLabel = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/VBoxContainer/ScrollContainer/WeaponDescription
@onready var close_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/CloseButton
@onready var equip_1_button: TextureButton = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/VBoxContainer/HBoxContainer/Equip1Button
@onready var equip_2_button: TextureButton = $MarginContainer/VBoxContainer/WeaponSpriteShowcase/HBoxContainer/VBoxContainer/HBoxContainer/Equip2Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: CharacterBody2D
var weapon_inventory: Array[WeaponData]
var weapon_manager: Node2D
var selected_weapon: WeaponData
var ability_cooldowns: PanelContainer

func _ready() -> void:
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	ability_cooldowns.visible = false
	player = get_tree().get_first_node_in_group("player")
	weapon_inventory = player.inventory.weapons
	weapon_manager = player.weapon_manager
	
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
	var parent_node: Control = get_parent()
	equip_1_button.visible = true
	equip_2_button.visible = true
	parent_node.selected_weapon = weapon
	selected_weapon = weapon
	weapon_image_holder.texture = weapon.sprite
	weapon_name.text = weapon.weapon_name
	weapon_description.text = weapon.description
	weapon_clicked.emit()

func _on_equip_1_button_pressed() -> void:
	if selected_weapon != null && weapon_manager.equiped_weapon_2 != selected_weapon:
		weapon_manager.set_weapon(selected_weapon, 1)
		StatsManager.equiped_weapon_1 = selected_weapon
		if selected_weapon.primary_attack != null or selected_weapon.secondary_attack != null:
			AttackCooldowns.set_data(1, selected_weapon.primary_attack.COOLDOWN, selected_weapon.secondary_attack.COOLDOWN)
	AttackCooldowns.reset_cooldown_display()

func _on_equip_2_button_pressed() -> void:
	if selected_weapon != null && weapon_manager.equiped_weapon_1 != selected_weapon:
		weapon_manager.set_weapon(selected_weapon, 2)
		StatsManager.equiped_weapon_2 = selected_weapon
	AttackCooldowns.reset_cooldown_display()

func _on_close_button_pressed() -> void:
	var parent = get_parent()
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	ability_cooldowns.visible = true
	parent.close_window()
