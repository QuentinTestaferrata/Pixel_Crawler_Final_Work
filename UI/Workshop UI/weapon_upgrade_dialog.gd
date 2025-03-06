extends PanelContainer

signal panel_closed

const WEAPON_HOLDER = preload("uid://cfu50vbnqd73i")

var player: CharacterBody2D
var inventory_items: Array[Item]
var selected_weapon: WeaponData
var payement_item: Item
var selected_attack: int = 0

@onready var close_button: TextureButton = $HBoxContainer/RightPage/VBoxContainer/HBoxContainer3/MarginContainer/CloseButton
@onready var weapon_image: TextureRect = $HBoxContainer/RightPage/VBoxContainer/HBoxContainer3/TextureHolder/ItemImage
@onready var weapon_name_label: Label = $HBoxContainer/RightPage/VBoxContainer/MarginContainer/WeaponNameLabel
@onready var primary_attack_sprite: TextureRect = $HBoxContainer/RightPage/VBoxContainer/AttackButtonsContainer/PrimaryAttackButton/PrimaryAttackSprite
@onready var secondary_attack_sprite: TextureRect = $HBoxContainer/RightPage/VBoxContainer/AttackButtonsContainer/SecondaryAttackButton/SecondaryAttackSprite
@onready var grid: GridContainer = $HBoxContainer/LeftPage/CenterContainer/WeaponsPanel/ScrollContainer/MarginContainer/Grid
@onready var item_texture: TextureRect = $HBoxContainer/RightPage/VBoxContainer/PriceContainer/MarginContainer/ItemTexture
@onready var amount_label: Label = $HBoxContainer/RightPage/VBoxContainer/PriceContainer/AmountLabel
@onready var current_damage_label: Label = $HBoxContainer/RightPage/VBoxContainer/DamageStats/CurrentDamageLabel
@onready var upgraded_damage_label: Label = $HBoxContainer/RightPage/VBoxContainer/DamageStats/UpgradedDamageLabel
@onready var current_level_label: Label = $HBoxContainer/RightPage/VBoxContainer/LevelStats/CurrentLevelLabel
@onready var upgraded_level_label: Label = $HBoxContainer/RightPage/VBoxContainer/LevelStats/UpgradedLevelLabel

#Invisible at start containers
@onready var attack_buttons_container: HBoxContainer = $HBoxContainer/RightPage/VBoxContainer/AttackButtonsContainer
@onready var price_container: HBoxContainer = $HBoxContainer/RightPage/VBoxContainer/PriceContainer
@onready var damage_stats: HBoxContainer = $HBoxContainer/RightPage/VBoxContainer/DamageStats
@onready var level_stats: HBoxContainer = $HBoxContainer/RightPage/VBoxContainer/LevelStats
@onready var please_select_container: MarginContainer = $HBoxContainer/RightPage/VBoxContainer/PleaseSelectContainer
@onready var margin_container_2: MarginContainer = $HBoxContainer/RightPage/MarginContainer2


func _ready() -> void:
	show_right_page(false)
	
	player = get_tree().get_first_node_in_group("player")
	inventory_items = player.inventory.get_items()
	get_weapons()

func get_weapons() -> void:
	for i in player.inventory.weapons:
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
		grid.add_child(temp_item_holder)

func get_weapon_info(i: WeaponData) -> void:
	attack_buttons_container.visible = true
	please_select_container.visible = false
	selected_weapon = i
	weapon_image.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	
	if i.showcase_sprite != null:
		weapon_image.texture = i.showcase_sprite
	else: weapon_image.texture = i.sprite
	
	weapon_name_label.text = i.weapon_name
	
	#for x in player.inventory.weapons:
		#if x.weapon_name == i.weapon_name:
			#weapon_to_upgrade = x
	price_container.visible = false
	damage_stats.visible = false
	level_stats.visible = false
	if selected_weapon.primary_attack_sprite:
		primary_attack_sprite.visible = true
		primary_attack_sprite.texture = i.primary_attack_sprite
	else: 
		primary_attack_sprite.visible = false
		
	if selected_weapon.secondary_attack_sprite:
		secondary_attack_sprite.texture = i.secondary_attack_sprite
		secondary_attack_sprite.visible = true
		#print(selected_weapon.secondary_attack_sprite)
	else: 
		secondary_attack_sprite.visible = false

