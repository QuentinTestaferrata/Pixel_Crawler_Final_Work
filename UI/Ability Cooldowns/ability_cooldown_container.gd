extends PanelContainer

const ABILITY_BUTTON = preload("res://UI/Ability Cooldowns/ability_button.tscn")

var weapon_1_sprite: TextureRect
var weapon_1_primary: TextureButton
var weapon_1_secondary: TextureButton

var weapon_2_sprite: TextureRect
var weapon_2_primary: TextureButton
var weapon_2_secondary: TextureButton

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var texture_rect_2: TextureRect = $MarginContainer/HBoxContainer/TextureRect2

func _ready() -> void:
	if StatsManager.equiped_weapon_1:
		if StatsManager.equiped_weapon_1.showcase_sprite:
			display_cooldowns(StatsManager.equiped_weapon_1.showcase_sprite, texture_rect)
		else:
			display_cooldowns(StatsManager.equiped_weapon_1.sprite, texture_rect)
		
		if StatsManager.equiped_weapon_1.primary_attack_sprite:
			weapon_1_primary = ABILITY_BUTTON.instantiate()
			weapon_1_primary.set_ability_sprite(StatsManager.equiped_weapon_1.primary_attack_sprite)
			texture_rect.add_sibling(weapon_1_primary)
		if StatsManager.equiped_weapon_1.secondary_attack_sprite:
			weapon_1_secondary = ABILITY_BUTTON.instantiate()
			weapon_1_secondary.set_ability_sprite(StatsManager.equiped_weapon_1.secondary_attack_sprite)
			weapon_1_primary.add_sibling(weapon_1_secondary)
		
	if StatsManager.equiped_weapon_2:
		if StatsManager.equiped_weapon_2.showcase_sprite:
			display_cooldowns(StatsManager.equiped_weapon_2.showcase_sprite, texture_rect_2)
		else:
			display_cooldowns(StatsManager.equiped_weapon_2.sprite, texture_rect_2)
			
		if StatsManager.equiped_weapon_2.primary_attack_sprite:
			weapon_2_primary = ABILITY_BUTTON.instantiate()
			weapon_2_primary.set_ability_sprite(StatsManager.equiped_weapon_2.primary_attack_sprite)
			texture_rect_2.add_sibling(weapon_2_primary)
		if StatsManager.equiped_weapon_2.secondary_attack_sprite:
			weapon_2_secondary = ABILITY_BUTTON.instantiate()
			weapon_2_secondary.set_ability_sprite(StatsManager.equiped_weapon_2.secondary_attack_sprite)
			weapon_2_primary.add_sibling(weapon_2_secondary)
		
func display_cooldowns(_texture: CompressedTexture2D, _texture_rect: TextureRect) -> void:
	_texture_rect.texture = _texture
	_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

func start_cooldown(attack: int, time: float) -> void:
	#print("attack: ", attack, " | time: ", time)
	match(attack):
		1:
			weapon_1_primary.start(time)
		2: 
			weapon_1_secondary.start(time)
		3: 
			weapon_2_primary.start(time)
		4: 
			weapon_2_secondary.start(time)
