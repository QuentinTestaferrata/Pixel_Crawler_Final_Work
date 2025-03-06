extends Control

@export var weapon_inventory: PanelContainer

var selected_weapon: WeaponData

@onready var primary_sprite: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/PrimaryAttackContainer/PrimarySprite
@onready var primary_damage_label: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/PrimaryAttackContainer/MarginContainer/PrimaryDamageLabel
@onready var secondary_sprite: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SecondaryAttackContainer/secondarySprite
@onready var secondary_damage_label: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SecondaryAttackContainer/MarginContainer/secondaryDamageLabel
@onready var weaponrarity_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WeaponrarityLabel
@onready var weapon_level_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WeaponLevelLabel

@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	$AnimationPlayer.play("spawn")
	weapon_inventory.connect("weapon_clicked", update_stats)

func update_stats() -> void:
	print("Updating stats")
	if !panel_container.visible:
		$AnimationPlayer.play("show_stats")
	weapon_level_label.text = str("Level: ", selected_weapon.weapon_level)
	weaponrarity_label.text = selected_weapon.weapon_rarity_str
	apply_rarity_colors(selected_weapon.weapon_rarity_str)
	
	primary_sprite.texture = selected_weapon.primary_attack_sprite
	primary_damage_label.text = str("damage: ", selected_weapon.primary_attack.DAMAGE)
	
	secondary_sprite.texture = selected_weapon.secondary_attack_sprite
	secondary_damage_label.text = str("damage: ", selected_weapon.secondary_attack.DAMAGE)

func close_window() -> void:
	$AnimationPlayer.play("close")

func apply_rarity_colors(rarity: String) -> void:
	match rarity:
		"Common":
			override_colors(Color(0.502, 0.502, 0.502), Color(0.758, 0.758, 0.758))
		"Uncommon": 
			override_colors(Color(0.099, 0.886, 0.0), Color(0.606, 1.0, 0.567))
		"Rare":
			override_colors(Color(0.0, 0.439, 0.867), Color(0.394, 0.658, 1.0))
		"Epic": 
			override_colors(Color(0.657, 0.303, 1.0), Color(0.82, 0.594, 1.0))
		"Legendary":
			pass
		"Mythic":
			pass

func override_colors(font_color: Color, font_outline_color: Color) -> void:
	weaponrarity_label.add_theme_color_override("font_color", font_color)
	weaponrarity_label.add_theme_color_override("font_outline_color", font_outline_color)
	
	
	
	
	