func _on_primary_attack_button_pressed() -> void:
	selected_attack = 1
	show_right_page(true)
	if selected_weapon:
		get_inventory_item(selected_weapon.primary_attack.item)
		get_projectile_damage(selected_weapon.primary_attack)
		item_texture.texture = selected_weapon.primary_attack.item.sprite
		amount_label.text = str(payement_item.amount, "/", selected_weapon.primary_attack.amount)
		
		if payement_item.amount >= selected_weapon.primary_attack.amount:
			amount_label.add_theme_color_override("font_color", Color.FOREST_GREEN)
		else:
			amount_label.add_theme_color_override("font_color", Color.CRIMSON)
			
		current_damage_label.text = str("Damage: ", get_projectile_damage(selected_weapon.primary_attack))
		upgraded_damage_label.text = str(get_upgraded_projectile_damage(selected_weapon.primary_attack))
		current_level_label.text = str("Level: ", selected_weapon.weapon_level)
		upgraded_level_label.text = str(selected_weapon.weapon_level + 1)
		
func _on_secondary_attack_button_pressed() -> void:
	selected_attack = 2
	show_right_page(true)
	if selected_weapon:
		get_inventory_item(selected_weapon.secondary_attack.item)
		get_projectile_damage(selected_weapon.secondary_attack)
		item_texture.texture = selected_weapon.secondary_attack.item.sprite
		amount_label.text = str(payement_item.amount, "/", selected_weapon.secondary_attack.amount)
		
		if payement_item.amount >= selected_weapon.secondary_attack.amount:
			amount_label.add_theme_color_override("font_color", Color.FOREST_GREEN)
		else:
			amount_label.add_theme_color_override("font_color", Color.CRIMSON)
		
		current_damage_label.text = str("Damage: ", get_projectile_damage(selected_weapon.secondary_attack))
		upgraded_damage_label.text = str(get_upgraded_projectile_damage(selected_weapon.secondary_attack))
		current_level_label.text = str("Level: ", selected_weapon.weapon_level)
		upgraded_level_label.text = str(selected_weapon.weapon_level + 1)

func _on_close_button_pressed() -> void:
	$AnimationPlayer.play("close")

func get_inventory_item(item: Item) -> void:
	for i in inventory_items:
		if item and item.name == i.name:
			payement_item = i
			#print(payement_item)

func get_projectile_damage(projectile: PROJECTILE) -> int:
	return projectile.DAMAGE

func get_upgraded_projectile_damage(projectile: PROJECTILE) -> int:
	return projectile.DAMAGE * projectile.damage_multiplyer

func show_right_page(_show: bool) -> void:
	if _show:
		attack_buttons_container.visible = true
		price_container.visible = true
		damage_stats.visible = true
		level_stats.visible = true
		margin_container_2.visible = true
		please_select_container.visible = false
	else: 
		attack_buttons_container.visible = false
		price_container.visible = false
		damage_stats.visible = false
		level_stats.visible = false
		margin_container_2.visible = false
		please_select_container.visible = true

func _on_upgrade_pressed() -> void:
	match selected_attack:
		1: 
			if pay():
				selected_weapon.primary_attack.DAMAGE *= selected_weapon.primary_attack.damage_multiplyer
				selected_weapon.primary_attack.DAMAGE = int(selected_weapon.primary_attack.DAMAGE)
				selected_weapon.weapon_level += 1
				selected_weapon.primary_attack.amount *= selected_weapon.primary_attack.price_multiplyer
				
				print(selected_weapon.primary_attack.DAMAGE)
				_on_primary_attack_button_pressed()
		2:
			if pay(): 
				selected_weapon.secondary_attack.DAMAGE *= selected_weapon.secondary_attack.damage_multiplyer
				selected_weapon.secondary_attack.DAMAGE = int(selected_weapon.secondary_attack.DAMAGE)
				selected_weapon.weapon_level += 1
				selected_weapon.secondary_attack.amount *= selected_weapon.secondary_attack.price_multiplyer
				
				_on_secondary_attack_button_pressed()

func pay() -> bool:
	match selected_attack:
		1: 
			if payement_item.amount >= selected_weapon.primary_attack.amount:
				payement_item.amount -= selected_weapon.primary_attack.amount
				print(payement_item.amount)
				print("Bought!")
				return true
			else: 
				print("Can't buy")
				return false
			
		2: 
			if payement_item.amount >= selected_weapon.secondary_attack.amount:
				payement_item.amount -= selected_weapon.secondary_attack.amount
				print("Bought!")
				print(payement_item.amount)
				return true
			else: 
				print("Can't buy")
				return false
	return false
