extends PanelContainer

const GEAR_HOLDER = preload("res://UI/Gear_UI/GearHolder.tscn")
const OPTION_BUTTON = preload("res://UI/Dialog/Scenes/Option_Button.tscn")

var player: CharacterBody2D
var selected_gear
var saver_loader: SaverLoader
var ability_cooldowns: PanelContainer
var gear_inventory: Array[GearData]
var gear_manager: Node2D

var temp_equipe_gear_button 

@onready var equiped_jewelry: VBoxContainer = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/EquipedJewelry
@onready var equiped_ring: TextureButton = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/EquipedJewelry/Equiped_ring
@onready var equiped_ring_sprite: TextureRect = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/EquipedJewelry/Equiped_ring/TextureRect
@onready var equiped_amulets: TextureButton = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/EquipedJewelry/Equiped_Amulets
@onready var equiped_amulets_sprite: TextureRect = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/EquipedJewelry/Equiped_Amulets/TextureRect
@onready var equiped_hats: TextureButton = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/VBoxContainer3/EquipedHats
@onready var equiped_hats_sprite: TextureRect = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/VBoxContainer3/EquipedHats/TextureRect
@onready var equiped_coats: TextureButton = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/VBoxContainer3/EquipedCoats
@onready var equiped_coats_sprite: TextureRect = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/VBoxContainer3/EquipedCoats/TextureRect
@onready var equiped_boots: TextureButton = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/VBoxContainer3/EquipedBoots
@onready var equiped_boots_sprite: TextureRect = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/VBoxContainer/VBoxContainer3/EquipedBoots/TextureRect
@onready var bonus_stats_panel: PanelContainer = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/BonusStatsPanel
@onready var color_rect: ColorRect = $HBoxContainer/ColorRect
@onready var all_gear: MarginContainer = $HBoxContainer/All_Gear
@onready var vbox: VBoxContainer = $HBoxContainer/All_Gear/Vbox
@onready var tabs: HBoxContainer = $HBoxContainer/All_Gear/Vbox/Tabs
@onready var hats: TextureButton = $HBoxContainer/All_Gear/Vbox/Tabs/Hats
@onready var coats: TextureButton = $HBoxContainer/All_Gear/Vbox/Tabs/Coats
@onready var boots: TextureButton = $HBoxContainer/All_Gear/Vbox/Tabs/Boots
@onready var rings: TextureButton = $HBoxContainer/All_Gear/Vbox/Tabs/Rings
@onready var amulets: TextureButton = $HBoxContainer/All_Gear/Vbox/Tabs/Amulets
@onready var texture_rect_2: TextureRect = $HBoxContainer/All_Gear/Vbox/TextureRect2
@onready var shop_items: PanelContainer = $HBoxContainer/All_Gear/Vbox/ShopItems
@onready var scroll_container: ScrollContainer = $HBoxContainer/All_Gear/Vbox/ShopItems/ScrollContainer
@onready var grid_container: GridContainer = $HBoxContainer/All_Gear/Vbox/ShopItems/ScrollContainer/GridContainer
@onready var equipe_button: VBoxContainer = $HBoxContainer/All_Gear/Vbox/EquipeButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	ability_cooldowns.visible = false
	player = get_tree().get_first_node_in_group("player")
	saver_loader = get_tree().get_first_node_in_group("saver_loader")
	gear_inventory = player.inventory.gears

func get_gear_items() -> void:
	for i in player.inventory.gears:
		var temp_gear_holder: TextureButton = GEAR_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		sprite.texture = i.sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,16)
		sprite.position = Vector2(3, 3)
		
		temp_gear_holder.pressed.connect(get_gear_info.bind(i))
		temp_gear_holder.gear = i
		
		temp_gear_holder.add_child(sprite)
		grid_container.add_child(temp_gear_holder)
	

func show_equipe_button():
	
	for child in equipe_button.get_children():
		equipe_button.remove_child(child)
		child.queue_free()
	
	temp_equipe_gear_button = OPTION_BUTTON.instantiate()
	
	temp_equipe_gear_button.text = "Equip"
	var font = FontFile.new()
	font.font_data = load("res://Common/Poco.ttf")
		
	temp_equipe_gear_button.add_theme_font_override("font", font)
	temp_equipe_gear_button.add_theme_font_size_override("font_size", 10)
		
	temp_equipe_gear_button.add_theme_color_override("font_color", Color8(0x1B, 0x22, 0x36))
	temp_equipe_gear_button.add_theme_constant_override("content_margin_top", 5)
		
	temp_equipe_gear_button.pressed.connect(_on_temp_equipe_gear_button_pressed.bind(selected_gear))
	equipe_button.add_child(temp_equipe_gear_button )

func get_gear_info(i: GearData) -> void:
	selected_gear = i
	show_equipe_button()

func _on_temp_equipe_gear_button_pressed(selected_gear):
	if selected_gear.gear_type == "HAT":
		StatsManager.equiped_hat = selected_gear
		
	elif selected_gear.gear_type == "COAT":
		StatsManager.equiped_coat = selected_gear
		
	elif selected_gear.gear_type == "BOOTS":
		StatsManager.equiped_boots = selected_gear
		
	elif selected_gear.gear_type == "RING":
		StatsManager.equiped_ring = selected_gear
		
	elif selected_gear.gear_type == "AMULET":
		StatsManager.equiped_amulet = selected_gear
		
	
