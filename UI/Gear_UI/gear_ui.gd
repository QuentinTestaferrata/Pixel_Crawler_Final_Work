extends PanelContainer

const GEAR_HOLDER = preload("res://UI/Gear_UI/GearHolder.tscn")
const OPTION_BUTTON = preload("res://UI/Dialog/Scenes/Option_Button.tscn")

var player: CharacterBody2D
var selected_gear
var ability_cooldowns: PanelContainer
var gear_inventory: Array[GearData]
var gear_manager: Node2D

var stat_labels := {}
var temp_equipe_gear_button 
var base_speed:int

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
@onready var stat_list: VBoxContainer = $HBoxContainer/Equiped_Gear/MarginContainer/VBoxContainer2/BonusStatsPanel/StatList
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
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	ability_cooldowns.visible = false
	player = get_tree().get_first_node_in_group("player")
	gear_inventory = player.inventory.gears
	
	
	equiped_hats.pressed.connect(_on_unequip_button_pressed.bind("HAT"))
	equiped_coats.pressed.connect(_on_unequip_button_pressed.bind("COAT"))
	equiped_boots.pressed.connect(_on_unequip_button_pressed.bind("BOOTS"))
	equiped_ring.pressed.connect(_on_unequip_button_pressed.bind("RING"))
	equiped_amulets.pressed.connect(_on_unequip_button_pressed.bind("AMULET"))
	
	
	create_stat_labels()
	get_gear_items()
	load_equipped_gear()  
	update_inventory_visibility()
	base_speed = 100
	#base_damage = StatsManager.equiped_weapon_1.damage if StatsManager.equiped_weapon_1 else 1.0 TODO
	#base_fire_rate = StatsManager.equiped_weapon_1.fire_rate_multiplier if StatsManager.equiped_weapon_1 else 1.0 TODO
	#base_critical_hit = StatsManager.equiped_weapon_1.critical_hit_multiplier if StatsManager.equiped_weapon_1 else 1.0 TODO

func get_gear_items() -> void:
	for i in player.inventory.gears:
		var temp_gear_holder: TextureButton = GEAR_HOLDER.instantiate()
		var sprite: TextureRect = TextureRect.new()
		
		sprite.texture = i.sprite
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		sprite.size = Vector2(16,16)
		sprite.position = Vector2(3, 3)
		
		temp_gear_holder.pressed.connect(get_gear_info.bind(i))
		
		temp_gear_holder.add_child(sprite)
		#temp_gear_holder.gear = i
		temp_gear_holder.visible = (i.equip_slot == 0)
		grid_container.add_child(temp_gear_holder)

func set_font_style(label: Control) -> void:
	var font = FontFile.new()
	font.font_data = load("res://Common/Poco.ttf")
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color8(0x1B, 0x22, 0x36))

func show_equipe_button():
	for child in equipe_button.get_children():
		equipe_button.remove_child(child)
		child.queue_free()
	
	temp_equipe_gear_button = OPTION_BUTTON.instantiate()
	temp_equipe_gear_button.text = "Equip"
	
	set_font_style(temp_equipe_gear_button)  # ✅ Appelle la fonction au lieu de répéter 3 lignes
	
	temp_equipe_gear_button.pressed.connect(_on_temp_equipe_gear_button_pressed.bind(selected_gear))
	equipe_button.add_child(temp_equipe_gear_button)


func get_gear_info(i: GearData) -> void:
	selected_gear = i
	show_equipe_button()

func _on_temp_equipe_gear_button_pressed(gear: GearData):
	if gear in [StatsManager.equiped_hat, StatsManager.equiped_coat, StatsManager.equiped_boots, StatsManager.equiped_ring, StatsManager.equiped_amulet]:
		return  
	var gear_slots = {
		0: ["equiped_hat", equiped_hats_sprite],
		1: ["equiped_coat", equiped_coats_sprite],
		2: ["equiped_boots", equiped_boots_sprite],
		3: ["equiped_ring", equiped_ring_sprite],
		4: ["equiped_amulet", equiped_amulets_sprite]
	}
	
	if gear.gear_type in gear_slots:
		var slot_name = gear_slots[gear.gear_type][0]
		var slot_sprite = gear_slots[gear.gear_type][1]
		StatsManager[slot_name] = gear
		slot_sprite.texture = gear.sprite
	
	gear.equip_slot = 1
	
	load_equipped_gear()
	update_bonus_stats()
	update_inventory_visibility()
	update_equiped_gear()
	get_gear_items()



