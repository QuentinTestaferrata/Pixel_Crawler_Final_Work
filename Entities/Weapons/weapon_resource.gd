extends Resource
class_name WeaponData

enum weapon_types {STAFF, WAND, SHIELD, SWORD, DAGGER, BOW}
enum rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC}

@export_category("Weapon Data")
@export var weapon_name: String
@export var scene: PackedScene
@export var sprite: Texture
@export var shop_sprite: Texture
@export var showcase_sprite: Texture = null
@export var price: int
@export var weapon_level: int = 1
@export var obtained: bool = false
@export var equip_slot: int = 0

@export_category("Attacks")
@export var primary_attack: PROJECTILE
@export var primary_attack_sprite: Texture
@export var secondary_attack: PROJECTILE
@export var secondary_attack_sprite: Texture
@export var special_attack: PROJECTILE
@export var special_attack_sprite: Texture

@export_category("Weapon Stats")
@export var weapon_type: weapon_types
@export var weapon_rarity: rarity
@export_enum("Common", "Uncommon", "Rare" , "Epic", "Legendary", "Mythic") var weapon_rarity_str: String
@export var damage: int
@export var knockback_force: float
@export var defense: int

@export_category("Other")
@export_multiline var description: String
@export var two_handed: bool