func update_bonus_stats() -> void:
	
	var total_damage_multiplier = 0
	var total_speed_multiplier = 0
	var total_extra_health = 0
	var total_regeneration = 0
	var total_fire_rate_multiplier = 0
	var total_critical_hit_multiplier = 0
	
	for gear in [StatsManager.equiped_hat, StatsManager.equiped_coat, StatsManager.equiped_boots, StatsManager.equiped_ring, StatsManager.equiped_amulet]:
		if gear:
			total_extra_health += gear.extra_health
			total_regeneration += gear.regenaration
			total_speed_multiplier += gear.speed_multiplier
			total_damage_multiplier += gear.damage_multiplier
			total_fire_rate_multiplier += gear.fire_rate_multiplier
			total_critical_hit_multiplier += gear.critical_hit_multiplier
	
	StatsManager.max_health = StatsManager.max_health + total_extra_health  # Adding bonus hp TODO
	StatsManager.health_changed.emit()
	#player.current_health = min(player.current_health, player.max_health)  # Check to not regen more than max health TODO
	player.speed = base_speed * (1 + total_speed_multiplier / 100.0)  # Multiplication par le % total
	
	#if StatsManager.equiped_weapon_1: TODO
		#StatsManager.equiped_weapon_1.damage = base_damage * (1 + total_damage_multiplier / 100.0)
		#StatsManager.equiped_weapon_1.fire_rate_multiplier = base_fire_rate * (1 + total_fire_rate_multiplier / 100.0)
		#StatsManager.equiped_weapon_1.critical_hit_multiplier = base_critical_hit * (1 + total_critical_hit_multiplier / 100.0)
	#
	#if StatsManager.equiped_weapon_2: TODO
		#StatsManager.equiped_weapon_2.damage = base_damage * (1 + total_damage_multiplier / 100.0)
		#StatsManager.equiped_weapon_2.fire_rate_multiplier = base_fire_rate * (1 + total_fire_rate_multiplier / 100.0)
		#StatsManager.equiped_weapon_2.critical_hit_multiplier = base_critical_hit * (1 + total_critical_hit_multiplier / 100.0)
	
	
	stat_labels["Extra Health"].text = "Extra Health: " + str(total_extra_health)
	stat_labels["Regeneration"].text = "Regeneration: " + str(total_regeneration) + " HP/s"
	stat_labels["Speed Bonus"].text = "Speed Bonus: " + str(total_speed_multiplier) + "%"
	stat_labels["Damage Bonus"].text = "Damage Bonus: " + str(total_damage_multiplier) + "%"
	stat_labels["Fire Rate Bonus"].text = "Fire Rate Bonus: " + str(total_fire_rate_multiplier) + "%"
	stat_labels["Critical Hit Bonus"].text = "Critical Hit Bonus: " + str(total_critical_hit_multiplier) + "%"
	


func create_stat_labels():
	var stats_to_display = [
	"Extra Health", "Regeneration", "Speed Bonus", 
	"Damage Bonus", "Fire Rate Bonus", "Critical Hit Bonus"
	]
		
	# To avoid double stats
	for child in stat_list.get_children():
		stat_list.remove_child(child)
		child.queue_free()
		
	var font = FontFile.new()
	font.font_data = load("res://Common/Poco.ttf") 
	
	# Label creation
	for stat in stats_to_display:
		var label = Label.new()
		label.name = stat
		label.text = stat + ": 0"  # Default Value
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color8(0x1B, 0x22, 0x36))
		stat_list.add_child(label)
		stat_labels[stat] = label  

func _on_close_button_pressed() -> void:
	ability_cooldowns.visible = true
	animation_player.play("close")

func load_equipped_gear():
	var equipped_gear = {
	"Hat": StatsManager.equiped_hat,
	"Coat": StatsManager.equiped_coat,
	"Boots": StatsManager.equiped_boots,
	"Ring": StatsManager.equiped_ring,
	"Amulet": StatsManager.equiped_amulet
	}

	var gear_slots = {
	"Hat": equiped_hats_sprite,
	"Coat": equiped_coats_sprite,
	"Boots": equiped_boots_sprite,
	"Ring": equiped_ring_sprite,
	"Amulet": equiped_amulets_sprite
	}

	for gear_type in equipped_gear.keys():
		var gear = equipped_gear[gear_type]
		if gear:
			gear_slots[gear_type].texture = gear.sprite  
		else:
			gear_slots[gear_type].texture = null 

func _on_unequip_button_pressed(gear_type: String):
	var gear_map = {
		"HAT": "equiped_hat",
		"COAT": "equiped_coat",
		"BOOTS": "equiped_boots",
		"RING": "equiped_ring",
		"AMULET": "equiped_amulet"
	}
	if gear_type in gear_map:
		var gear_ref = StatsManager[gear_map[gear_type]]
		if gear_ref:
			reset_stats(gear_ref)
			gear_ref.equip_slot = 0
			StatsManager[gear_map[gear_type]] = null
	
	update_equiped_gear()
	update_bonus_stats()
	get_gear_items()


func reset_stats(gear: GearData):
	if gear == null:
		return
	
	StatsManager.max_health -= gear.extra_health
	StatsManager.current_health -= gear.extra_health
	StatsManager.current_health = StatsManager.max_health
	StatsManager.health_changed.emit()
	#player.regeneration -= gear.regenaration
	player.speed /= (1 + gear.speed_multiplier / 100.0)
	
	#if StatsManager.equiped_weapon_1:
		#StatsManager.equiped_weapon_1.damage /= (1 + gear.damage_multiplier / 100.0) TODO
		#StatsManager.equiped_weapon_1.fire_rate /= (1 + gear.fire_rate_multiplier / 100.0)
		#StatsManager.equiped_weapon_1.critical_hit_chance /= (1 + gear.critical_hit_multiplier / 100.0)

func update_equiped_gear():
	
	equiped_hats_sprite.texture = StatsManager.equiped_hat.sprite if StatsManager.equiped_hat else null
	equiped_coats_sprite.texture = StatsManager.equiped_coat.sprite if StatsManager.equiped_coat else null
	equiped_boots_sprite.texture = StatsManager.equiped_boots.sprite if StatsManager.equiped_boots else null
	equiped_ring_sprite.texture = StatsManager.equiped_ring.sprite if StatsManager.equiped_ring else null
	equiped_amulets_sprite.texture = StatsManager.equiped_amulet.sprite if StatsManager.equiped_amulet else null
	
	
	for gear_button in grid_container.get_children():
		if gear_button.gear in [
			StatsManager.equiped_hat, StatsManager.equiped_coat,
			StatsManager.equiped_boots, StatsManager.equiped_ring,
			StatsManager.equiped_amulet
		]:
			gear_button.visible = false  
		else:
			gear_button.visible = true   #

func update_inventory_visibility():
	for child in grid_container.get_children():
		if child is TextureButton and child.gear:
			child.visible = (child.gear.equip_slot == 0)  # Visible si non équipé
